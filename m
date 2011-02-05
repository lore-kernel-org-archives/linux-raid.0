From: NeilBrown <neilb@suse.de>
Subject: Re: User space RAID-6 access
Date: Sun, 6 Feb 2011 07:58:20 +1100
Message-ID: <20110206075820.08fc19c9@notabene.brown>
References: <20110131202054.GA15712@lazy.lzy>
	<20110201075259.4beaf501@notabene.brown>
	<20110205173334.GA5952@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110205173334.GA5952@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 5 Feb 2011 18:33:34 +0100 Piergiorgio Sartor
<piergiorgio.sartor@nexgo.de> wrote:

> > Look in the mdadm source code, particularly at restripe.c
> > 
> > Also
> >    make test_stripe
> > 
> > make a program the the test suite uses for verify data correctness.
> > 
> > That should give you enough hints to get you started.
> 
> Hi Neil,
> 
> I'm trying to use the "test_stripe" binary, just to
> confirm the operation, in test mode (no save nor restore).
> 
> Unfortunately, it seems not work properly, in my hands.
> 
> I created a 4 disks RAID-6 (/dev/loop[0-3]), with:
> 
> mdadm -C /dev/md111 -l 6 -n 4 --chunk=64 /dev/loop[0-3]
> 
> Filled the array from urandom:
> 
> dd if=/dev/urandom of=/dev/md111
> 
> And tried:
> 
> ./test_stripe test file_test.raw 4 65536 6 2 65536 $[ 65536 * 3 ] /dev/loop[0-3]
> 
> This returns:
> 
> 0->0
> 1->1
> P(2) wrong at 1
> Q(3) wrong at 1
> 0->3
> 1->0
> P(1) wrong at 2
> Q(2) wrong at 2
> 0->2
> 1->3
> P(0) wrong at 3
> Q(1) wrong at 3
> 
> The array filled with "0" does not return any error.
> 
> Am'I missing something or the code has problems?
> 
> An other question, I noticed the code uses an array of
> "offsets" which seem to be filled with "0" and never
> changed.
> Is this really wanted?
> Is the offset information the one found per component
> using "mdadm -E ..." or /sys/class/block/mdX/md/rdX/offset?
> What's the relation with the "start" parameter of "test_stripe"?
> 
> Thanks in advance for any hints or suggestions.

test_stripe assumes that the data starts at the start of each device.
AS you are using 1.2 metadata (the default), data starts about 1M in to
the device (I think - you can check with --examine)

You could fix test_stripe to put the right value in the 'offsets' array,
or you could create the array with 1.0 or 0.90 metadata.

NeilBrown



> 
> The md device is:
> 
> /dev/md111:
>         Version : 1.2
>   Creation Time : Sat Feb  5 17:48:49 2011
>      Raid Level : raid6
>      Array Size : 524160 (511.96 MiB 536.74 MB)
>   Used Dev Size : 262080 (255.98 MiB 268.37 MB)
>    Raid Devices : 4
>   Total Devices : 4
>     Persistence : Superblock is persistent
> 
>     Update Time : Sat Feb  5 18:19:45 2011
>           State : clean
>  Active Devices : 4
> Working Devices : 4
>  Failed Devices : 0
>   Spare Devices : 0
> 
>          Layout : left-symmetric
>      Chunk Size : 64K
> 
>            Name : lazy.lzy:111  (local to host lazy.lzy)
>            UUID : b794fb80:c4006853:47761570:3d97a1d2
>          Events : 42
> 
>     Number   Major   Minor   RaidDevice State
>        0       7        0        0      active sync   /dev/loop0
>        1       7        1        1      active sync   /dev/loop1
>        2       7        2        2      active sync   /dev/loop2
>        3       7        3        3      active sync   /dev/loop3
> 
> bye,
> 

