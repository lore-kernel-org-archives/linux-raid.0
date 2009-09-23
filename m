From: Jon Hardcastle <jd_hardcastle@yahoo.com>
Subject: Re: Full use of varying drive sizes?
Date: Wed, 23 Sep 2009 07:57:42 -0700 (PDT)
Message-ID: <228790.21625.qm@web51307.mail.re2.yahoo.com>
References: <87ocp2x9dl.fsf@frosties.localdomain>
Reply-To: Jon@eHardcastle.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87ocp2x9dl.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Jon@eHardcastle.com, Goswin von Brederlow <goswin-v-b@web.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--- On Wed, 23/9/09, Goswin von Brederlow <goswin-v-b@web.de> wrote:

> From: Goswin von Brederlow <goswin-v-b@web.de>
> Subject: Re: Full use of varying drive sizes?
> To: Jon@eHardcastle.com
> Cc: linux-raid@vger.kernel.org
> Date: Wednesday, 23 September, 2009, 11:07 AM
> Jon Hardcastle <jd_hardcastle@yahoo.com>
> writes:
> 
> > Hey guys,
> >
> > I have an array made of many drive sizes ranging from
> 500GB to 1TB and I appreciate that the array can only be a
> multiple of the smallest - I use the differing sizes as i
> just buy the best value drive at the time and hope that as i
> phase out the old drives I can '--grow' the array. That is
> all fine and dandy.
> >
> > But could someone tell me, did I dream that there
> might one day be support to allow you to actually use that
> unused space in the array? Because that would be awesome!
> (if a little hairy re: spare drives - have to be the size of
> the largest drive in the array atleast..?) I have 3x500GB
> 2x750GB 1x1TB so I have 1TB of completely unused space!
> >
> > Cheers.
> >
> > Jon H
> 
> I face the same problem as I buy new disks whenever I need
> more space
> and have the money.
> 
> I found a rather simple way to organize disks of different
> sizes into
> a set of software raids that gives the maximum size. The
> reasoning for
> this algorithm are as follows:
> 
> 1) 2 partitions of a disk must never be in the same raid
> set
> 
> 2) as many disks as possible in each raid set to minimize
> the loss for
> parity
> 
> 3) the number of disks in each raid set should be equal to
> give
> uniform amount of redundancy (same saftey for all data).
> Worst (and
> usual) case will be a difference of 1 disk.
> 
> 
> So here is the algorithm:
> 
> 1) Draw a box as wide as the largest disk and open ended
> towards the
>    bottom.
> 
> 2) Draw in each disk in order of size one right to the
> other.
>    When you hit the right side of the box
> continue in the next line.
> 
> 3) Go through the box left to right and draw a vertical
> line every
>    time one disk ends and another starts.
> 
> 4) Each sub-box creted thus represents one raid using the
> disks drawn
>    into it in the respective sizes present
> in the box.
> 
> In your case you have 6 Disks: A (1TB), BC (750G),
> DEF(500G)
> 
> +----------+-----+-----+
> |AAAAAAAAAA|AAAAA|AAAAA|
> |BBBBBBBBBB|BBBBB|CCCCC|
> |CCCCCCCCCC|DDDDD|DDDDD|
> |EEEEEEEEEE|FFFFF|FFFFF|
> |  md0     | md1 | md2 |
> 
> For raid5 this would give you:
> 
> md0: sda1, sdb1, sdc1, sde1 (500G)  -> 1500G
> md1: sda2, sdb2, sdd1, sdf1 (250G)  ->  750G
> md2: sda3, sdc2, sdd2, sdf2 (250G)  ->  750G
>                
>                
>        -----
>                
>                
>        3000G total
> 
> As spare you would probably want to always use the largest
> disk as
> only then it is completly unused and can power down.
> 
> Note that in your case the fit is perfect with all raids
> having 4
> disks. This is not always the case. Worst case there is a
> difference
> of 1 between raids though.
> 
> 
> 
> As a side node: Resizing when you get new disks might
> become tricky
> and involve shuffeling around a lot of data. You might want
> to split
> md0 into 2 raids with 250G partitiosn each assuming future
> disks will
> continue to be multiples of 250G.
> 
> MfG
>         Goswin
> 

Yes,

This is a great system. I did think about this when i first created my array but I was young and lacked the confidence to do much..

So assuming I then purchased a 1.5TB drive the diagram would change to

6 Disks: A (1TB), BC (750G), DEF(500G), G(1.5TB)

i) So i'd partition the drive up into 250GB chucks and add each chuck to md0~3

+-----+-----+-----+-----+-----+-----+
|GGGGG|GGGGG|GGGGG|GGGGG|GGGGG|GGGGG|
|AAAAA|AAAAA|AAAAA|AAAAA|     |     |
|BBBBB|BBBBB|BBBBB|CCCCC|     |     |
|CCCCC|CCCCC|DDDDD|DDDDD|     |     |
|EEEEE|EEEEE|FFFFF|FFFFF|     |     |
|  md0| md1 | md2 | md3 | md4 | md5 |


ii) then I guess I'd have to relieve the E's from md0 and md1? giving (which I can do by failing the drives?) 
this would then kick in the use of the newly added G's?

+-----+-----+-----+-----+-----+-----+
|GGGGG|GGGGG|GGGGG|GGGGG|GGGGG|GGGGG|
|AAAAA|AAAAA|AAAAA|AAAAA|EEEEE|EEEEE|
|BBBBB|BBBBB|BBBBB|CCCCC|FFFFF|FFFFF|
|CCCCC|CCCCC|DDDDD|DDDDD|     |     |
|XXXXX|XXXXX|XXXXX|XXXXX|     |     |
|  md0| md1 | md2 | md3 | md4 | md5 |

iii) Repeat for the F's which would again trigger the rebuild using the G's.

the end result is 6 arrays with 4 and 2 partions in respectively i.e.

   +--1--+--2--+--3--+--4--+--5--+--6--+
sda|GGGGG|GGGGG|GGGGG|GGGGG|GGGGG|GGGGG|
sdb|AAAAA|AAAAA|AAAAA|AAAAA|EEEEE|EEEEE|
sdc|BBBBB|BBBBB|BBBBB|CCCCC|FFFFF|FFFFF|
sdd|CCCCC|CCCCC|DDDDD|DDDDD|     |     |
sde|  md0| md1 | md2 | md3 | md4 | md5 |


md0: sda1, sdb1, sdc1, sdd1 (250G)  -> 750G
md1: sda2, sdb2, sdc2, sdd2 (250G)  -> 750G
md2: sda3, sdb3, sdc3, sdd3 (250G)  -> 750G
md3: sda4, sdb4, sdc4, sdd4 (250G)  -> 750G
md4: sda5, sdb5, sdc5               -> 500G
md5: sda6, sdb6, sdc6               -> 500G

Total                               -> 4000G

I cant do the maths tho as my head hurts too much but is this quite wasteful with so many raid 5 arrays each time burning 1x250gb?

Finally... i DID find a reference...

check out: http://neil.brown.name/blog/20090817000931

'
...
It would also be nice to teach RAID5 to handle arrays with devices of different sizes. There are some complications there as you could have a hot spare that can replace some devices but not all. 
...
'


-----------------------
N: Jon Hardcastle
E: Jon@eHardcastle.com
'Do not worry about tomorrow, for tomorrow will bring worries of its own.'
-----------------------



      
