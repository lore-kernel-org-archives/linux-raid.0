From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Recovering RAID5 array
Date: Tue, 20 Jan 2004 20:59:30 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16396.64514.820157.677722@notabene.cse.unsw.edu.au>
References: <400CD0BF.2010808@upfrontsystems.co.za>
	<16396.53737.911347.812076@notabene.cse.unsw.edu.au>
	<400CE215.2050502@upfrontsystems.co.za>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jean Jordaan on Tuesday January 20
To: Jean Jordaan <jean@upfrontsystems.co.za>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday January 20, jean@upfrontsystems.co.za wrote:
> > mdadm --assemble /dev/md0 --force /dev/hd[abc]3
> > 
> > should put it back together for you.
> 
> No luck ..
> 
> cdimage root # mdadm --verbose --assemble /dev/md0 --force /dev/hda3 /dev/hdb3 
> /dev/hdc3
> mdadm: looking for devices for /dev/md0
> mdadm: /dev/hda3 is identified as a member of /dev/md0, slot 3.
> mdadm: /dev/hdb3 is identified as a member of /dev/md0, slot 4.
> mdadm: /dev/hdc3 is identified as a member of /dev/md0, slot 2.
> mdadm: no uptodate device for slot 0 of /dev/md0
> mdadm: no uptodate device for slot 1 of /dev/md0

Looks like you must have done a hot-add in the mean time....

I would try:

 mdadm -C /dev/md0 -l 5 -n 3 /dev/hda3 missing /dev/hdc3

and check "fsck -f -n" to check the the filesystem looks OK.

This 'mdadm' command will not change any data except the raid
superblocks, which are already a mess anyway.

If the looks OK, you can then 
   mdadm /dev/md0 --add /dev/hdb3
and see if hdb is working after all.

If it didn't look OK, stop the array and try create the array with a
different combination of devices.

As long as you create a raid5 array with one missing device and only
read from the resulting device, no data apart from the superblock will
be corrupted.  Once you hot-add, or create without a missing device
data could get corrupted if the array hasn't been assembled correctly.

NeilBrown
