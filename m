From: dean gaudet <dean@arctic.org>
Subject: Re: Resize on dirty array?
Date: Sun, 13 Aug 2006 09:02:14 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0608130859470.15975@twinlark.arctic.org>
References: <44D7DC93.2070905@net1plus.com> <44D8E535.9080208@net1plus.com>
  <17625.24594.568139.430440@cse.unsw.edu.au>  <44D9C6F5.7070501@net1plus.com>
  <68c491a60608090437l7e3b583el2214cbe6f01009ab@mail.gmail.com>
 <Pine.LNX.4.64.0608090846160.16324@coffee.psychology.mcmaster.ca>
 <44D9E41C.4050608@net1plus.com>  <Pine.LNX.4.64.0608101031330.2920@twinlark.arctic.org>
  <72dbd3150608111810m4e4a2e07r5ddcee2132dd6d9a@mail.gmail.com>
 <Pine.LNX.4.64.0608111813250.29322@twinlark.arctic.org>
 <72dbd3150608111905g43ac320bn1ab30cbe021a3f43@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <72dbd3150608111905g43ac320bn1ab30cbe021a3f43@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Rees <drees76@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 11 Aug 2006, David Rees wrote:

> On 8/11/06, dean gaudet <dean@arctic.org> wrote:
> > On Fri, 11 Aug 2006, David Rees wrote:
> > 
> > > On 8/10/06, dean gaudet <dean@arctic.org> wrote:
> > > > - set up smartd to run long self tests once a month.   (stagger it every
> > > >   few days so that your disks aren't doing self-tests at the same time)
> > >
> > > I personally prefer to do a long self-test once a week, a month seems
> > > like a lot of time for something to go wrong.
> > 
> > unfortunately i found some drives (seagate 400 pata) had a rather negative
> > effect on performance while doing self-test.
> 
> Interesting that you noted negative performance, but I typically
> schedule the tests for off-hours anyway where performance isn't
> critical.
> 
> How much of a performance hit did you notice?

i never benchmarked it explicitly.  iirc the problem was generally 
metadata performance... and became less of an issue when i moved the 
filesystem log off the raid5 onto a raid1.  unfortunately there aren't 
really any "off hours" for this system.

-dean
