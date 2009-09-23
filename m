From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: Full use of varying drive sizes?
Date: Wed, 23 Sep 2009 12:07:02 +0200
Message-ID: <87ocp2x9dl.fsf@frosties.localdomain>
References: <697034.10751.qm@web51302.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <697034.10751.qm@web51302.mail.re2.yahoo.com> (Jon Hardcastle's
	message of "Tue, 22 Sep 2009 04:24:23 -0700 (PDT)")
Sender: linux-raid-owner@vger.kernel.org
To: Jon@eHardcastle.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jon Hardcastle <jd_hardcastle@yahoo.com> writes:

> Hey guys,
>
> I have an array made of many drive sizes ranging from 500GB to 1TB and I appreciate that the array can only be a multiple of the smallest - I use the differing sizes as i just buy the best value drive at the time and hope that as i phase out the old drives I can '--grow' the array. That is all fine and dandy.
>
> But could someone tell me, did I dream that there might one day be support to allow you to actually use that unused space in the array? Because that would be awesome! (if a little hairy re: spare drives - have to be the size of the largest drive in the array atleast..?) I have 3x500GB 2x750GB 1x1TB so I have 1TB of completely unused space!
>
> Cheers.
>
> Jon H

I face the same problem as I buy new disks whenever I need more space
and have the money.

I found a rather simple way to organize disks of different sizes into
a set of software raids that gives the maximum size. The reasoning for
this algorithm are as follows:

1) 2 partitions of a disk must never be in the same raid set

2) as many disks as possible in each raid set to minimize the loss for
parity

3) the number of disks in each raid set should be equal to give
uniform amount of redundancy (same saftey for all data). Worst (and
usual) case will be a difference of 1 disk.


So here is the algorithm:

1) Draw a box as wide as the largest disk and open ended towards the
   bottom.

2) Draw in each disk in order of size one right to the other.
   When you hit the right side of the box continue in the next line.

3) Go through the box left to right and draw a vertical line every
   time one disk ends and another starts.

4) Each sub-box creted thus represents one raid using the disks drawn
   into it in the respective sizes present in the box.

In your case you have 6 Disks: A (1TB), BC (750G), DEF(500G)

+----------+-----+-----+
|AAAAAAAAAA|AAAAA|AAAAA|
|BBBBBBBBBB|BBBBB|CCCCC|
|CCCCCCCCCC|DDDDD|DDDDD|
|EEEEEEEEEE|FFFFF|FFFFF|
|  md0     | md1 | md2 |

For raid5 this would give you:

md0: sda1, sdb1, sdc1, sde1 (500G)  -> 1500G
md1: sda2, sdb2, sdd1, sdf1 (250G)  ->  750G
md2: sda3, sdc2, sdd2, sdf2 (250G)  ->  750G
                                       -----
                                       3000G total

As spare you would probably want to always use the largest disk as
only then it is completly unused and can power down.

Note that in your case the fit is perfect with all raids having 4
disks. This is not always the case. Worst case there is a difference
of 1 between raids though.



As a side node: Resizing when you get new disks might become tricky
and involve shuffeling around a lot of data. You might want to split
md0 into 2 raids with 250G partitiosn each assuming future disks will
continue to be multiples of 250G.

MfG
        Goswin
