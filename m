From: Neil Brown <neilb@suse.de>
Subject: Re: How to verify RAID parity/mirroring?
Date: Mon, 17 Apr 2006 09:03:40 +1000
Message-ID: <17474.52556.536514.754498@cse.unsw.edu.au>
References: <20060413054306.10106.qmail@science.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from linux@horizon.com on  April 13
Sender: linux-raid-owner@vger.kernel.org
To: linux@horizon.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On  April 13, linux@horizon.com wrote:
> I'm looking forward to testing the new SATA NCQ support that the linux
> IDE developers have working, but of course that opens me to the risk of
> disk corruption.
> 
> So I'd like to be able to do clever things with the existing RAID arrays 
> to mitigate the damage.
> 
> I have a lot of useful-but-not-essential data (old backups) on a RAID 5
> partition.  I'm willing to risk the data but I'd rather not delete it
> preemptively.  I also don't want silent corruption.
> 
> What I'd like to be able to do is, after a few experiments, verify the
> RAID 5 parity to see if I've scrogged things.  Is there some option to
> mdadm to do that?  I could just md5sum the component partitions, but it
> would be useful information to also know *where* the damage occurred.
> Relative to the LBA28 limit, for example.

Try
  echo check > /sys/block/mdX/md/sync_action

It doesn't tell to where it finds errors (though maybe it could).  It
will report a count of errors in
   /sys/block/mdX/md/mismatch_cnt


> 
> And similarly for RAID-1 mirrors.  I have the most essential data
> (vmlinuz and a basic test mode installation) on a 6-way RAID-1, so if
> something doesn't match, it's easy enough to find a valid copy.  But I
> need to notice that things aren't right.
> 
> 
> The other thing I'd like to do is to be able to reintegrate a mirrored
> pair (particularly RAID-10) in the "wrong" direction.  That is:
> - I split the mirror and literally unplug half so it can't get
>   corrupted.
> - I boot with a test kernel and run my tests.  Oops!  It scribbled on
>   the disk.
> - I want to reboot with a known-good kernel and regenerate the mirrors
>   from the old, good data.
> 
> One thing I could do is remove the experimental partitions from the mirror
> set and generate a fresh RAID-0 md to experiment on.  Then I can mount
> the old md without fear of it getting overwritten.  But if I forget,
> is there something I can do before plugging in the old, good drives that
> will ensure that the kernel doesn't copy the new, corrupted data on top
> of the old, good data as soon as I reboot?

 mdadm --zero-superblock /dev/experimental-device

Then the old/good data will be all that is found.

NeilBrown
