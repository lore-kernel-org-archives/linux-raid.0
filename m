From: <luterac@bellsouth.net>
Subject: In a pickle got out of most of it.
Date: Sat, 28 Sep 2002 7:01:11 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020928110111.BJBJ4190.imf26bis.bellsouth.net@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have four harddrives, hd[efgh].  The raid order should be hd[fgeh].  However
I did not have drive hdf (device position 0 in the array), when I created the
array.  I am trying to add this device (now that it is here) into the cluster
at position zero (where it belongs).

The only thing I can manage to do right now is to add it as a spare drive.

So either I need to know how to add it correctly to begin with, or I need to
be able to convert hdf's spare status into a full fledge drive status (though
I suppose that doesn't really matter much).

I was actually in a much worse position earlier.  Not only was hdf added as a
spare, but before I even realized this problem a DMA error popped in and cause
the whole array to fail.

I was terrible panic!  I didn't know what to do.  When I finally found
documentation on the mkraid command (as a recovery tool), I realized I still
had a major problem: I didn't know which drives were where!

The reason was I just got some fans for the drives too, so I rearranged them
without marking them!

After trying 8 different combinations (half of the total possible) I finally
found the correct one (fgeh).  I can now mount my drive again, FEW!  I am
infinitely relieved about that.  But it is still in a degraded mode since I
don't know how to add hdf in.

My best guess was to do this:

Right now my /etc/raidtab has the hdf marked as faulty.

I tried just 'raidstop /dev/md1' then turning it on as not faulty in
/etc/raidtab and then running 'raidstart /dev/md1'.  However this caused it to
read the /dev/hdf1's super block instead of the other three!  Luckily it
didn't try to recover and I could just start over again using mkraid.

So my best guess was to run mdadm --zero-superblock /dev/hdf1 (which I have
already done), and then try again without marking it faulty.  But I am just
simply too scared to do that without some sort of ok from someone :) .

I'm afraid that it will start reconstruction or something -- in fact I'm
mainly worried that it's just too late at night for me to think rationally --
it's already 6am.

Could someone help?  I do appreciate it greatly -- I have been unlucky to have
my series of accidents lead up to this point but very lucky that I still have
my data (which is 80% backed up elsewhere, but I would really rather not
restore that copy, since the 20% is about 40 hours work that I don't have
anywhere to backup -- without deleting some of the other stuff [and deletion
is not an option either, of course]).

Thank you, thank you, thank you for any advice and at the least sympathy
enough to read this far -- I know I tend to be verbose when I get tired.

So I'll stop here.  I'm including my raidtab -- hopefully my situation (at
this point) is plain enough that I do not need any md event logs posted here
-- but I will be glad to do that too.

raiddev /dev/md1
	raid-level	5
	nr-raid-disks	4
	persistent-superblock	1
	parity-algorithm	left-symmetric
	chunk-size	64k

	device	/dev/hdf1
	failed-disk	0
#	raid-disk	0
	device	/dev/hdg1
	raid-disk	1
	device	/dev/hde1
	raid-disk	2
	device	/dev/hdh1
	raid-disk	3


-Gryn (Adam Luter, the ever thankful).


