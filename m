From: "Jon Nelson" <jnelson@jamponi.net>
Subject: Re: Reading takes 100% precedence over writes for mdadm+raid5?
Date: Sat, 8 Dec 2007 18:13:26 -0600
Message-ID: <cccedfc60712081613t78451d3fm97ea782eef2be0ec@mail.gmail.com>
References: <Pine.LNX.4.64.0712021807260.10289@p34.internal.lan>
	 <47581F2E.7020400@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47581F2E.7020400@tmr.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is what dstat shows me copying lots of large files about (ext3),
one file at a time.
I've benchmarked the raid itself around 65-70 MB/s maximum actual
write I/O so this 3-4MB/s stuff is pretty bad.

I should note that ALL other I/O suffers horribly, even on other filesystems.
What might the cause be?

I should note: going larger in stripe_cache_size (384 and 512)
performance stays the same, going smaller (128) performance
*increases* and stays more steady to 10-13 MB/s.


----total-cpu-usage---- --dsk/sda-- --dsk/sdb-- --dsk/sdc--
--dsk/sdd-- -dsk/total->
usr sys idl wai hiq siq| read  writ: read  writ: read  writ: read
writ: read  writ>
  1   1  95   3   0   0|  12k 4261B: 106k  125k:  83k  110k:  83k
110k: 283k  348k>
  0   5   0  91   1   2|   0     0 :2384k 4744k:2612k 4412k:2336k
4804k:7332k   14M>
  0   4   0  91   1   3|   0     0 :2352k 4964k:2392k 4812k:2620k
4764k:7364k   14M>
  0   4   0  92   1   3|   0     0 :1068k 3524k:1336k 3184k:1360k
2912k:3764k 9620k>
  0   4   0  92   1   2|   0     0 :2304k 2612k:2128k 2484k:2332k
3028k:6764k 8124k>
  0   4   0  92   1   2|   0     0 :1584k 3428k:1252k 3992k:1592k
3416k:4428k   11M>
  0   3   0  93   0   2|   0     0 :1400k 2364k:1424k 2700k:1584k
2592k:4408k 7656k>
  0   4   0  93   1   2|   0     0 :1764k 3084k:1820k 2972k:1796k
2396k:5380k 8452k>
  0   4   0  92   2   3|   0     0 :1984k 3736k:1772k 4024k:1792k
4524k:5548k   12M>
  0   4   0  93   1   2|   0     0 :1852k 3860k:1840k 3408k:1696k
3648k:5388k   11M>
  0   4   0  93   0   2|   0     0 :1328k 2500k:1640k 2348k:1672k
2128k:4640k 6976k>
  0   4   0  92   0   4|   0     0 :1624k 3944k:2080k 3432k:1760k
3704k:5464k   11M>
  0   1   0  97   1   2|   0     0 :1480k 1340k: 976k 1564k:1268k
1488k:3724k 4392k>
  0   4   0  92   1   2|   0     0 :1320k 2676k:1608k 2548k: 968k
2572k:3896k 7796k>
  0   2   0  96   1   1|   0     0 :1856k 1808k:1752k 1988k:1752k
1600k:5360k 5396k>
  0   4   0  92   2   1|   0     0 :1360k 2560k:1240k 2788k:1580k
2940k:4180k 8288k>
  0   2   0  97   1   2|   0     0 :1928k 1456k:1628k 2080k:1488k
2308k:5044k 5844k>
  1   3   0  94   2   2|   0     0 :1432k 2156k:1320k 1840k: 936k
1072k:3688k 5068k>
  0   3   0  93   2   2|   0     0 :1760k 2164k:1440k 2384k:1276k
2972k:4476k 7520k>
  0   3   0  95   1   2|   0     0 :1088k 1064k: 896k 1424k:1152k
992k:3136k 3480k>
  0   0   0  96   0   2|   0     0 : 976k  888k: 632k 1120k:1016k
968k:2624k 2976k>
  0   2   0  94   1   2|   0     0 :1120k 1864k: 964k 1776k:1060k
1856k:3144k 5496k>

-- 
Jon
