From: "Timothy C. McGrath" <misty-@charter.net>
Subject: sw raid+ext3 in linux kernel 2.4/2.6 series
Date: Sat, 24 Jul 2004 04:12:59 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <41021A0B.20807@charter.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

I have been using vanilla linux kernel 2.4.26 with no problems
whatsoever, however I've heard rumors of filesystem corruption with
software raid5 and ext3 in the 2.6 series. This is the largest problem
in the 2.6 series that is holding me back from trying it out; I'd have a
really bad day if I lost all the data on my disks.

I'd like to know if in fact the vanilla 2.6 kernels have any known
problems with software raid5 and ext3, and while I'm at it, if there are
any known problems with the usage of sw raid5 and ext3 in the
2.4.26/2.4.27-rc kernels. (Though I have yet to see any problems
whatsoever.)

I'm not afraid to do patches to my kernel to achieve the desired effects :)

Also, is there any URL which shows the known or fixed bugs in software
raid in the various kernels? I haven't been able to find any so... Just
asking.

Timothy C. McGrath
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://enigmail.mozdev.org

iD8DBQFBAhoL4pPTiiJCEYkRAv43AJ9/AZp/Q4tc2evE/YR09RrbINfLugCfTXOx
vqzr+/Zi0Cz0RB6Np6j2/qM=
=pmrM
-----END PGP SIGNATURE-----
