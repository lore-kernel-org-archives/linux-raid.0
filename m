From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Linux Raid confused about one drive and two arrays
Date: Fri, 23 Jan 2004 14:27:56 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16400.38076.455804.17610@notabene.cse.unsw.edu.au>
References: <15d.2c334826.2d41ed81@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from AndyLiebman@aol.com on Thursday January 22
To: AndyLiebman@aol.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday January 22, AndyLiebman@aol.com wrote:
> In a message dated 1/22/2004 7:42:48 PM Eastern Standard Time, 
> neilb@cse.unsw.edu.au writes:
> 
> > 
> > My questions are:
> > 
> > How do I fix this problem?
> 
> Check that sdh1 is ok (do a simple read check) and then
>   mdadm /dev/md6 -a /dev/sdh1
> 
> Neil, 
> 
> Thanks for taking the time to answer my previous email. 
> 
> Please excuse my follow up question. How do I do a "simple read check" on a 
> partition/drive that's been removed from an array but that doesn't have it's 
> own file system on it? 

dd if=/dev/sdh1 of=/dev/nul bs=1024k

> 
> Assuming the "failed removed" drive tests out okay on a read check, I 
> understand that you're suggesting I add the drive back to my array. But why isn't it 
> appropriate to Assemble the array with the "force" option? Is it NOT 
> appropriate to use this option once a drive/partition has been marked as "failed and 
> removed"? If not, when is "force" appropriate? 

--force is a last resort.  It is needed if two drives have fallen out
of a raid5 array.  --force assumes the data on the devices is still
correct and reasonably consistent even though some drives appear to
have failed.

In your case, you haven't lost any data, so you want to simply add a
known-good drive into the array and let it rebuild.


> 
> Wish there was some more info about these options (like "run" as well). The 
> manual pages give very brief explanations without examples of where they are 
> appropriate. I know it's not your job to educate the whole world. Is this 
> information in any book that one could buy? Is it in the Derek ??? book? Exhaustive 
> google searches (and searches through the Linux Raid archives) have given me 
> clues here and there. But no hard and fast rules of thumb from the person who 
> should know best about mdadm!

No, there isn't any really good thorough documentation of these sorts
of thing.

NeilBrown


> 
> That said, I -- and others -- certainly appreciate all you contribute to 
> Linux! 
> 
> Regards, 
> Andy Liebman
> 
> -----------------------------------------------------------------------------
> FOR REFERENCE, HERE'S YOUR REPLY TO ME:
> 
> > I have just encountered a very disturbing RAID problem. I hope somebody 
> > understands what happened and can tell me how to fix it.
> 
> It doesn't look very serious.
> 
> > 
> > I have two RAID 5 arrays on my Linux machine -- md4 and md6.. Each array 
> > consists of 5 firewire (1394a) drives -- one partition on each drive, 10 
> drives in 
> > total. Because the device ID's on these drives can change, I always use 
> MDADM 
> > to create and manage my arrays based on UUIDs. I am using MDADM 1.3. 
> Mandrake 
> > 9.2 with mandrake's 2.4.22-21 kernel.
> > 
> > After running these arrays successfully for two months -- rebooting my file 
> > server every day -- one of my arrays came up in a degraded mode. It looks 
> as if 
> > the Linux RAID subsystem "thinks" one of my drives belongs to both arrays.
> > 
> > As you can see below, when I run mdadm -E on each of my ten firewire 
> drives, 
> > mdadm is telling me that for each of the drives in the md4 array (UUID 
> group 
> > 62d8b91d:a2368783:6a78ca50:5793492f )  there are 5 Raid devices and 6 total 
> > devices with one failed. However this array always only had 5
> > devices.
> 
> The "total" and "failed" device counts are (unfortuantely) not very
> reliable.
> 
> > 
> > On the other hand, for most of the drives in the md6 arary (UUID group  
> > 57f26496:25520b96:41757b62:f83fcb7b), mdadm is telling me that there are 5 
> raid 
> > devices and 5 total devices with one failed.
> > 
> > However, when I run mdadm -E on the drive currently identified as /dev/sdh1 
> > -- which also belongs to md6 or  the UUID group 
> > 57f26496:25520b96:41757b62:f83fcb7b -- mdadm tells me that sdh1 is part of 
> an array with 6 total devices, 5 
> > raid devices, one failed.
> > 
> > /dev/sdh1 is identified as device number 3 in the RAID with the UUID 
> > 57f26496:25520b96:41757b62:f83fcb7b.  Howver, when I run mdadm -E on the 
> other 4 
> > drives that belong to md6, mdadm tells me that device number 3 is
> > faulty.
> 
> So presumably md thought that sdh1 failed un some way and removed it
> from the array.  It updated the superblock on the remaining devices to
> say that sdh1 had failed, but it didn't update the superblock on sdh1,
> because it had failed, and writing to the superblock would be
> pointless.
> 
> 
> > 
> > My questions are:
> > 
> > How do I fix this problem?
> 
> Check that sdh1 is ok (do a simple read check) and then
>   mdadm /dev/md6 -a /dev/sdh1
> 
> > Why did it occur?
> 
> Look in your kernel logs to find out when and why sdh1 was removed
> from the array.
> 
> > How can I prevent it from occurring again?
> 
> You cannot.  Drives fail occasionally.  That is why we have raid.
> 
> Or maybe a better answer is:
>   Monitor your RAID arrays and correct problems when they occur.
> 
> BY THE WAY, I WAS MONITORING MY ARRAYS -- WHICH IS WHY I PICKED UP THE 
> PROBLEM JUST AFTER IT OCCURRED. 
