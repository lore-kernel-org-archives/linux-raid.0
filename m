From: Nicolas Noble <nicolas@nobis-crew.org>
Subject: Re: Failure propagation of concatenated raids ?
Date: Wed, 15 Jun 2016 02:11:47 -0700
Message-ID: <CAAkR8+sxCd6s4c=cYjjucRicX+4xOLOaG_kJ8_A=3uCL1U6+ww@mail.gmail.com>
References: <CAAkR8+s1=P5+4w0JBLs71DFtqQiD+x4mssjvL4utmb0HGOfLEg@mail.gmail.com>
 <20160614224155.GA15661@metamorpher.de> <CAAkR8+seC6guH6zD-GdG+8_VGP+z5zN3soaqsDDqQKxhKm1U0g@mail.gmail.com>
 <20160615004851.GA16228@metamorpher.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160615004851.GA16228@metamorpher.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Why didn't the filesystem go into read-only, that's what baffles me the most.
>
> This thing really doesn't go read-only. Wow.

Yes. And if you push further, by creating lots of nested
subdirectories prior to the failure, then continue to do so after the
failure, just like the previous experience I am talking about, chances
are that you might also corrupt the filesystem to the same level - so
that it's unmountable without emergency mode repairs. The "I don't
care, I continue to write and ignore failures" behavior is really
worrisome, and I don't really know to which level this needs fixing.

>
> It believes it has written all these, but once you drop caches,
> you get I/O errors when trying to read those files back.
>
> [59381.302517] EXT4-fs (md44): mounted filesystem with ordered data mode. Opts: (null)
> [59559.959199] EXT4-fs warning (device md44): ext4_end_bio:315: I/O error -5 writing to inode 12 (offset 0 size 1048576 starting block 6144)

Yes, this is similar behavior, and similar dmesg messages seen during
the outage. The last message before the filesystem decided to lock
itself up after 5 hours was various inconsistency checks that failed.

> Not what I expected... hope you can find a solution.

Precisely the reason I decided to write to the linux-raid kernel
mailing list :-) Either these should be considered bugs, or maybe
there's a hidden solution somewhere down the line that I haven't been
able to discover. To be fair, something I've left out during the
various experiments is that btrfs seems to be doing the right thing.
It'll attempt all of the writes for the new files, directories, or
file changes, but when it realizes it can't actually write to the
disk's metadata structures, it'll roll the whole transaction back -
which is somewhat good. With an intense subdirectory-creating script,
I have been able to somewhat reproduce the same kind of corruption on
ext4fs and xfs, but btrfs seems to somewhat hold itself up. In only
one instance I managed to get a btrfs to fully become unmountable and
unrecoverable, but I was really pushing the envelope in terms of
corruptions. I can try to clean up and share these testing scripts if
it's helpful to the community, but I want to do more testing on btrfs
myself in order to see if that'd be a better filesystem in that
situation. Caching really is an issue, and I need to do more testing
on that. Basically, it seems possible to create folder A before the
failure, then folder B inside folder A after the failure, in a way
that the transaction needs to be rolled back on disk - but the kernel
cache still sees B inside of A. Then, still during the time B is still
in the cache, create C inside - which ends up being in a writable
online stripe. The net result is that you have a "healthy" folder, but
completely dangling - hence the tens of thousands of lost+found items
after the recovery.

Either way, I feel this is a worrisome situation. In the general case
(one raid, one filesystem), an actual RAID failure amounts to little
damage, and recovery usually is very possible, granted that some of
the disks can be brought back online somehow. But in that kind of more
specific case (multiple raids grouped into an lvm2 volume), filesystem
metadata corruption seems to be much, much more likely, and prone to
complete data losses. And the responses so far on that thread aren't
making me feel warm and fuzzy inside - it's really not good if you
can't write anything in the "how to prevent that from happening again
in the future ?" section of your post mortem. What worries me even
more is that the model I was describing (multiple raids, one giant
lvm2 volume) seems to me that it's being adopted more and more. For
instance, as far as I understand, this is exactly what Synology does
in their hybrid raid solution, meaning it may also be prone to the
same kind of failures and corruption, potentially:
https://www.synology.com/en-us/knowledgebase/DSM/tutorial/Storage/What_is_Synology_Hybrid_RAID_SHR
- I am not going to purchase one of their appliances to test my
theory, but this is a new level of corruption that I haven't found
documented anywhere before, which puzzles me to great lengths.
