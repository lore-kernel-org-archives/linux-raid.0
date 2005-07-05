From: David Kowis <dkowis@shlrm.org>
Subject: mdadm memory leak?
Date: Mon, 04 Jul 2005 23:24:30 -0500
Message-ID: <42CA0B7E.4040109@shlrm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Eric Sandall <eric@sandall.us>
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

I'm not entirely sure if this is mdadm's fault, but I cannot find anything else that would cause the problem, since mdadm is the only new
thing and I'm pretty sure it's not 2.6.11.12's fault. Anyways, on to my issue:
I'm running samba, apache2, mysql, postgresql, and a few other things. I've got an Athlon-XP 1700+ with 768Mb RAM. Right after startup I've
got about 600Mb of free memory, and as time progresses, and I use samba for things (playing an MP3,) my amount of free memory declines
rather rapidly. It hovers around 8Mb of free ram, with no swap usage. The computer has bogged down bad enough that oom-killer has had to
kill just about everything. ps and top don't show anything eating up all my memory. I'm very impressed with mdadm and I'd like to keep using
it, but i'd also like to have a bit of free memory on my computer. I'm using an XFS file system on a 200Gb mirrored RAID array, two drives,
on seperate IDE channels (seperate cables.)
Thanks for your time,
- --
David Kowis

ISO Team Lead - www.sourcemage.org
SourceMage GNU/Linux

One login to rule them all, one login to find them. One login to bring them all, and in the web bind them.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (MingW32)

iD8DBQFCygt+tgErhgxHMHsRAqr+AJ9BtFcFXGKJtE7Ec5mZ25rRn7SD0ACePwzo
C86x7ogIqvFbtQRsgUZihwg=
=gX4c
-----END PGP SIGNATURE-----
