From: Mike Myers <mikesm559@yahoo.com>
Subject: Nested raid operation and disk sizes
Date: Tue, 5 Aug 2008 11:47:36 -0700 (PDT)
Message-ID: <925039.86717.qm@web30804.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi.  I friend asked me a question about reconfiguring his linux software raid system, and I think I know the answer, but thought I would ask here to make sure since I'd never done this before.

My friend has 2 raid5 disk sets right now, one with 8 500 GB saegate 7200.10 disks, and the other with 5 1 TB Hitachi 7K1000 disks.

He just bought 5 new seagate 7200.11 1 TB disks, and will format them as new raid5 set.  He then plans to use lvm to move the data off the  8x500GB set to the new 5x1TB set, destroy the 8x500 set, and then use group 6 of the 500 GB disks into 3 raid0 sets of 2x500 each, and then add the raid0 sets as members of the new 1TB raid set by expanding the array.

This enables him to replace the 500 GB drives later with 1TB disks as the price of the disks gets cheaper as make the best use of the SATA sleds that his case has.  The new 7200.11's have 1,953,525,168 512 byte sectors each.  The existing segate 500 GB drives have 976,773,168 512 byte sectors.  If he combines two of the 500's together into a raid0, he should have a total of 1,953,546,336 sectors available, which is greater number of sectors than the 1 TB drives, so there should be no problem using the 2 disk raid0 set as a member of the 7200.11 1 TB disk raid5 set, right?  

Am I missing some overhead here that could be a problem?  He really has to get this right the first time, since if there isn't enough space in the raid0 set to be a member of the 1 TB array, he'll have to reduce the size of the parition for the 1 TB disks before making the new raid5 set, as once the data is moved there, and the disks removed from the 8x500GB set, there is no going back...  :-)

Does this sound like it should work?

thx
mike


      
