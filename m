From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Raid over 48 disks
Date: Wed, 19 Dec 2007 10:26:31 -0500
Message-ID: <47693827.6070604@tmr.com>
References: <00EF99B2-3BCC-4D75-BC75-8F256B0A2476@gmail.com> <18280.11620.381726.737353@notabene.brown> <Pine.GSO.4.64.0712190918430.1549@montezuma.acc.umu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.GSO.4.64.0712190918430.1549@montezuma.acc.umu.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mattias Wadenstein <maswan@acc.umu.se>
Cc: Neil Brown <neilb@suse.de>, Norman Elton <normelton@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mattias Wadenstein wrote:
> On Wed, 19 Dec 2007, Neil Brown wrote:
>
>> On Tuesday December 18, normelton@gmail.com wrote:
>>> We're investigating the possibility of running Linux (RHEL) on top of
>>> Sun's X4500 Thumper box:
>>>
>>> http://www.sun.com/servers/x64/x4500/
>>>
>>> Basically, it's a server with 48 SATA hard drives. No hardware RAID.
>>> It's designed for Sun's ZFS filesystem.
>>>
>>> So... we're curious how Linux will handle such a beast. Has anyone run
>>> MD software RAID over so many disks? Then piled LVM/ext3 on top of
>>> that? Any suggestions?
>
> There are those that have run Linux MD RAID on thumpers before. I 
> vaguely recall some driver issues (unrelated to MD) that made it less 
> suitable than solaris, but that might be fixed in recent kernels.
>
>> Alternately, 8 6drive RAID5s or 6 8raid RAID6s, and use RAID0 to
>> combine them together.  This would give you adequate reliability and
>> performance and still a large amount of storage space.
>
> My personal suggestion would be 5 9-disk raid6s, one raid1 root mirror 
> and one hot spare. Then raid0, lvm, or separate filesystem on those 5 
> raidsets for data, depending on your needs.

Other than thinking raid-10 better than  raid-1for performance, I like it.
>
> You get almost as much data space as with the 6 8-disk raid6s, and 
> have a separate pair of disks for all the small updates (logging, 
> metadata, etc), so this makes alot of sense if most of the data is 
> bulk file access.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


