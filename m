From: Mike Mestnik <cheako911@yahoo.com>
Subject: RAID1: Performance.
Date: Tue, 20 Apr 2004 22:57:29 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040421055729.90574.qmail@web11901.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linux-RAID@vger.kernel.org
List-Id: linux-raid.ids

I have looked extensively at the code in raid1.c and found that it has a
fue bugs that cause it not to do what it was intended.
The Biggest problem is that it seams to not consider that a Write will
move the heads into the same spot.  In the case of multi-process IO idle
drives may stay idle if there heads are not CLOSEST.  The other problems I
see were already discussed in a thread of a similar name.  The solution I
have come up with I think will satisfy every ones concerns.

The idea of ordering the blocks ACEBDF is vary close to the right
solution.  When drives are idle is there no point in not having them read
ahead?
If the heads are in the same place, having just finished a write, they are
both just as close.  Lets use this to our advantage, after selecting what
drive we will use.  Use that drives read-ahead plus the start of the read
and use an idle disks and read that the length of it's read-ahead value. 
This means the md device will have "N * read-ahead" read-ahead or the sum
of all read-ahead, this should be then documented.

In the case of multi-io using idle disks, thought they may not be as
close, will be better than talking a disk that is working and asking it to
move the the end of the drive only to have it move back less than 1/4 of
the disk.  Here is how...

20 <-- write.
80 <-- read(1)
96 <-- read(1) NOT 2 or 3 as they are still on 20
81 <-- read(1)
97 <-- read(1)
73 <-- read(1)

Taking non-sequential read requests and handing them ought round-robin
might look better for the example above.  IMHO the only thing saving the
current code is that it some what randomly round-robins the disks.  If you
take that ought you will see that only one drive takes the brunt of more
than %70 of the load.

I don't think the oldest used disk is a good way to go this only works if
we know that the read-ahead is full of unused data.  This would mean that
the drive is idle and it can be counted in the search for the closest
drive of a new read.  Keeping in mind any wright erases all of our book keeping.


	
		
__________________________________
Do you Yahoo!?
Yahoo! Photos: High-quality 4x6 digital prints for 25¢
http://photos.yahoo.com/ph/print_splash
