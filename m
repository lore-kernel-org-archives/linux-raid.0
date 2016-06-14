From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: Failure propagation of concatenated raids ?
Date: Wed, 15 Jun 2016 00:41:55 +0200
Message-ID: <20160614224155.GA15661@metamorpher.de>
References: <CAAkR8+s1=P5+4w0JBLs71DFtqQiD+x4mssjvL4utmb0HGOfLEg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAAkR8+s1=P5+4w0JBLs71DFtqQiD+x4mssjvL4utmb0HGOfLEg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Nicolas Noble <nicolas@nobis-crew.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jun 14, 2016 at 02:43:27PM -0700, Nicolas Noble wrote:
> "How can I safely concatenate two raids into a single filesystem, and
> avoid drastic corruption when one of the two underlying raids fails
> and goes read only ?"

I think there may be misunderstanding at this point, the RAID does not 
go read only when a disk fails. It still happily writes to the 
remaining disks, giving you time to add a new disk with no harm done 
to the filesystem.

If too many disks fail it does not go read only either. Once there 
are not enough disks left to run the array, it's gone completely. 
Once there are not enough disks to make the RAID work at all, 
you can neither read nor write.

Going read only is something filesystems might do when they encouter 
I/O errors, which might happen on RAID if you have bad block list 
enabled, or if your filesystem spans several RAIDs and one of them 
goes away completely.

In this case your situation is no different from using a filesystem 
on a single disk that develops a failure zone... you can only hope 
for the best at this point.

Filesystems go read only as soon as they notice an error (as soon 
as it matters); this should already be nearly optimal, if you want 
to improve on that (hit the brakes as soon as the md layer goes south 
before the filesystem notices) you might be able to do something with 
an udev rule or by defining a custom PROGRAM in mdadm.conf that does 
some shenanigans on certain failure events...

> Now we fail the raid device by pulling two drives out of it:
> # mdadm /dev/md/test-single --fail /dev/mapper/loop2p[78]

It should be gone completely at this point, not just "read-only".

> Now we can try writing to it with random data, but it'll produce a lot
> of write errors:
> # shred -n1 /dev/md/test-single 2> /dev/null

With it gone completely, none of the writes succeed...
 
> And we can start recovering data - nothing changed

> First, let's create two raids, of different sizes:
> Then, let's create a super-raid made of these two.
> # mdadm --create supertest --level=0 --raid-devices=2 /dev/md/test-part[12]

Doing this with RAID0 is of course, super horrible. You lose everything 
even though only one side of your RAID died. Also RAID on RAID can cause 
assembly problems, things have to be done in the right order. Consider LVM.

> Now, we're going to fail only the second raid, again by pulling two
> drives out of it:
> # mdadm /dev/md/test-part2 --fail /dev/mapper/loop2p[78]
> 
> And here's really the issue I have: the failure doesn't cascade to the
> superset of the two above:

It will cascade... as soon as the upper layer tries to write on the 
lower layer which is no longer there. Maybe md could be smarter at 
this point but who will consider obscure md on md cases?

There doesn't seem to be a generic mechanisms that informs higher layers of 
failures, each layer has to find out by itself by encountering I/O errors.

> # mdadm /dev/md/supertest --fail /dev/md/test-part2
> mdadm: set device faulty failed for /dev/md/test-part2:  Device or resource busy

Not sure about this one.

> So, when we try writing random data to the raid, a good portion of the
> writes are being refused with write errors, but the ones on the first
> raid are making it through:

If that really writes random data to every other RAID chunk without 
ever failing the missing RAID0 disk... it might be a bug that needs 
looking at.

Until then I'd file it under oddities that are bound to happen when 
using obscure md on md setups. ;) No one does this, so who tests for 
such error cases...?

> ... then its content has changed:
> 
> # md5sum /dev/md/supertest
> 78a213cbc76b9c1f78e7f35bc7ae3b73  /dev/md/supertest

A change is expected if the first write (first chunk) succeeds 
(if you failed the wrong half of the RAID0). If shred managed 
to write more than one chunk then the RAID didn't fail itself, 
that would be unexpected.

If it wasn't shred which just aggressively keeps writing stuff, 
but a filesystem, you might still be fine since the filesystem 
is still nice enough to go read-only in this scenario, as long 
as the RAID0 reports those I/O errors upwards...

> With the lvm2 concatenation, you would instead get two big chunks:
> one with the altered content of raid1, and one with the original 
> content of raid2, which also makes sense given the way lvm2 organizes 
> its data.

Same here, if it was a filesystem instead of thread, there should 
be less damage; shred writes aggressively, filesystems try to keep 
things intact on their own.

>   Now, the above log is shrunk down drastically, but is inspired by
> real events, where a portion of a ~40TB filesystem turned read only
> because of a controller failure, and went unnoticed for several hours
> before the kernel turned the filesystem readonly after detecting an
> inconsistency failure in the filesystem metadata.

If the filesystem didn't notice the problem for a long time, 
the problem shouldn't have mattered for a long time. Each filesystem 
has huge amounts of data that aren't ever checked as long as you 
don't visit the files stored there. If your hard disk has a cavity 
right in the middle of your aunt's 65th birthday party you won't 
notice until you watch the video which you never do...

That's why regular self-checks are so important, if you don't 
run checks you won't notice errors, and won't replace your broken 
disks until it's too late.

Filesystem turning read only as soon as it notices a problem, 
should still be considered very good. But a read only filesystem 
will always cause a lot of damage. Any outstanding writes are lost, 
anything not saved until this point is lost, any database in the 
middle of a transaction may not be able to cope properly, ...

Going read only does not fix problems, it causes them too.

Even if you write your own event script that hits the brakes on 
a failure even before the filesystem notices the problem, it's 
probably not possible to avoid such damages. It depends a lot on 
what's actually happening in this filesystem.

If you write a PROGRAM to handle such error conditions basically 
what you need to think about is not just `mount remount,ro` but 
more like what `shutdown` does, how to get things to end gracefully 
under the circumstances.

> So, after this quite long demonstration, I'll reiterate my question
> at the bottom of this e-mail: is there a way to safely concatenate two
> software raids into a single filesystem under Linux, so that my basic
> expectation of "everything goes suddenly read only in case of failure"
> is being met ?

I would make every effort to prevent such a situation from happening 
in the first place. RAID failure is not a nice situation to be in, 
there is no magical remedy.

My own filesystems also span several RAID arrays; I do not have any 
special measures in place to react on individual RAID failures. 
I do have regular RAID checks, selective SMART self-tests, and I'm 
prepared to replace disks as soon as they step one toe out of line. 

I'm not taking any chances with reallocated/pending/uncorrectable sectors, 
if you keep those disks around IMHO you're gambling.

Since you mentioned RAID controllers, if you have several of them, you 
could use one disk (with RAID-6 maybe 2 disks) per controller for your 
arrays, so a controller failure would not actually kill a RAID. I think 
backblaze did something like this in one of their older storage pods...

Regards
Andreas Klauer
