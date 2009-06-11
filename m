From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: RAID-6 mdadm disks out of sync issue (five questions)
Date: Fri, 12 Jun 2009 03:33:39 +0400
Message-ID: <4A319453.3060503@msgid.tls.msk.ru>
References: <ed308b763e18e168a98f977857663bed.squirrel@neil.brown.name> <200906111843.n5BIhlcN024789@cjb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200906111843.n5BIhlcN024789@cjb.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid.vger.kernel.org@atu.cjb.net
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

linux-raid.vger.kernel.org@atu.cjb.net wrote:
> NeilBrown <neilb@suse.de> wrote :
>> Once you are sure you have the 6 drives with the highest
>> event counts working, assemble them with
>>
>> mdadm --assemble /dev/md13 --force /dev/sd?1
> 
> I had a few questions before I went ahead with the
> reassembly:
> 
> 1) Does it matter which order the disks are listed in when
> reassembling the array (e.g. /dev/sda1 /dev/sdh1 ...)?

No, the order does not matter.  In superblock of each
device there's the device number so mdadm will figure
it all out automatically.

On the other hand, if you want to RECREATE the array
(with mdadm --create), order DOES matter - it's pretty
much essential to get the same order as original array.

> 2) Is there any risk to the data stored on the disks by
> merely reassembling the six working disks with the above
> command?

If you original set (raid6) was 8 disks, there's nothing
to do with the data.  I mean, mdadm/kernel will not
start any sort of reconstruction because there's no
drives to resync data to.  The data will not be
changed.  Superblocks will be updated (event counts)
but that's not data.

> 3) Does /sys/module/md_mod/parameters/start_ro being
> set to 1 prevent the array from syncing/rebuilding/etc.,
> or does it only prevent new user data being written to
> the array?  If it only prevents user data being written
> to the /dev/md*, is there some way to also prevent mdadm
> from doing syncing/rebuilding/etc. so I can be sure the
> data is not at risk of further damage while testing?

See above.  I really am not sure for start_ro vs
rebuilding - will check ;)
> 
> 4) Having checked what the "Events" refers to (I thought it
> was write-syncing operations before), should I be worried
> at the Event count being above 1,000,000?  I have rebuilt
> two failed disks and the distro performed a few data
> integrity checks on all the disks.  The array is about
> nine to ten months old.

Well, 1.000.000 is a bit too high for that time.
Mine has 28 - half a year old raid array.  But I don't
reboot machine often, it has been rebooted about 10
times in that time.  Events are like - array assembly
and disassembly, drive failed, drive added and the like.

> 5) Any idea why "shutdown -h now" would cause three of
> the six working disks to gain 4 events each (happened with
> the filesystem unmounted from /dev/md13)?

It shouldn't be that high really.  I think.  *Especially*
on only some of the disks.

/mjt
