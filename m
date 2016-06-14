From: Nicolas Noble <nicolas@nobis-crew.org>
Subject: Re: Failure propagation of concatenated raids ?
Date: Tue, 14 Jun 2016 16:35:13 -0700
Message-ID: <CAAkR8+seC6guH6zD-GdG+8_VGP+z5zN3soaqsDDqQKxhKm1U0g@mail.gmail.com>
References: <CAAkR8+s1=P5+4w0JBLs71DFtqQiD+x4mssjvL4utmb0HGOfLEg@mail.gmail.com>
 <20160614224155.GA15661@metamorpher.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160614224155.GA15661@metamorpher.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> If too many disks fail it does not go read only either. Once there
> are not enough disks left to run the array, it's gone completely.
> Once there are not enough disks to make the RAID work at all,
> you can neither read nor write.

In my experience, that's not the case:

Create a raid:
# mdadm --create test-single --raid-devices=8 --level=5
/dev/mapper/loop2p[12345678]

Fill it with random data:
# shred -v -n1 /dev/md/test-single

Fail it to the point it should be gone:
# mdadm /dev/md/test-single --fail /dev/mapper/loop2p[78]

But I can still read the online stripes, with read errors occuring
when encountering offline stripes:
# hexdump -C /dev/md/test-single |& less
[ works, until it encounters an offline stripe, failing with 'hexdump:
/dev/md/test-single: Input/output error' ]

Any write on any stripe would get refused. Which is what I'm talking
about "read only mode", even with some portions being unreadable. That
behavior actually has been a boon for me in the past, to recover
partial data.

>> Now we fail the raid device by pulling two drives out of it:
>> # mdadm /dev/md/test-single --fail /dev/mapper/loop2p[78]
>
> It should be gone completely at this point, not just "read-only".

No, see above.

> With it gone completely, none of the writes succeed...

Correct, but reads still work for some portions.

> Doing this with RAID0 is of course, super horrible. You lose everything
> even though only one side of your RAID died. Also RAID on RAID can cause
> assembly problems, things have to be done in the right order. Consider LVM.

See below - I was trying to show the behavior using a single tool, but
the same occurs with lvm - albeit with more complicated chains of
command lines.

> It will cascade... as soon as the upper layer tries to write on the
> lower layer which is no longer there. Maybe md could be smarter at
> this point but who will consider obscure md on md cases?
>
> There doesn't seem to be a generic mechanisms that informs higher layers of
> failures, each layer has to find out by itself by encountering I/O errors.

No, it really doesn't cascade :-) The writes on the lower layers will
occasionally fail, but the upper layer will happily ignore them and
stay online all day long if necessary. And that really, REALLY is the
whole point of this e-mail.

> If that really writes random data to every other RAID chunk without
> ever failing the missing RAID0 disk... it might be a bug that needs
> looking at.

Yes, it really writes random data to every other raid chunk without
ever failing the missing RAID0 disk. And that would also happen with
LVM. LVM will continue being happy to ignore the chunk that failed,
sendings writes to it that are getting completely lost into the void,
without ever failing the logical volume.

> A change is expected if the first write (first chunk) succeeds
> (if you failed the wrong half of the RAID0). If shred managed
> to write more than one chunk then the RAID didn't fail itself,
> that would be unexpected.

Shred managed to write to every single chunk in the first raid that
was still online.

> If it wasn't shred which just aggressively keeps writing stuff,
> but a filesystem, you might still be fine since the filesystem
> is still nice enough to go read-only in this scenario, as long
> as the RAID0 reports those I/O errors upwards...

It does report the I/O errors upwards according to dmesg logs, but
that doesn't really prevent anything. The kernel continues writing to
the filesystem as if nothing really special happened.

> If the filesystem didn't notice the problem for a long time,
> the problem shouldn't have mattered for a long time. Each filesystem
> has huge amounts of data that aren't ever checked as long as you
> don't visit the files stored there. If your hard disk has a cavity
> right in the middle of your aunt's 65th birthday party you won't
> notice until you watch the video which you never do...
>
> That's why regular self-checks are so important, if you don't
> run checks you won't notice errors, and won't replace your broken
> disks until it's too late.
>
> Filesystem turning read only as soon as it notices a problem,
> should still be considered very good. But a read only filesystem
> will always cause a lot of damage. Any outstanding writes are lost,
> anything not saved until this point is lost, any database in the
> middle of a transaction may not be able to cope properly, ...
>
> Going read only does not fix problems, it causes them too.
>
> Even if you write your own event script that hits the brakes on
> a failure even before the filesystem notices the problem, it's
> probably not possible to avoid such damages. It depends a lot on
> what's actually happening in this filesystem.
>
> If you write a PROGRAM to handle such error conditions basically
> what you need to think about is not just `mount remount,ro` but
> more like what `shutdown` does, how to get things to end gracefully
> under the circumstances.

So, in the case I'm talking about, I'm talking about a volume that is
storing streaming videos, at a speed of ~2MB/s, generating hundreds of
thumbnails on the way, within deep subfolder trees. The filesystem WAS
really, really busy, and lots and lots of damage was caused. Various
directories collided with each other during that time, and several
gigabytes ended up in lost+found after a few days of intense fsck.
Tape backup only recovered up until a certain point in time, but
trying to recover what got created after the last backup was almost a
lost cause. That was a filesystem concatenated using lvm by the way.

>
>> So, after this quite long demonstration, I'll reiterate my question
>> at the bottom of this e-mail: is there a way to safely concatenate two
>> software raids into a single filesystem under Linux, so that my basic
>> expectation of "everything goes suddenly read only in case of failure"
>> is being met ?
>
> I would make every effort to prevent such a situation from happening
> in the first place. RAID failure is not a nice situation to be in,
> there is no magical remedy.
>
> My own filesystems also span several RAID arrays; I do not have any
> special measures in place to react on individual RAID failures.
> I do have regular RAID checks, selective SMART self-tests, and I'm
> prepared to replace disks as soon as they step one toe out of line.
>
> I'm not taking any chances with reallocated/pending/uncorrectable sectors,
> if you keep those disks around IMHO you're gambling.
>
> Since you mentioned RAID controllers, if you have several of them, you
> could use one disk (with RAID-6 maybe 2 disks) per controller for your
> arrays, so a controller failure would not actually kill a RAID. I think
> backblaze did something like this in one of their older storage pods...

The failed controller was a normal, non-RAID sata controller. The
disks are being used directly by the software raid under Linux. The
dmesg log indicated that the 4 disks that were plugged to that SATA
controller went offline suddenly, and one of the two RAID went into
failure, being "read only" as I described above (aka, read errors on
offline stripes, reads working on online stripes, write failures on
everything), but the above lvm layer still continued being online for
quite some time - about 5 hours with around 10000 files created, and
about 30GB of fresh data being created, a good half of it that
eventually ended up in lost+found. Right after the initial controller
failure, the volume reported lots and lots of write failures, but the
kernel continue happily nonetheless, until it realized there was a big
inconsistency in the filesystem, and decided to shut the filesystem
down. Remounting after bringing the failed controllers and disks back
online got next to impossible. In fact, I had to upgrade to
experimental e2fs tools in order to be able to do anything with it.
