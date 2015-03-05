From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Last working drive in RAID1
Date: Thu, 05 Mar 2015 15:55:40 +0000
Message-ID: <54F87C7C.8020501@youngman.org.uk>
References: <54F7633F.3020503@gmail.com>	<20150305084634.2d590fe4@notabene.brown>	<54F78BD9.403@gmail.com> <20150305102622.016ec792@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150305102622.016ec792@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>, Eric Mei <meijia@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/03/15 23:26, NeilBrown wrote:
> On Wed, 04 Mar 2015 15:48:57 -0700 Eric Mei <meijia@gmail.com>
> wrote:
> 
>> Hi Neil,
>> 
>> I see, that does make sense. Thank you.
>> 
>> But it impose a problem for HA. We have 2 nodes as active-standby
>> pair, if HW on node 1 have problem (e.g. SAS cable get pulled,
>> thus all access to physical drives are gone), we hope the array
>> failover to node 2. But with lingering drive reference, mdadm
>> will report array is still alive thus failover won't happen.
>> 
>> I guess it depends on what kind of error on the drive. If it's
>> just a media error we should keep it online as much as possible.
>> But if the drive is really bad or physically gone, keeping the
>> stale reference won't help anything. Back to your comparison with
>> single drive /dev/sda, I think MD as an array should do the same
>> as /dev/sda, not the individual drive inside MD, for them we
>> should just let it go. How do you think?
> 
> If there were some what that md could be told that the device
> really was gone and just just returning errors, then I would be OK
> with it being marked as faulty and being removed from the array.
> 
> I don't think there is any mechanism in the kernel to allow that.
> It would be easiest to capture a "REMOVE" event via udev, and have
> udev run "mdadm" to tell the md array that the device was gone.
> 
> Currently there is no way to do that ... I guess we could change
> raid1 so that a 'fail' event that came from user-space  would
> always cause the device to be marked failed, even when an IO error
> would not... To preserve current behaviour, it should require
> something like "faulty-force" to be written to the "state" file.
> We would need to check that raid1 copes with having zero working
> drives - currently it might always assume there is at least one
> device.
> 
Sorry to butt in, but I'm finding this conversation a bit surreal ...
take everything I say with a pinch of salt. But the really weird bit
was "what does linux do if /dev/sda disappears?"

In the old days, with /dev/hd*, the * had a hard mapping to the
hardware. hda was the ide0 primary, hdd was the ide1 secondary, etc
etc. I think I ran several systems with just hdb and hdd. Not a good
idea, but.

Nowadays, with sd*, the letter is assigned in order of finding the
drive. So if sda is removed, linux moves all the other drives and what
was sdb becomes sda. Which is why you're advised now to always refer
to drives by their BLKDEV or whatever, as linux provides no guarantees
whatsoever about sd*. The blockdev may only be a symlink to whatever
the sd*n code of the disk is, but it makes sure you get the disk you
want when the sd*n changes under you.

Equally surreal is the comment about "what does raid1 do with no
working devices?". Surely it will do nothing, if there's no spinning
rust or whatever underneath it? You can't corrupt it if there's
nothing there to corrupt?

Sorry again if this is inappropriate, but you're coming over as so
buried in the trees that you can't see the wood.

Cheers,
Wol
