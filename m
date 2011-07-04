From: Petter Reinholdtsen <pere@hungry.com>
Subject: Re: Help with recovering resized raid where machine crashed while PENDING
Date: Mon, 4 Jul 2011 16:21:27 +0200
Message-ID: <20110704142127.GU21845@login1.uio.no>
References: <2flfwmpdpw2.fsf@login1.uio.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2flfwmpdpw2.fsf@login1.uio.no>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

[Petter Reinholdtsen]
> Any ideas how I can recover my raid? After reading
> <URL: https://raid.wiki.kernel.org/index.php/RAID_Recovery >, I
> suspect creating it again is the solution, but am unsure if I should
> recreate it with 3 or 5 partitions.  Trying to assembly result in this:

> 
> meta:~# mdadm --assemble /dev/md3 /dev/sdd2 /dev/sde2 /dev/sdh2 /dev/sda2 /dev/sdb2
> mdadm: Failed to restore critical section for reshape, sorry.
>       Possibly you needed to specify the --backup-file
> meta:~#  
> 
> How can I know which disks to use when recreating if I want to
> recreate using only three disks?  Is it the three with the active
> state?

This is still a problem.  I got some help from JyZyXEL on #linux-raid,
and managed to get md2 to continue its reshaping with mdadm
--readwrite /dev/md2, but the raid that was pending its reshaping is
still failing to assemble with the above message.

Is this the only approach to recover?

  mdadm --create --assume-clean --level=5 --raid-devices=5 /dev/md3 /dev/sd?2

Should I use --raid-devices=3 or --raid-devices=5, and if I should use
--raid-devices=3, how do I figure which devices to use?

Happy hacking,
-- 
Petter Reinholdtsen
