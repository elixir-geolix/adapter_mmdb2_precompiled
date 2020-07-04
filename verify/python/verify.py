import geoip2.database
import io

country = geoip2.database.Reader('../../data/GeoLite2-Country.mmdb')
ips     = io.open('../ip_set.txt', mode='r')
results = io.open('../python_results.txt', mode='w', encoding='utf-8')

for ip in ips:
  ip          = ip.strip()
  country_res = ''

  try:
    country_data = country.country(ip)
    country_res  = country_data.country.names['en']
  except:
    pass

  results.write(u'%s-%s\n' % (ip, country_res))

country.close()
results.close()
