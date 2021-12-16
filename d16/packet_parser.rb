INPUT = %Q{E20D41802B2984BD00540010F82D09E35880350D61A41D3004E5611E585F40159ED7AD7C90CF6BD6BE49C802DEB00525272CC1927752698693DA7C70029C0081002140096028C5400F6023C9C00D601ED88070070030005C2201448400E400F40400C400A50801E20004C1000809D14700B67676EE661137ADC64FF2BBAD745B3F2D69026335E92A0053533D78932A9DFE23AC7858C028920A973785338832CFA200F47C81D2BBBC7F9A9E1802FE00ACBA44F4D1E775DDC19C8054D93B7E72DBE7006AA200C41A8510980010D8731720CB80132918319804738AB3A8D3E773C4A4015A498E680292B1852E753E2B29D97F0DE6008CB3D4D031802D2853400D24DEAE0137AB8210051D24EB600844B95C56781B3004F002B99D8F635379EDE273AF26972D4A5610BA51004C12D1E25D802F32313239377B37100105343327E8031802B801AA00021D07231C2F10076184668693AC6600BCD83E8025231D752E5ADE311008A4EA092754596C6789727F069F99A4645008247D2579388DCF53558AE4B76B257200AAB80107947E94789FE76E36402868803F0D62743F00043A1646288800084C3F8971308032996A2BD8023292DF8BE467BB3790047F2572EF004A699E6164C013A007C62848DE91CC6DB459B6B40087E530AB31EE633BD23180393CBF36333038E011CBCE73C6FB098F4956112C98864EA1C2801D2D0F319802D60088002190620E479100622E4358952D84510074C0188CF0923410021F1CE1146E3006E3FC578EE600A4B6C4B002449C97E92449C97E92459796EB4FF874400A9A16100A26CEA6D0E5E5EC8841C9B8FE37109C99818023A00A4FD8BA531586BB8B1DC9AE080293B6972B7FA444285CC00AE492BC910C1697B5BDD8425409700562F471201186C0120004322B42489A200D4138A71AA796D00374978FE07B2314E99BFB6E909678A0}
#INPUT = %Q{D2FE28}


class Package
  attr_accessor :version, :type, :value, :packages, :stop_position

  def initialize(version, type, value)
    @version = version
    @type = type
    @value = value
    packages = []
  end

  def has_sub_packages?
    return packages.size > 0
  end

end

DATA = INPUT.chars
           .map{ _1.to_i(16).to_s(2) }
           .map{ '%04d' % _1.to_i }
           .join

def parse_packet(data)
  version = data[0..2].to_i(2)
  type = data[3..5].to_i(2)

  if type == 4
    literal_number = ""
    start_pos = 6
    while true
      group = data[(start_pos)..(start_pos + 4)]
      literal_number += group[1..5]
      start_pos += 5
      break if group[0] == "0"
    end
    literal_number = literal_number.to_i(2)
    puts "Package version: #{version}, type: #{type}, literal: #{literal_number}"
    package = Package.new(version, type, literal_number)
    package.stop_position = start_pos

    return package
    return { version: version, type: type, value: literal_number, consumed: start_pos }
  else
    # so this is an operator package
    mode = data[6].to_i(2)
    if mode == 1
      length = data[7..17].to_i(2)
      start_pos = 18
      sub_packets = []
      length.times do
        sub_packets << parse_packet(data[start_pos..])
        start_pos += sub_packets[-1][:consumed]
      end
      return { version: version, type: type, value: sub_packets, consumed: start_pos }
    else
      # If the length type ID is 0,
      # then the next 15 bits are a number that represents the total length in bits
      # of the sub-packets contained by this packet.
      length = data[7..(7+14)].to_i(2)
      sub_packets_data = data[22..(22+length-1)]

      sub_packets = []
      while sub_packets_data.length > 0 do
        sub_packets << parse_packet(sub_packets_data)
        sub_packets_data = sub_packets_data[sub_packets[-1][:consumed]..]
      end
      return { version: version, type: type, value: sub_packets, consumed: 22+length }
    end
  end
end

def sum_version(packet)
  if packet[:value].is_a?(Array)
    packet[:version] + packet[:value].sum {|e| sum_version(e) }
  else
    packet[:version]
  end
end

def extract_value(packet)
  return packet[:value] if packet[:type] == 4
  values = packet[:value].map {|e| extract_value(e) }
  case packet[:type]
  when 0 then values.sum
  when 1 then values.reduce(:*)
  when 2 then values.min
  when 3 then values.max
  when 5 then (values[0] >  values[1] ? 1 : 0)
  when 6 then (values[0] <  values[1] ? 1 : 0)
  when 7 then (values[0] == values[1] ? 1 : 0)
  end
end

packet = parse_packet(DATA)
p sum_version(packet)

puts packet.flatten.inspect

