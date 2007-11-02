From: Neil Brown <neilb@suse.de>
Subject: Re: Very small internal bitmap after recreate
Date: Fri, 2 Nov 2007 22:43:57 +1100
Message-ID: <18219.3453.415512.450789@notabene.brown>
References: <58CC73B2-35E8-412A-A7ED-8CACE786CE00@bj-ig.de>
	<18218.60496.499724.710572@notabene.brown>
	<70E97204-84DA-404E-9426-BDED1D4A1FE4@bj-ig.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Ralf_M=FCller?= <ralf@bj-ig.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday November 2, ralf@bj-ig.de wrote:
> 
> Am 02.11.2007 um 10:22 schrieb Neil Brown:
> 
> > On Friday November 2, ralf@bj-ig.de wrote:
> >> I have a 5 disk version 1.0 superblock RAID5 which had an internal
> >> bitmap that has been reported to have a size of 299 pages in /proc/
> >> mdstat. For whatever reason I removed this bitmap (mdadm --grow --
> >> bitmap=none) and recreated it afterwards (mdadm --grow --
> >> bitmap=internal). Now it has a reported size of 10 pages.
> >>
> >> Do I have a problem?
> >
> > Not a big problem, but possibly a small problem.
> > Can you send
> >    mdadm -E /dev/sdg1
> > as well?
> 
> Sure:
> 
> # mdadm -E /dev/sdg1
> /dev/sdg1:
>            Magic : a92b4efc
>          Version : 01
>      Feature Map : 0x1
>       Array UUID : e1a335a8:fc0f0626:d70687a6:5d9a9c19
>             Name : 1
>    Creation Time : Wed Oct 31 14:30:55 2007
>       Raid Level : raid5
>     Raid Devices : 5
> 
>    Used Dev Size : 625137008 (298.09 GiB 320.07 GB)
>       Array Size : 2500547584 (1192.35 GiB 1280.28 GB)
>        Used Size : 625136896 (298.09 GiB 320.07 GB)
>     Super Offset : 625137264 sectors

So there is 256 sectors before the superblock were a bitmap could go,
or about 6 sectors afterwards....

>            State : clean
>      Device UUID : 95afade2:f2ab8e83:b0c764a0:4732827d
> 
> Internal Bitmap : 2 sectors from superblock

And the '6 sectors afterwards' was chosen.
6 sectors has room for 5*512*8 = 20480 bits,
and from your previous email:
>           Bitmap : 19078 bits (chunks), 0 dirty (0.0%)
you have 19078 bits, which is about right (a the bitmap chunk size
must be a power of 2).

So the problem is that "mdadm -G" is putting the bitmap after the
superblock rather than considering the space before....
(checks code)

Ahh, I remember now.  There is currently no interface to tell the
kernel where to put the bitmap when creating one on an active array,
so it always puts in the 'safe' place.  Another enhancement waiting
for time.

For now, you will have to live with a smallish bitmap, which probably
isn't a real problem.  With 19078 bits, you will still get a
several-thousand-fold increase it resync speed after a crash
(i.e. hours become seconds) and to some extent, fewer bits are better
and you have to update them less.

I've haven't made any measurements to see what size bitmap is
ideal... maybe someone should :-)

>      Update Time : Fri Nov  2 07:46:38 2007
>         Checksum : 4ee307b3 - correct
>           Events : 408088
> 
>           Layout : left-symmetric
>       Chunk Size : 128K
> 
>      Array Slot : 3 (0, 1, failed, 2, 3, 4)
>     Array State : uuUuu 1 failed
> 
> This time I'm getting nervous - Array State failed doesn't sound good!

This is nothing to worry about - just a bad message from mdadm.

The superblock has recorded that there was once a device in position 2
which is now failed (See the list in "Array Slot").
This summaries as "1 failed" in "Array State".

But the array is definitely working OK now.

NeilBrown
