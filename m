From: Moshe Yudkowsky <moshe@pobox.com>
Subject: Yes, but please provide the clue (was Re: [PATCH] Use new sb type)
Date: Tue, 29 Jan 2008 05:25:20 -0600
Message-ID: <479F0D20.20306@pobox.com>
References: <Pine.LNX.4.64.0801281818430.1185@fbirervta.pbzchgretzou.qr> <479E1C95.1040008@dgreaves.com> <479E232E.1030801@rabbit.us> <479E2DDA.5040102@dgreaves.com> <479EA6DE.9070503@dionic.net> <479EF3C8.7010509@rabbit.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <479EF3C8.7010509@rabbit.us>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> * The only raid level providing unfettered access to the underlying 
> filesystem is RAID1 with a superblock at its end, and it has been common 
> wisdom for years that you need RAID1 boot partition in order to boot 
> anything at all.

Ah. This shines light on my problem...

> The problem is that these three points do not affect any other raid 
> level (as you can not boot from any of them in a reliable fashion 
> anyway). I saw a number of voices that backward compatibility must be 
> preserved. I don't see any need for that because:
> 
> * The distro managers will definitely RTM and will adjust their flashy 
> GUIs to do the right thing by explicitly supplying -e 1.0 for boot devices

The Debian stable distro won't let you create /boot on an LVM RAID1, but 
that seems to be the extent of current RAID awareness. Using the GUI, if 
you create a large RAID5 and attempt to boot off it  -- well, you're 
toast, but you don't find out until LILO and grub portion of the 
installation fails.

> * A clueless user might burn himself by making a single root on a single 
> raid1 device. But wait - he can burn himself the same way by making the 
> root a raid5 device and rebooting.

Okay, but:

> Why do we sacrifice "the right thing to do"? To eliminate the 
> possibility of someone shooting himself in the foot by not reading the 
> manual?

Speaking for clueless users everywhere: I'd love to Read The Fine 
Manual, but the Fine md, mdadm, and mdadm.conf Manuals that I've read 
don't have information about grub/LILO issues. A hint such as "grub and 
LILO can only work from RAID 1 and superblocks greater than 1.0 will 
toast your system in any case" is crucial information to have. Not 
everyone will catch this particular thread -- they're going to RTFM and 
make a mistake *regardless*.

And now, please excuse me while I RTFM to find out if I change the 
superblocks to 1.0 from 1.2 on a running array...

-- 
Moshe Yudkowsky * moshe@pobox.com * www.pobox.com/~moshe
  "If you're not part of the solution, you're part of the process."
    				-- Mark A. Johnson
