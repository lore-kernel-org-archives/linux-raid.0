From: Rob Vandermeulen <rob.vandermeulen@telenet.be>
Subject: Re: Missing md superblock on added devices after grow ...
Date: Sun, 24 May 2009 18:15:20 +0200
Message-ID: <200905241815.20737.rob.vandermeulen@telenet.be>
References: <200905231703.03692.denrdc@gmail.com> <16efced97de975092f941a9a626d6f0d.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16efced97de975092f941a9a626d6f0d.squirrel@neil.brown.name>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Well, I found my error thanks to your comments about dm. While it's true that 
the /dev/mapper/sdxx devices are the same as /dev/sdxx , in my case this 
wasn't entirely true, as the disks i added had a primary partition on them, 
but i deleted them and made that primary partition a little smaller. However, 
dm mappings are only loaded on boot normally, so these were not reloaded . 
Result : the reshape took place on the older "larger" partitions instead of 
the new, slightly smaller ones. Ofcourse, the superblock was in that area too 
ofcourse. I restored the partitions to their original larger size and was able 
to get the superblocks read, and have succesfully recreated a degraded 7 disk 
array and all data is still intact :)

I guess i really should be more carefull using mapper and real devices when 
changing partition layout.

Thanks for the assistance.

On Saturday 23 May 2009 23:05:35 you wrote:
> On Sun, May 24, 2009 1:03 am, rdc wrote:
> > Yesterday i grew my 4*500GB raid5 array to 7*500GB. The reshape operation
> > ended succesfully according to the logs :
> >
> > May 22 22:24:56 [kernel] md: md2: reshape done.
> > May 22 22:24:56 [kernel] RAID5 conf printout:
> > May 22 22:24:56 [kernel]  --- rd:7 wd:7
> > May 22 22:24:56 [kernel]  disk 0, o:1, dev:dm-3
> > May 22 22:24:56 [kernel]  disk 1, o:1, dev:dm-0
> > May 22 22:24:56 [kernel]  disk 2, o:1, dev:dm-2
> > May 22 22:24:56 [kernel]  disk 3, o:1, dev:dm-1
> > May 22 22:24:56 [kernel]  disk 4, o:1, dev:dm-8
> > May 22 22:24:56 [kernel]  disk 5, o:1, dev:dm-6
> > May 22 22:24:56 [kernel]  disk 6, o:1, dev:dm-5
>
> The devices in your array are dm-xx devices, but....
>
> > However, upon restarting this morning the grown array was no longer
> > detected,
> > and my investigation revealed that the 3 device that were added do not
> > contain
> > an md superblock at all !
> >
> > One of the 3 new devices :
> > mdadm --examine -v /dev/sdb1
> > mdadm: No md superblock detected on /dev/sdb1.
>
> ... you are looking on sdxx devices for the superblock.  This
> seem to me to be a strange thing to do.
> What does
>    mdadm --example /dev/mapper/whatever
> show?
>
> What exactly are the dm-xx devices?
>
> NeilBrown

