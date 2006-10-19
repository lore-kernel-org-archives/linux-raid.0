From: Ken Walker <ken.walker@manchester.ac.uk>
Subject: RE: why partition arrays?
Date: Thu, 19 Oct 2006 12:25:46 +0100
Message-ID: <C59E07CE09883545BC9EC6B87E2D3C83523DBF@kdtc.tt.umist.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

So is LVM better for partitions on a large raid5, or any raid, than separate
partitions on that array.

I'm still in my learning curve :)

for example, if one has Linux running on a two disk mirror array, raid1, and
the first disk is partitioned, say 5 partitions, with those partitions
mirrored on the second disk, and each identical partition is then run as a
mirror raid1.

What your saying is that, if a single partition fails, to remove the drive
you have to fail all the array partitions on the drive your taking out, then
rebuild the partitions and then add to the dirty raid the new partitions one
at a time.


Will LVM remove all this, so if you have a mirror as a single raid
partition, and use LVM to create the partitions on that mirror, if a disk
goes down, can it be removed, replaced, and then just added to the single
raid, with LVM having had no idea what was going on in the background and
just plod along merrily.

Is LVM stable, or can it cause more problems than separate raids on a array.

Ken





Second, convenience.  Assume you have a 6 disk raid5 array.  If a disk
fails and you are using a partitioned md array, then all the partitions
on the disk will already be handled without using that disk.  No need to
manually fail any still active array members from other arrays.

Third, safety.  Again with the raid5 array.  If you use multiple arrays
on a single disk, and that disk fails, but it only failed on one array,
then you now need to manually fail that disk from the other arrays
before shutting down or hot swapping the disk.  Generally speaking,
that's not a big deal, but people do occasionally have fat finger
syndrome and this is a good opportunity for someone to accidentally fail
the wrong disk, and when you then go to remove the disk you create a two
disk failure instead of one and now you are in real trouble.

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org]On Behalf Of martin f krafft
Sent: 18 October 2006 2:43pm
To: linux-raid mailing list
Subject: Re: why partition arrays?


also sprach Doug Ledford <dledford@redhat.com> [2006.10.18.1526 +0200]:
> There are a couple reasons I can think.

Thanks for your elaborate response. If you don't mind, I shall link
to it from the FAQ.

I have one other question: do partitionable and traditional arrays
actually differ in format? Put differently: can I assemble
a traditional array as a partitionable one simply by specifying:

  mdadm --create ... /dev/md0 ...
  mdadm --stop /dev/md0
  mdadm --assemble --auto=part ... /dev/md0 ...

? Or do the superblocks actually differ?

Thanks,

-- 
martin;              (greetings from the heart of the sun.)
  \____ echo mailto: !#^."<*>"|tr "<*> mailto:" net@madduck
 
spamtraps: madduck.bogus@madduck.net
 
the images rushed around his mind and tried
to find somewhere to settle down and make sense.
            -- douglas adams, "the hitchhiker's guide to the galaxy"
