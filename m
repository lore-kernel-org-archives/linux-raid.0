From: Andrei Badea <andrei.badea@movzx.net>
Subject: Re: Weird RAID 1 performance
Date: Sun, 19 Sep 2004 18:42:10 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <414DB6E2.5040606@movzx.net>
References: <Pine.LNX.4.44.0409191043350.2576-100000@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig6AAD8551E6ACFDFBBCAAEE00"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0409191043350.2576-100000@coffee.psychology.mcmaster.ca>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig6AAD8551E6ACFDFBBCAAEE00
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hello Mark and Gordon,

thank you both for your answers.

Mark Hahn wrote:

 >>> I have a RAID 1 whose write performance I tested by writing a 10 GB file
 >
 >
 >
 > but under which kernel?


Sorry :-( It's 2.6.7 with the Debian patches, self-compiled.

 >>> Looking at GKrellM I noticed the CPU usage is very jumpy, going from a
 >
 >
 >
 > that's some sort of gui monitoring tool, right?  I usually use "setrealtime 
vmstat 1" for this kind of thing, since it's at least a layer or two closer to 
the true numbers.


I'm attaching the output from "setrealtime vmstat 1". You can see the "jumps" 
caused by executing

dd if=/dev/zero of=bigfile bs=1024 count=1048576

on my root partition, which is not on RAID. So it seems I'm having problems not 
with RAID, but with any high bandwidth disk transfer.

procs -----------memory---------- ---swap-- -----io---- --system-- ----cpu----
  r  b   swpd   free   buff  cache   si   so    bi    bo   in    cs us sy id wa
  2  0      0 324528   2628  52892    0    0    54   478 1582   920 10  2 86  2
  0  0      0 324336   2628  52892    0    0     0     0 2083  1823 11  1 88  0
  0  0      0 324336   2628  52892    0    0     0     0 2093  1521  3  1 96  0
  0  1      0 324328   2664  52892    0    0    36     0 2097  1600  4  2 87  7
  0  1      0 323560   3400  52892    0    0   724   148 2262  1711  2 10  0 88
  1  0      0 278184   3808  97340    0    0   360     0 2170  1541  4 57  0 39
  1  2      0 209192   3876 164540    0    0     0 34560 2380  2028 12 88  0  0
  1  2      0 136088   3944 235776    0    0     0 33728 2351  1625  8 92  0  0
  1  2      0  60376   4016 309596    0    0     0 33280 2342  1603  6 94  0  0
  0  4      0  39576   4036 330736    0    0     0 37368 2345  1469  4 31  0 65
  1  3      0  17016    580 356036    0    0     0 29768 2334  1391  7 75  0 18
  0  4      0   3320    600 369252    0    0     8 24576 2258  1594  3 27  0 70
  0  4      0   3064    640 369124    0    0     0 32768 2338  1709  5 52  0 43
  0  4      0   2872    672 369016    0    0     8 28616 2310  1709  4 45  0 51
  0  4      0   3400    696 368508    0    0     4 23708 2287  1662  3 36  0 61
  0  5      0   3648    736 368288    0    0     8 30264 2285  1618  4 32  0 64
  0  5      0   3520    772 368384    0    0     4 30724 2328  1523  4 45  0 51
  0  6      0   3868    780 368400    0    0     0 32388 2341  1560  3 18  0 79
  1  5      0   3000    800 369820    0    0     0 28416 2303  1473  3 29  0 68
  0  6      0   3192    856 369456    0    0     0 31616 2323  1648  6 83  0 11
  1  5      0   3192    876 369264    0    0     4 32384 2333  1764  5 48  0 47
  0  7      0   3128    900 369264    0    0     0 28608 2364  1597  4 50  0 46
  4  7      0   2928    920 369348    0    0     4 29072 2304  1581  4 33  0 63
  1  6      0   3312    960 368832    0    0     0 27884 2330  1582  5 50  0 45
  0  7      0   3952    980 368536    0    0     0 31240 2325  1464  3 33  0 64
  0  8      0   3184    992 369584    0    0     4 28680 2275  1456  3 11  0 86
  1  7      0   2928   1012 370028    0    0     0 28444 2333  1476  4 45  0 51
  0  8      0   3120   1032 369904    0    0     0 32796 2346  1479  4 40  0 56
  1  6      0   4588   1052 368452    0    0     4 32820 2340  1437  4 33  0 63
  2  2      0   3432   1096 369004    0    0     0 29436 2351  1572  7 68  0 25
  0  9      0   3196   1164 368900    0    0     0 33628 2316  1939  6 91  0  3
  1  7      0   3304   1196 368852    0    0     4 25904 2318  1522  3 41  0 56
  0  8      0   3560   1212 369060    0    0     0 35584 2330  1551  4 23  0 73
  0  9      0   2920   1036 370400    0    0     0 28696 2321  1505  3 55  0 42
  1  8      0   3048   1032 370072    0    0     0 32796 2329  1483  4 38  0 58
  0  7      0   3240    972 369532    0    0     0 28684 2324  1463  5 36  0 59
  0  7      0   3240    972 369532    0    0     0 32512 2331  1436  2  3  0 95

Are these numbers normal?

Also:

root@farpoint:tam0# hdparm /dev/hda

/dev/hda:
  multcount    = 16 (on)
  IO_support   =  1 (32-bit)
  unmaskirq    =  1 (on)
  using_dma    =  1 (on)
  keepsettings =  0 (off)
  readonly     =  0 (off)
  readahead    = 256 (on)
  geometry     = 65535/16/63, sectors = 78165360, start = 0

So DMA is ok. Gordon: the disks in the RAID also have DMA turned on.

 >>> few to 99 percent (but usually is roughly rovers around 50 percent).
 >>> Moreover, the transfer regularly stops for a few seconds (the CPU usage
 >>> is then about 2 percent). The average data transfer rate was 16 MB/s,
 >>> while the disks alone can make almost 25 MB/s.
 >
 >
 > sounds a bit like a combination of poor VM (certainly the case for the VM in 
some kernels), and possibly /proc/sys/vm settings.


Any thoughts, links, anything on these settings? I must admit I've never done 
this, but I'm happy to learn.

 >> The next thing to look for is interrupt sharing. I've found a lot of
 >
 >
 >
 > I doubt this is an issue - shared interrupts can result in a few extra IOs 
per interrupt (as the wrong driver checks its device),
 > but I'd be very surprised to find this affecting performance unless
 > the device is very slow or the irq rate very high (1e5 or so).


To answer to Gordon, I'm not using APIC at all.

 >>> Is this normal behavior? Can the write performance be tuned (to be less
 >>> "jumpy")?
 >
 >
 > certainly.  in 2.4 kernels, it was trivial to set bdflush to wake up every 
second, rather than every 5 seconds (the default).  I do this on a fairly 
heavily loaded fileserver, since the particular load rarely sees any 
write-coalescing benefit past a few ms.


What about 2.6 kernels?

 >> Interupts (and/or more likely the controllers) seem to me to be the
 >> biggest bug/feature of a modern motherboard )-: I've seen systems work
 >
 >
 >>> Maybe the RAID 1 is just not suited for video capture?
 >
 >
 > it's fine; the problem, if any, is your config.  what's the bandwidth
 > you need to write?  what's the bandwidth of your disks (after accounting
 > for the fact that every block is written twice)?  you should have a couple
 > seconds of buffer, at least, to "speed-match" the two rates, even if your 
producer (capture) is significantly slower than the bandwidth of your raid1. 
note also that your capture card could well be eating lots of cpu and/or 
perturbing the kernel's vm.


The bandwidth is about 8 MB/s. Each disk alone can write at about 25 MB/s and 
they are identical. The capture is indeed taking lots of CPU (see the next 
vmstat output), but is it so much that the whole thing hangs?

procs -----------memory---------- ---swap-- -----io---- --system-- ----cpu----
  r  b   swpd   free   buff  cache   si   so    bi    bo   in    cs us sy id wa
  2  0      0 157868   1584  52972    0    0  3420     0 1127   733 23  5 31 40
  0  0      0 156524   1584  52972    0    0     0     0 1138   665 67  3 30  0
  1  0      0 156396   1584  52972    0    0     0     0 1139   684 68  3 29  0
  1  0      0 156204   1592  52972    0    0     0   124 1140   704 66  5 28  1
  1  0      0 156012   1592  52972    0    0     0     0 1214   719 67  4 29  0
  1  0      0 156140   1592  52972    0    0     0   256 1336   881 71  5 24  0
  2  0      0 155116   1592  52972    0    0     0     0 1147  1202 75  4 21  0
  1  0      0 154940   1592  52972    0    0     0     0 1138   657 68  3 29  0
  2  0      0 154748   1592  52972    0    0     0     0 1138   624 66  4 30  0
  1  0      0 154556   1600  52972    0    0     0    12 1142   712 65  4 31  0
  0  0      0 171132   1600  52972    0    0     0     0 1130   697 67  3 30  0

Again, thank you for help.

Andrei

-- 
andrei.badea@movzx.net # http://movzx.net # ICQ: 52641547


--------------enig6AAD8551E6ACFDFBBCAAEE00
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://enigmail.mozdev.org

iD8DBQFBTbbipU04Z80csh8RAp4NAKCbCnnwFs0bARQKGhBF5Z7AA9mF9ACgl3KO
zLiCRT9fFItj4WW4wED7crE=
=uLGF
-----END PGP SIGNATURE-----

--------------enig6AAD8551E6ACFDFBBCAAEE00--
