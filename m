From: berk walker <berk@panix.com>
Subject: Re: Severe, huge data corruption with softraid
Date: Wed, 02 Mar 2005 19:10:57 -0500
Message-ID: <42265611.4020307@panix.com>
References: <42264AF4.4000600@tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <42264AF4.4000600@tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Just a thought, have you tried swapping power supplies, and 
checked/improved the system's Earth ground?
b-

Michael Tokarev wrote:

> Too bad I can't diagnose the problem correctly, but it is
> here somewhere, and is (hardly) reproduceable.
>
> I'm doing alot of experiments right now with various raid options
> and read/write speed.  And 3 times now, the whole system went boom
> during the experiments.  It is writing into random places on all
> disks, including boot sectors, partition tables and whatnot, so
> obviously every filesystem out there becomes corrupt to hell.
>
> It seems the problem is due to integer overflow somewhere in raid
> (very probably raid5) or ext3fs code, as it is starting to write
> to the beginning of all disks instead of the raid partitions being
> tested.  It *may* be related to direct-io (O_DIRECT) into a file
> in ext3 filesystem which is on top of softraid5 array.  It may also
> be related to raid10 code, but it is less likely.
>
> Here's the scenario.
>
> I have 7 scsi disks, sda..sdg, 36GB each.
> On each drive there's a 3GB partition at the end (sdX10)
> where I'm testing stuff.
> I tried to create various raid arrays out of those sdX10 partitions,
> including raid5 (various chunk sizes), raid1+raid0 and raid10.
> On top of the raid array, I also tried to create ext3 fs.
> And did various read/write tests on both the md device (without the
> filesystem) and a file on the filesystem.
> The tests - just sequential read and write with various I/O size
> (8k, 16k, 32k, ..., 1m) and various O_DIRECT/O_SYNC/fsync() combinations.
>
> Ofcourse I created/stopped raid arrays (all on the same sdX11), created,
> mounted and umounted filesystem on that arrays and did alot of reading
> and writing.  I'm sure I didn't access other devices during all this
> testing (like trying to write to /dev/sdX instead of /dev/sdX11), and
> did not write to the device while there was filesystem mounted.  And
> yes, my /dev/ major/minor numbers are correct (just verified to be sure).
>
> The symthom is simple: at some time, partition table on /dev/sdX becomes
> corrupt (either primary or extended which is at about 1.2Gb of the start
> of each disk), just like alot of other stuff, mostly at the beginning of
> all disks -- on all but one or two disks involved in testing.
>
> We lost the system this way after first series of testing, and during
> re-install (as there's no data anymore anyway), I descided to perform
> some more testing, and hit the same prob again and (after restoring
> partition tables) yet again.
>
> All my attempts to reproduce it failed so far, but when I din't watch
> partition tables after each operation, it happened again after yet more
> series of tests.
>
> One note: every time before it "crashed", I tried to create/use a raid5
> array out of 3, 4 or 5 drives with chunk size = 4Kb (each partition is
> 3GB large), and -- if i recall correctly -- experimented with direct
> write on the filesystem created on top of the array.  Maybe it dislikes
> chunk size this small...
>
> Now it's 02:18 here, deep night and I'm still in office -- I have to re-
> install the server by morning so our users will have something to do,
> so I have very limited time for more testing.  Any quick suggestions
> about what/where to look at right now welcome...
>
> BTW, the hardware is good, drives, memory, mobo and CPUs.
> This happens on either 2.6.10 or 2.6.9 the first time, now it is
> running 2.6.9.
>
> /mjt
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> .
>

