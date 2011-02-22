From: Albert Pauw <albert.pauw@gmail.com>
Subject: Re: mdadm ddf questions
Date: Tue, 22 Feb 2011 08:41:02 +0100
Message-ID: <4D63688E.5030501@gmail.com>
References: <4D5FA5C4.8030803@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D5FA5C4.8030803@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

  I experimented a bit further, and may have found an error in mdadm.

Again, this was my setup:
- OS Fedora 14 fully updated, running in VirtualBox
- mdadm version 3.1.4, fully updated (as of today) from the git repo
- Five virtual disks, 1 GB each, to use

I created two raid sets out of one ddf container:

mdadm -C /dev/md127 -l container -e ddf -n 5 /dev/sd[b-f]
mdadm -C /dev/md1 -l 1 -n 2 /dev/md127
mdadm -C /dev/md2 -l 2 -n 3 /dev/md127

Disks sdb and sdc were used for the RAID 1 set, disks sdd, sde, sdf were 
used for the RAID 5 set.
All were fine and the command mdadm -E /dev/md127 showed all disks 
active/Online

Now I failed one of the disks of md1:

mdadm -f /dev/md1 /dev/sdb

Indeed, looking at /proc/mdstat I saw the disk marked failed [F] before 
it was automatically removed within a second (a bit weird).

Now comes the weirdest part, mdadm -E /dev/md127 did show one disk as 
"active/Online, Failed" but this was disk sdd
which is part of the other RAID set!

When I removed the correct disk, which can only be done from the container:

mdadm -r /dev/md127 /dev/sdb

the command mdadm -E /dev/md127 showed the 5 disks, the entry for sdb 
didn't had a device but was still
"active/Online" and sdd was marked Failed:

Physical Disks : 5
         Number       RefNo             Size            Device           
Type/State
                 0       d8a4179c    
1015808K                             active/Online
                 1       5d58f191    1015808K     /dev/sdc           
active/Online
                 2       267b2f97    1015808K     /dev/sdd           
active/Online. Failed
                 3       3e34307b   1015808K     /dev/sde           
active/Online
                 4       6a4fc28f     1015808K     /dev/sdf           
active/Online

When I try to mark sdd as failed, mdadm tells me that it did it, but 
/proc/mdstat doesn't show the disk as failed,
everything is still running. I also am not able to remove it, as it is 
in use (obviously).

So it looks like there are some errors in here.

Albert

On 02/19/11 12:13 PM, Albert Pauw wrote:
>  I have dabbed a bit with the standard raid1/raid5 sets and am just 
> diving into this whole ddf container stuff,
> and see how I can fail, remove and add a disk.
>
> Here is what I have, Fedora 14, five 1GB Sata disks (they are virtual 
> disks under VirtualBox but it all seems
> to work well under the standard raid stuff. For mdadm I am using the 
> latest git version, with version nr 3.1.4.
>
> I created a ddf container:
>
> mdadm -C /dev/md/container -e ddf -l container -n 5 /dev/sd[b-f]
>
> I now create a raid 5 set in this container:
>
> mdadm -C /dev/md1 -l raid5 -n 5 /dev/md/container
>
> This all seems to work, I also noticed that after a stop and start of 
> both the container and the raidset,
> the container has been renamed to /dev/md/ddf0 which points to 
> /dev/md127.
>
> I now fail one disk in the  raidset:
>
> mdadm -f /dev/md1 /dev/sdc
>
> I noticed that it is removed from the md1 raidset, and marked 
> online,failed in the container. So far so
> good. When I now stop the md1 array and start it again, it will be 
> back again with all 5 disks, clean, no failure
> although in the container the disk is marked failed. I then remove it 
> from the container:
>
> mdadm -r /dev/md127 /dev/sdc
>
> I clean the disk with mdadm --zero-superblock /dev/sdc and add it again.
>
> But how do I add this disk again to the md1 raidset?
>
> I see in the container that /dev/sdc is back, with status 
> "active/Online, Failed" and a new disk is added
> with no device file and status "Global-Spare/Online".
>
> I am confused now.
>
> So my question: how do I replace a faulty disk in a raidset, which is 
> in a ddf container?
>
> Thanks and bare with me, I am relatively new to all this.
>
> Albert

