From: Phillip Susi <psusi@ubuntu.com>
Subject: Low resync throughput
Date: Fri, 27 Dec 2013 00:50:36 -0500
Message-ID: <52BD152C.5050301@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

I have been experimenting with setting up a raid array on 3 new drives
that are each capable of about 180 MB/s throughput.  I have tried
raid5 and raid10 in both offset and far layouts using both 64k and
512k chunk sizes, and the resync speed seems to always be
significantly less than the throughput of a single drive, even after I
write 500,000 to sync_speed_max.  The fastest of the bunch was raid10
in far mode, at ~140 MB/s, and the rest were around 110 MB/s.

I know it isn't a hardware bottleneck since I burned in the drives
with a badblocks run ( on each drive concurrently ) that managed an
aggregate throughput of ~500 MB/s according to iotop, so why is md
going so slow?

I'm using linux v3.12.0+ and mdadm v3.2.5.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBCgAGBQJSvRUsAAoJEI5FoCIzSKrwpP0H/R3qS9/ho2QipYi+lIULjFtd
I4nD44aKxoFGpQ55ZybNkCBPdtL6vB3r1KNKXW2CaM5uRLIUCnIMYrAbJJHF55+E
3DX22PBq+NZyczcxb26DBHUHg5Rgdt/glbgwFikC8eUuqkBCwDrOGlSNJSWrma+a
arqx2uNFsd0889AXzVxjk39UzadabMmD4SM0zfcqL7NYcbiv4VyQBD1fIhfu4X2W
UV5dmczaMQhGP2XWsD29pwGSQT3khL/ZGE72wXsA2QXpXvIIsBeUiXmlDBUTg/WY
SiyH0d2g8z76S8Ce4eD2aC6mBqq+ggn4zcnm5qjYmb5gMBT5SQwHwLqb+5bArDw=
=nU/G
-----END PGP SIGNATURE-----
