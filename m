From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm ddf questions
Date: Thu, 3 Mar 2011 09:11:55 +1100
Message-ID: <20110303091155.3d43314a@notabene.brown>
References: <4D5FA5C4.8030803@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D5FA5C4.8030803@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Albert Pauw <albert.pauw@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 19 Feb 2011 12:13:08 +0100 Albert Pauw <albert.pauw@gmail.com> wrote:

>   I have dabbed a bit with the standard raid1/raid5 sets and am just 
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
> the container has been renamed to /dev/md/ddf0 which points to /dev/md127.

That depends a bit on how you restart it.
The ddf metadata doesn't store a name for the array so if mdadm has to assign
a name it uses /dev/md/ddfNNN for some NNN.
If you list the array in /etc/mdadm.conf with the name you want, then mdadm
has a better chance of using that name.


> 
> I now fail one disk in the  raidset:
> 
> mdadm -f /dev/md1 /dev/sdc
> 
> I noticed that it is removed from the md1 raidset, and marked 
> online,failed in the container. So far so
> good. When I now stop the md1 array and start it again, it will be back
> again with all 5 disks, clean, no failure

This is not good.  I have created a fix and added it to my git tree: the
'master' branch of  git://neil.brown.name/mdadm


> although in the container the disk is marked failed. I then remove it 
> from the container:
> 
> mdadm -r /dev/md127 /dev/sdc
> 
> I clean the disk with mdadm --zero-superblock /dev/sdc and add it again.
> 
> But how do I add this disk again to the md1 raidset?

It should get added automatically.  'mdmon' runs in the background, notices
this sort of thing.  I just experimented and it didn't quite work as I
expected.  I'll have a closer look next week.

> 
> I see in the container that /dev/sdc is back, with status 
> "active/Online, Failed" and a new disk is added
> with no device file and status "Global-Spare/Online".
> 
> I am confused now.
> 
> So my question: how do I replace a faulty disk in a raidset, which is in 
> a ddf container?

You don't.  You just make sure the container has enough spares and mdmon will
sort things out ... or it will once I find and fix the bug.


> 
> Thanks and bare with me, I am relatively new to all this.
> 

Thanks for experimenting an reporting.

NeilBrown

