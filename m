From: Neil Brown <neilb@suse.de>
Subject: Re: Computer locked up when adding bitmap=internal and now filesystem
 is gone
Date: Fri, 12 Jun 2009 11:09:45 +1000
Message-ID: <18993.43737.663648.338769@notabene.brown>
References: <6592BDAF72405343BA096C66B735B38E017D64335C@alvxmbw04.prod.quest.corp>
	<6592BDAF72405343BA096C66B735B38E017D643878@alvxmbw04.prod.quest.corp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Henrik Johnson on Thursday June 11
Sender: linux-raid-owner@vger.kernel.org
To: Henrik Johnson <henrik.johnson@quest.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thursday June 11, henrik.johnson@quest.com wrote:
> I am having a decidedly bad day today. I just posted another issue
> here a few hours ago. Now on another machine I was trying to remove
> and then add back an internal bitmap. When executing the command to
> add the internal bitmap back I ran into this error is the syslog. 
> 
> Jun 11 14:06:36 pallas klogd: BUG: unable to handle kernel NULL pointer dereference at (null)
> Jun 11 14:06:36 pallas klogd: IP: [<c0306ddb>] bitmap_daemon_work+0x1eb/0x380

Is it possible that this actually happened when you removed the
bitmap, and you didn't notice until you tried to add the bitmap?

I can see a race in the bitmap removal which could allow this to
happen - I'll see about fixing that.

> After this the machine completely locked up. I had to hard reset it
> to get it back up and running. The array was dirty but all the disks
> seemed to be there and in the array. It started syncing up a bit
> before I stopped it just to be on the safe side. Here is the
> problem. It seems that most of the filesystem on the array is
> gone. According to mdstat and mdadm the array has no bitmap (It was
> during the call to add the array back that the computer locked
> up). Here is the output from one of the disks from mdadm -E. 

That is very sad!

I don't think that the bug which caused the BUG message could have
caused corruption.  As you say, it will have just locked the array up
so any further access blocked.  The last thing that would have been
written was the update to the superblock to record that the bitmap was
no longer present.

Given that none of the devices failed, the parity information should
not be relevant so whether it did a resync or not, you should still
see correct data.

> 
> Can anybody think of any reason how this could completely corrupt
> and ext4 file system. The ext4 filesystem is sitting on top of an
> luks encrypted partition if that helps in any way. It seems not
> everything is gone though because luks can correctly decode the
> password but pretty much every single group descriptor in ext4 had
> an invalid checksum when I ran a read only fsck. 

I believe the group descriptors are spread uniformly across the
device.  If (almost) all of them are corrupt, it seem very unlikely
that this would be due to bad data being written.

The possibilities that come to mind are:
  - the devices in the raid6 are in the wrong order.  This should be
    impossible as mdadm looks at the content of the metadata to get
    the order write.  If the superblock for one device was written to
    another by mistake you could get confusing, but then you would
    expect to see a missing device.  To get a good array with the
    devices in the wrong order, two superblocks would have to be
    swapped, and I think that is incredibly unlikely.

  - The encryption is confused somehow.  It is much easier to point
    the finger here was I know much less about it :-)
    However if the encryption were confused, then you would think that
    every block would look wrong, and the ext4 superblock would not be
    recognisable and fsck would even get as far as looking for group
    descriptors. 

So I'm at a loss - I've run out of ideas.  Sorry!

NeilBrown
