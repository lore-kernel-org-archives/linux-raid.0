From: Michel Bellais <michel@ket.kth.se>
Subject: Re: Performance difference between two raid0 arrays on same drives?
Date: Sat, 12 Jul 2003 15:37:33 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200307121537.33889.michel@ket.kth.se>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

You're right, I thought about it too, but the fastest array is built with 
partitions closer to the centre of the disk, so it should be the slowest 
indeed.
The disks are big (180 Gb), the partitions represent less than 10% of it and 
follow each others.  It cannot explain 30% difference in performance.

I have created a third array on the disk, which is a copy of the slowest 
array. It has the same content. This last array shows much better performance 
than the original. And it is even closer to the centre...
So i really don't understand.
I intended to use raid0 to boost my pc at home, so it is not a crucial 
problem, i will use the late array i created.

Thank you for your answer!

Michel Bellais

On Saturday 12 July 2003 06:36 am, Gregory Leblanc wrote:
> On Fri, 2003-07-11 at 09:13, Michel wrote:
> > Hi!
> >
> > I have set two raid0 arrays on two hardrives, using 2x2 partitions. I did
> > a benchmark of the resulting arrays and one is much slower than the other
> > one. I used bonnie++ and hdparm for the tests. It showed that /dev/md0 is
> > 30% slower than /dev/md1.
> > /dev/md1 is really close to twice the performance of a single drive.
> > I set the arrays with the same parameters. md0 is built from 2x 5 Gb
> > while md1 is built from 2x2 Gb. The harddrives have the same partition
> > table. md0 is the closest to the begining of the drives.
> > The filessystem is Reiserfs on both arrays.
> > Everything works well, except i am curious about such a difference in
> > performances, since the arrays share the same hardware.
> > I am new to linux raid, i do not know if this is normal or weird.
>
> This is to be expected.  Partitions toward the "end" of the disk are
> written closer to the center of the platters, and as a result, data
> transfers suffer.  The drive spins at a constant number of revolutions
> per minute, making the linear velocity of the platter across the read
> head much higher at the outside of the disk than the outside.  HTH,
>       Greg
