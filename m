From: David Kowis <dkowis@shlrm.org>
Subject: Re: mdadm memory leak?
Date: Fri, 08 Jul 2005 23:20:16 -0500
Message-ID: <42CF5080.8000609@shlrm.org>
References: <42CA0B7E.4040109@shlrm.org>	<17098.4949.378512.822529@cse.unsw.edu.au>	<20050705105229.7aisufvrk8so0ook@shlrm.org> <17098.64085.334793.282803@cse.unsw.edu.au> <42CEF85F.5060409@shlrm.org> <42CF091B.7030402@dtbb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <42CF091B.7030402@dtbb.net>
Sender: linux-raid-owner@vger.kernel.org
To: Tyler <pml@dtbb.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1


>> David, unless you have mdadm running in monitor mode, its not "actively"
>> in memory.. the MD driver is in the kernel, and in memory.  Mdadm is
>> simply a tool, just as fsck.ext2 or such.. its not active until you run
>> it, and leaves memory when it finishes its one task.  (Someone correct
>> me if I'm wrong please....).
> 
>> Tyler.
Well, perhaps you can point me in the right direction. I've got lots of slab usage by
 47061  47030  99%    0.05K    581       81      2324K buffer_head
and I'm just trying to find out what's eating the ram on my computer. It's got to be somehow connected to the md device that I'm using.
because this doesn't exist on any of my other computers that have a 2.6 kernel on them. Only the one with the mdadm created RAID array. I'm
not saying that it's mdadm, but perhaps some aspect of the md "system".
thanks for your time,

- --
David Kowis

ISO Team Lead - www.sourcemage.org
SourceMage GNU/Linux

One login to rule them all, one login to find them. One login to bring them all, and in the web bind them.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (MingW32)

iD8DBQFCz1CAtgErhgxHMHsRAmmXAJ4r0GXFKlTIKm++VW4aT+jklCvr2gCdEcXg
1lkWtJZ8AXE+M3kKTadiNdM=
=HVOK
-----END PGP SIGNATURE-----
