From: Turbo Fredriksson <turbo@bayour.com>
Subject: Re: linux-raid compatable w/ Adaptec AIC-7902?
Date: Fri, 08 Jul 2005 14:40:22 +0200
Message-ID: <877jg1fp3d.fsf@pumba.bayour.com>
References: <200506300210.j5U2Acp04142@www.watkins-home.com>
	<200506301014.11454.eric@pretorious.net>
	<87r7eex14d.fsf@pumba.bayour.com>
	<200507071149.54019.eric@pretorious.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200507071149.54019.eric@pretorious.net> (Eric Pretorious's
 message of "Thu, 7 Jul 2005 11:49:53 -0700")
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Quoting Eric Pretorious <eric@pretorious.net>:

> On Monday 04 July 2005 04:27 am, Turbo Fredriksson wrote:
>>WHY are you putting multiple md's on the same disks? Did you intend to
>>do something like this?
>>
>>   md0          /boot      sd[ab]1
>>   md1          /          sd[ab]2
>>   md2          /usr       sd[ab]3
>>   md3          /var       sd[ab]4
>>
>>Just one question (this is the magic :). What do you gain by this? And
>>why do you do it?
>
> I'm just trying to mirror two disks - that's all. Is there a better way?

The keyword(s) here is _same disk_.

This is a very complicated way to do it... The idea behind partitioning the
disk(s) this way (many partition, one partition for 'each important FS') is
'to protect the root partition' (or rather 'protect the file systems from
each others failures'). That is, a crash in the /var FS (or that partition)
will not interfere against the /usr FS/partition etc...

This is almost a must to have ANY kind of security against data loss, but
but why do RAID; to protect the FS from hardrive failures...

This two ways of thinking is kinda the same thing, so why do all the
partitioning if one uses RAID?!

Just create ONE partition (plus a swap on each disk, totaling the total amount
of swap you want/need) and set that up as md0 (mounted as /) and that's it!

If a disk/partition crashes, then the RAID 'system' will kick in. If you're
mirroring the disks that is. It won't work if you'r joining disks to get more
space, which is quite pointless in the first place nowadays. Harddisks are so
cheap so just buy a bigger one...


In theory, the way you do it (and the way I used to to it previosly) way will
save you from filesystem (not hardware related!) crashes, but i haven't seen
a filesystem crash in years (ext[23] etc is getting _quite_ stable these days),
but even if the FS crashes the RAID should still kick in to save you data...


This is the way I'm reasoning at least. I might have missed something, and if
I have, I'm interessted in hearing why...
The weak point in my reasoning is if the RAID really saves you from _filesystem_
crashes... I think it does, but I'm not sure...
-- 
KGB Saddam Hussein Nazi toluene cracking NORAD ammunition Ft. Bragg
arrangements Cuba Peking FSF AK-47 Waco, Texas Soviet
[See http://www.aclu.org/echelonwatch/index.html for more about this]
