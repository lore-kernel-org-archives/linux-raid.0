From: Juri Haberland <list-linux.raid@spoiled.org>
Subject: Re: invalud argument when replacing disk of raid 5 set
Date: Sat, 8 Nov 2003 17:23:19 +0000 (UTC)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <news2mail-boj8q7$g8p$1@cartman.spoiled.org>
References: <3FAC523E.3050509@eglifamily.dnsalias.net> <news2mail-boj5ci$leu$1@cartman.spoiled.org> <3FAD1C2E.5010706@eglifamily.dnsalias.net>
Reply-To: Juri Haberland <juri@koschikode.com>
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dan Egli <dan@eglifamily.dnsalias.net> wrote:
> Juri Haberland wrote:

> | What commands do you exactly type and what error messages do you
> | exactly get?
> |
> This is from memory because I"m at home and the machine is at the
> office. But it should be close enough.
> 
> # raidstart /dev/md0
> raidstart: Invalid Argument
> 
> if I let the system auto-start it during boot, it looks like this:
> 
> Starting Raid Devices: /dev/md0
> raidstart: Invalid Argument
> /dev/md0 is not a RAID0 or LINEAR set

I think you should use mdadm:

mdadm --assemble /dev/md0 /dev/hdc1 /dev/hdd1 --run
mdadm --manage /dev/md0 --add /dev/hdb1

Cheers,
Juri

-- 
Juri Haberland  <juri@koschikode.com> 

