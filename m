From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: RAID0 - one drive's superblock is corrupt
Date: Mon, 29 Jul 2002 20:35:48 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15685.6788.430632.934955@notabene.cse.unsw.edu.au>
References: <3D3DD9D2.7030501@moley.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Neil Sedger on Tuesday July 23
To: Neil Sedger <linux-raid@moley.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday July 23, linux-raid@moley.org.uk wrote:
> 
> Any suggestions?

0/ restore from backups.  You do have backups don't you?

1/ Get a replacement disc the same size, copy all the data from one to
   the other
     dd if=/dev/olddisk of=/dev/newdisk bs=100M
   then change your raidtab to refer to the new drive instead of the
   old run the "mkraid" command to re-create the superblocks.

2/ The reason the "persistant=0" trick didn't work is that the
   effective size of the disk is smaller when you have a superblock.
   so: work out the effecitive size of each partition ... kernel log
   messages might tell you. mkraid will tell you (hde1 has an
   effective size of 45030080kB).
   Then change your partition tables with fdisk so that these
   partitions appear to breally the size that raid0 effecitvely make
   them, and then to the persistant=0 trick.
   To calculate the effective size, take the real size, round down to
   a multiple of 64K and subtract 64K.
   e.g. for hde1, real size is 45030163Kb
     45030163/64 == 703596
     703596 * 64 == 45030144  (this is rounded down)
     45030144 - 64 == 45030080  which is the correct number.

   To might have to use export mode to convince fdisk to ignore
   "cylinder boundries".

3/ Hack the md code to not actually write out superblocks,
   or to read them in.  And then try the mkraid command to create
   a new array.

4/ Sue IBM for selling such dodgy hard drives.

Good luck.

NeilBrown
