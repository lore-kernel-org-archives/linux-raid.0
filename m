From: Mitchell Laks <mlaks@verizon.net>
Subject: Re: convert degraded raid1 drive to ext3 format
Date: Mon, 10 Jan 2005 17:54:42 -0500
Message-ID: <200501101754.42563.mlaks@verizon.net>
References: <200501101640.j0AGed921972@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-8-i"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200501101640.j0AGed921972@www.watkins-home.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Guy,


On Monday 10 January 2005 11:40 am, you wrote:
> First, use mdadm, not the obsolete raidtools!
>
> You could create 3 arrays, each with 1 disk missing, then add/remove the
> extra disk where needed.  Your system and filesystems would be up and
> running during the add and remove, and all other times, if you want.
>
> The disks should be partitioned.  Partition type FD (RAID autodetect).
> If you have data on these drives that you want to keep, please explain.
>
> To create the arrays:
> mdadm -C /dev/md0 -l1 -n2 /dev/hda1 missing
> mdadm -C /dev/md1 -l1 -n2 /dev/hdc1 missing
> mdadm -C /dev/md2 -l1 -n2 /dev/hde1 missing
>
> Create your ext3 filesystems on /dev/md0 md1 and md2.
>
> To add the extra disk:
> mdadm /dev/md0 -a /dev/hdg1
>
> A re-sync or re-build will start.  But your filesystem is still usable.
>
> To remove the extra disk:
> First fail it:
> mdadm /dev/md0 -f /dev/hdg1
> Then remove it.
> mdadm /dev/md0 -r /dev/hdg1
>
> Now you can add it to another array.
>
> Just be sure to not fail a disk if the other disk in the array has failed!
> Or, game over!
>
> Guy
>
thank you very much, for your detailed guide to using mdadm.
I now understand it more. I will try to use it from now on. I must review how 
a  nice configuration file gets created by these actions so that I can keep 
track of what I did on the machine (similar to /etc/raidtab which is easy to 
review).

PS. I like the game over bit :) !

I have practiced last night with using raidsetfaulty and raidhotadd and 
raidstart and raidstop and thesee seem analogous to that.

I will work to convert over to mdadm.

Mitchell


>
>
> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org
> [mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Mitchell Laks
> Sent: Monday, January 10, 2005 2:03 AM
> To: linux-raid@vger.kernel.org
> Subject: convert degraded raid1 drive to ext3 format
>
> Hi,
>
> Only a newbie could ask this question. Guess what, I really am!
>
> I have 4 hard drives on my ssytem to store data. currently i use raid5.
>
> I am seriously considering using raid1 instead of raid5.
> But  I only need raid1 while data is being initially collected on the
> server.
> So  I would like to use raid1 (with ext3 format) initially and then convert
> to standard ext3 drives.if this is possible.
>
> i have 4 drives
> /dev/hda, /dev/hdc, /dev/hde, /dev/hdg
>
> What I would like to do is use
> stage 1)     /hda and /hdg as  a raid initially and leave /dev/hdc,
> /dev/hde
>
> alone
> then use
> stage 2)    /hdc and /hdg as a raid and use "/hda as if it were a ext3
> drive"
> then use
> stage 3)   /hde and  /hdg as a raid and use "/hda and /hdc as if there were
> ext3 drives"
>
> Now i see easily that I can run at stage3)
>
> /dev/md0 --      /hda alone in degraded mode
> /dev/md1 ----  /hdc alone in degraded mode
> /dev/md2 ---    /hde and /hdg together.
>
> if i do raidsetfaulty to /dev/hdg and raidhotremove /dev/hdg each time and
> add
> it to the new /dev/md1 and /dev/md2 as I need them.
>
> But i would prefer REAL ext3 drives instead of degraded /dev/md0 and
> /dev/md1
> (i think???). In place of /dev/md0 and /dev/md1.
>
> So my question is: I s it possible to "convert a degraded raid1  consisting
> of
> a single hard drive over to a standard ext3 format drive (ie /dev/md0 is
> only
> one drive so can it become ext3) ?" without doing something like rsync of
> the
> data on /dev/md0  to a fresh drive "the new /dev/hda" ???
>
> Thanks,
> Mitchell Laks
>
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
