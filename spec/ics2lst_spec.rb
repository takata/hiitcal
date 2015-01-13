RSpec.describe 'ics2lst' do
  let (:result) do
    <<STRING
2015-01-15 21:30 [広島]VMware VCP5-DCV試験準備コース http://info.vmware.com/content/apac_jp_co_education-certification
2015-01-16 13:00 [広島]a-blog cms DAY in Hiroshima 2015/01 #ablogcms https://www.facebook.com/events/768921726527916/?ref=51&source=1
2015-01-17 13:30 [広島] #広島でコンクリ vol.6『新年の抱負と 5.7 テーマ雑談会』 http://concrete5hiroshima.doorkeeper.jp/events/19445
2015-01-17 10:30 [広島]楽しいエクセル2010実用講座 http://www.cf.city.hiroshima.jp/m-plaza/pdf/h26shimokitanoshiiexcel2010jituyou.pdf
2015-01-17 13:30 [広島]楽しいワード2010実用講座 http://www.cf.city.hiroshima.jp/m-plaza/pdf/h26shimokitanoshiiwordl2010jituyou.pdf
2015-01-21 18:00 [広島][予定]すごい広島 http://great-h.doorkeeper.jp/
2015-02-06 13:30 [広島] IPv6セミナー2015 Winter　-生活に溶け込むモバイルとIPv6-  http://www.supercsi.jp/ipv6deploy/modules/eguide/event.php?eid=24
STRING
  end

  subject { `./ics2lst.rb < spec/resource/basic.ics` }

  it 'exec' do
    is_expected.to eq(result)
  end
end
