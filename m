From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm ddf questions
Date: Thu, 3 Mar 2011 09:26:03 +1100
Message-ID: <20110303092603.4f031081@notabene.brown>
References: <4D5FA5C4.8030803@gmail.com>
	<4D63688E.5030501@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D63688E.5030501@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Albert Pauw <albert.pauw@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 22 Feb 2011 08:41:02 +0100 Albert Pauw <albert.pauw@gmail.com> wrote:

>   I experimented a bit further, and may have found an error in mdadm.
> 
> Again, this was my setup:
> - OS Fedora 14 fully updated, running in VirtualBox
> - mdadm version 3.1.4, fully updated (as of today) from the git repo
> - Five virtual disks, 1 GB each, to use
> 
> I created two raid sets out of one ddf container:
> 
> mdadm -C /dev/md127 -l container -e ddf -n 5 /dev/sd[b-f]
> mdadm -C /dev/md1 -l 1 -n 2 /dev/md127
> mdadm -C /dev/md2 -l 2 -n 3 /dev/md127
> 
> Disks sdb and sdc were used for the RAID 1 set, disks sdd, sde, sdf were 
> used for the RAID 5 set.
> All were fine and the command mdadm -E /dev/md127 showed all disks 
> active/Online
> 
> Now I failed one of the disks of md1:
> 
> mdadm -f /dev/md1 /dev/sdb
> 
> Indeed, looking at /proc/mdstat I saw the disk marked failed [F] before 
> it was automatically removed within a second (a bit weird).
> 
> Now comes the weirdest part, mdadm -E /dev/md127 did show one disk as 
> "active/Online, Failed" but this was disk sdd
> which is part of the other RAID set!

Yes .. that is weird.  I can reproduce this easily.
I had a look through the code and it looks right so there must be something
subtle...  I'll look more closely next wee when I'll have more time.

> 
> When I removed the correct disk, which can only be done from the container:
> 
> mdadm -r /dev/md127 /dev/sdb
> 
> the command mdadm -E /dev/md127 showed the 5 disks, the entry for sdb 
> didn't had a device but was still
> "active/Online" and sdd was marked Failed:
> 
> Physical Disks : 5
>          Number       RefNo             Size            Device           
> Type/State
>                  0       d8a4179c    
> 1015808K                             active/Online
>                  1       5d58f191    1015808K     /dev/sdc           
> active/Online
>                  2       267b2f97    1015808K     /dev/sdd           
> active/Online. Failed
>                  3       3e34307b   1015808K     /dev/sde           
> active/Online
>                  4       6a4fc28f     1015808K     /dev/sdf           
> active/Online
> 
> When I try to mark sdd as failed, mdadm tells me that it did it, but 
> /proc/mdstat doesn't show the disk as failed,
> everything is still running. I also am not able to remove it, as it is 
> in use (obviously).
> 
> So it looks like there are some errors in here.

Thanks!

NeilBrown
