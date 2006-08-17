From: Michael Tokarev <mjt@tls.msk.ru>
Subject: spurious dots in dmesg when reconstructing arrays
Date: Thu, 17 Aug 2006 14:41:36 +0400
Message-ID: <44E447E0.9020006@tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

A long time ago I noticied pretty bad formatting of
dmesg text in md array reconstruction output, but
never bothered to ask.  So here it goes.

Example dmesg ("RAID conf printout" sections omitted):

md: bind<sdb1>
RAID1 conf printout:
..........<6>md: syncing RAID array md1
md: minimum _guaranteed_ reconstruction speed: 1000 KB/sec/disc.
md: using maximum available idle IO bandwith (but not more than 200000 KB/sec) for reconstruction.
md: using 128k window, over a total of 248896 blocks.
md: bind<sdb2>
RAID5 conf printout:
..........<6>md: delaying resync of md2 until md1 has finished resync (they share one or more physical units)
md: bind<sdb3>
RAID1 conf printout:
..........<6>md: delaying resync of md31 until md1 has finished resync (they share one or more physical units)
........<6>md: delaying resync of md2 until md31 has finished resync (they share one or more physical units)
md: bind<sdb5>
RAID5 conf printout:
........<6>md: delaying resync of md5 until md31 has finished resync (they share one or more physical units)
..........<6>md: delaying resync of md31 until md1 has finished resync (they share one or more physical units)
......<6>md: delaying resync of md2 until md5 has finished resync (they share one or more physical units)
md: bind<sdb6>
RAID1 conf printout:
......<6>md: delaying resync of md61 until md5 has finished resync (they share one or more physical units)
..........<6>md: delaying resync of md31 until md1 has finished resync (they share one or more physical units)
......<6>md: delaying resync of md2 until md5 has finished resync (they share one or more physical units)
........<6>md: delaying resync of md5 until md31 has finished resync (they share one or more physical units)
md: bind<sdb7>
RAID5 conf printout:
......<6>md: delaying resync of md7 until md5 has finished resync (they share one or more physical units)
..........<6>md: delaying resync of md31 until md1 has finished resync (they share one or more physical units)
........<6>md: delaying resync of md5 until md31 has finished resync (they share one or more physical units)
......<6>md: delaying resync of md2 until md5 has finished resync (they share one or more physical units)
..<6>md: delaying resync of md61 until md7 has finished resync (they share one or more physical units)
md: md1: sync done.
..<6>md: delaying resync of md61 until md7 has finished resync (they share one or more physical units)
......<6>md: delaying resync of md2 until md5 has finished resync (they share one or more physical units)
........<6>md: delaying resync of md5 until md31 has finished resync (they share one or more physical units)
...................<6>md: syncing RAID array md31
md: minimum _guaranteed_ reconstruction speed: 1000 KB/sec/disc.
md: using maximum available idle IO bandwith (but not more than 200000 KB/sec) for reconstruction.
md: using 128k window, over a total of 995904 blocks.
......<6>md: delaying resync of md7 until md5 has finished resync (they share one or more physical units)
RAID1 conf printout:
md: md31: sync done.
....RAID1 conf printout:
=== here, the actual conf printout is below:
...<6>md: delaying resync of md7 until md5 has finished resync (they share one or more physical units)
...................<6>md: syncing RAID array md5
md: minimum _guaranteed_ reconstruction speed: 1000 KB/sec/disc.
md: using maximum available idle IO bandwith (but not more than 200000 KB/sec) for reconstruction.
md: using 128k window, over a total of 666560 blocks.
===== here:
 --- wd:2 rd:2
 disk 0, wo:0, o:1, dev:sdb3
 disk 1, wo:0, o:1, dev:sdd3
..<6>md: delaying resync of md61 until md7 has finished resync (they share one or more physical units)
......<6>md: delaying resync of md2 until md5 has finished resync (they share one or more physical units)
md: md5: sync done.
........<6>md: delaying resync of md7 until md2 has finished resync (they share one or more physical units)
..<6>md: delaying resync of md61 until md7 has finished resync (they share one or more physical units)
..................<6>md: syncing RAID array md2
md: minimum _guaranteed_ reconstruction speed: 1000 KB/sec/disc.
md: using maximum available idle IO bandwith (but not more than 200000 KB/sec) for reconstruction.
md: using 128k window, over a total of 1252992 blocks.
RAID5 conf printout:
md: md2: sync done.
...<6>md: delaying resync of md61 until md7 has finished resync (they share one or more physical units)
..................<6>md: syncing RAID array md7
md: minimum _guaranteed_ reconstruction speed: 1000 KB/sec/disc.
md: using maximum available idle IO bandwith (but not more than 200000 KB/sec) for reconstruction.
md: using 128k window, over a total of 1999936 blocks.
RAID5 conf printout:
md: md7: sync done.
...................<6>md: syncing RAID array md61
md: minimum _guaranteed_ reconstruction speed: 1000 KB/sec/disc.
md: using maximum available idle IO bandwith (but not more than 200000 KB/sec) for reconstruction.
md: using 128k window, over a total of 30394880 blocks.
RAID5 conf printout:
md: md61: sync done.
RAID1 conf printout:

....

As you can see, there's a random number of dots before each
"<6>md: syncing RAID array .." message.  I guess this is sort of
progress meter for other arrays being synchronized.  Obviously,
such a long lines (long in terms of *time* required to complete
the line, not in terms of line length) should not be in dmesg
in the first place.

But the thing is: I've no idea where this dot is coming from... ;)

Can we fix this umm.. misformatting please? ;)

Thanks.

/mjt
