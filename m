From: "John Stoffel" <john@stoffel.org>
Subject: Re: split RAID1 during backups?
Date: Tue, 25 Oct 2005 14:04:05 -0400
Message-ID: <17246.29589.416922.642467@smtp.charter.net>
References: <E1EUFcV-0005s3-00@toko.jab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <E1EUFcV-0005s3-00@toko.jab.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Breidenbach <jeff@jab.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Jeff> Ok... thanks everyone!

You're welcome!  :]

Jeff> John, I'm using 4KB blocks in reiserfs with tail packing. All
Jeff> sorts of other details are in the dmesg output [1]. I agree
Jeff> seeks are a major bottleneck, and I like your suggestion about
Jeff> putting extra spindles in. 

I think this will be the easiest and cheapest solution for you, esp if
you do stripes over mirror pairs.  RAID10.  Or which ever it is, I
can't seem to keep it strait no matter how I think it through.

In your case, getting two HPT302 controllers and two pairs of 100gb
disks, and using them to stripe and mirror across the six disks you
have, would almost certainly improve your performance.

Jeff> Master-slave won't work because the data is continuously
Jeff> changing. 

Inotify might be the solution here, just have it watch the filesystem,
and when you see a file change you push it to the slaves.  

Jeff>  I'm not going to argue about the optimality of millions of tiny
Jeff> files (go talk to Hans Reiser about that one!)  but I definitely
Jeff> don't foresee major application redesign any time soon.

I don't think that hashing files down a level is a major re-design,
esp if your application is well done already and has just a few
functions where files are opened/written/read/closed.  That's where
you'd put your intelligence.  

But again, I'd strongly suggest that you get more controllers and
smaller disks and spread your load over as many spindles a possible.
That should give you a big performance boost.  And of course, make
sure that you have the PCI bus bandwidth to handle it.  Stay away from
RAID5 in your situation, it would just destroy you even more.

I don't recall if Reiserfs has a shrink option, but you might be able
to do so.

Heck, if you could get another pair of controllers, or a four channel
SATA controller with 4x120gb drives, you could make up a 4 way stripe,
probably 64k stripe width (or whatever the average size of your files
is), so that a single file read should hit just one disk.  Then you
can add that in as a third mirror to your existing pair of disks.
Then you'd simply pull one of the disks, toss in another controller
and four more disks and repeat the re-mirror.

Yes, you'd have more disks, more controllers, but better performance.  

You might also be able to cache more files in RAM, instead of on disk,
and if you can, laying them out in access order would be better as
well.  It all depends on how much time/money/effort you can spend
here.

And yes, I'll harp on this, but changing how your application stores
files could be a very cheap and simple way to get more performance.
Just hashing the files into smaller buckets will be a big win.  

And you might think about moving to ext3 with the dir_index option set
as well.  And a smaller block size to the filesystem, though you'll
need to bump up the inode counts by quite a bit.  

You do have a test system you can play with right?  One that has a
good subset of your data?  Just playing with filesystems and config
options might also give you a performance boost.  

To minimize downtime, through money in terms of disks and controllers
at the system.  Shutdown, add them in, reboot.  Then you can add in a
new half to the existing MD array, pull out some old disks, add in
others, all while serving data.  Yes, you will take a performance hit
while the mirroring happens, but you won't have downtime.

Good luck,
John
