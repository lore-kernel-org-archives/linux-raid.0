From: Neil Brown <neilb@suse.de>
Subject: md/raid level conversion ready for testers.
Date: Thu, 13 Aug 2009 11:49:53 +1000
Message-ID: <19075.28993.878297.116900@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi,
 as many of you know I have been working on providing support in md
 for converting between RAID5 and RAID6 as well as other conversion
 like reducing the number of devices in a RAID5 or changing the chunk
 size.

 I think this work is ready for broader testing now, which means that
 I think it reasonably complete and that if something does go wrong, I
 strongly suspect that I will be able to help you put the array back
 together.

 However this comes with no warranty and you should always have
 backups of important data.

 To test it for me you need to checkout the "devel-3.1" branch of my
  git://neil.brown.name/mdadm
 git tree.  And "make".

 You also need a very recent kernel.  get the lasted from Linus' git
 tree and then
    git pull git://neil.brown.name/md for-linus

 (or wait a day or so and Linus will have pulled it).
 Please don't try to clone the kernel from my server, it only has a
 slow link to the world.

 For most things it is safe to use 2.6.30, but I would recommend
 getting the latest kernel to be on the safe side.

 You should be able to convert RAID1->RAID5 and RAID5->RAID6 and back
 again.  Also you can change chunk size and layout and you can reduce
 the number of devices in a RAID5.  If you don't increase the --size
 of the devices at the same, you will need to explicitly decrease the 
 --array-size first.  mdadm will tell you what to do when that is
 needed.

 Success and failure reports are most welcome.

Thanks,
NeilBrown
