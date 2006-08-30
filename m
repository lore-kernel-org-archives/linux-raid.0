From: dean gaudet <dean@arctic.org>
Subject: Re: Resize on dirty array?
Date: Wed, 30 Aug 2006 00:30:44 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0608300022280.25221@twinlark.arctic.org>
References: <44D7DC93.2070905@net1plus.com> <44D8E535.9080208@net1plus.com>
  <17625.24594.568139.430440@cse.unsw.edu.au>  <44D9C6F5.7070501@net1plus.com>
  <68c491a60608090437l7e3b583el2214cbe6f01009ab@mail.gmail.com>
 <Pine.LNX.4.64.0608090846160.16324@coffee.psychology.mcmaster.ca>
 <44D9E41C.4050608@net1plus.com>  <Pine.LNX.4.64.0608101031330.2920@twinlark.arctic.org>
  <72dbd3150608111810m4e4a2e07r5ddcee2132dd6d9a@mail.gmail.com>
 <Pine.LNX.4.64.0608111813250.29322@twinlark.arctic.org>
 <72dbd3150608111905g43ac320bn1ab30cbe021a3f43@mail.gmail.com>
 <Pine.LNX.4.64.0608130859470.15975@twinlark.arctic.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0608130859470.15975@twinlark.arctic.org>
Sender: linux-raid-owner@vger.kernel.org
To: David Rees <drees76@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 13 Aug 2006, dean gaudet wrote:

> On Fri, 11 Aug 2006, David Rees wrote:
> 
> > On 8/11/06, dean gaudet <dean@arctic.org> wrote:
> > > On Fri, 11 Aug 2006, David Rees wrote:
> > > 
> > > > On 8/10/06, dean gaudet <dean@arctic.org> wrote:
> > > > > - set up smartd to run long self tests once a month.   (stagger it every
> > > > >   few days so that your disks aren't doing self-tests at the same time)
> > > >
> > > > I personally prefer to do a long self-test once a week, a month seems
> > > > like a lot of time for something to go wrong.
> > > 
> > > unfortunately i found some drives (seagate 400 pata) had a rather negative
> > > effect on performance while doing self-test.
> > 
> > Interesting that you noted negative performance, but I typically
> > schedule the tests for off-hours anyway where performance isn't
> > critical.
> > 
> > How much of a performance hit did you notice?
> 
> i never benchmarked it explicitly.  iirc the problem was generally 
> metadata performance... and became less of an issue when i moved the 
> filesystem log off the raid5 onto a raid1.  unfortunately there aren't 
> really any "off hours" for this system.

the problem reappeared... so i can provide some data.  one of the 400GB 
seagates has been stuck at 20% of a SMART long self test for over 2 days 
now, and the self-test itself has been going for about 4.5 days total.

a typical "iostat -x /dev/sd[cdfgh] 30" sample looks like this:

Device:         rrqm/s   wrqm/s   r/s   w/s   rsec/s   wsec/s avgrq-sz avgqu-sz   await  svctm  %util
sdc              90.94   137.52 14.70 25.76   841.32  1360.35    54.43     0.94   23.30  10.30  41.68
sdd              93.67   140.52 14.96 22.06   863.98  1354.75    59.93     0.91   24.50  12.17  45.05
sdf              92.84   136.85 15.36 26.39   857.85  1360.35    53.13     0.88   21.04  10.59  44.21
sdg              87.74   137.82 14.23 24.86   807.73  1355.55    55.35     0.85   21.86  11.25  43.99
sdh              87.20   134.56 14.96 28.29   810.13  1356.88    50.10     1.90   43.72  20.02  86.60

those 5 are in a raid5, so their io should be relatively even... notice 
the await, svctm and %util of sdh compared to the other 4.  sdh is the one 
with the exceptionally slow going SMART long self-test.  i assume it's 
still making progress because the effect is measurable in iostat.

-dean
