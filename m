From: David Brown <david.brown@hesbynett.no>
Subject: Re: Best practice for setting up "ordinary" RAID
Date: Fri, 11 Oct 2013 11:28:38 +0200
Message-ID: <5257C4C6.5080600@hesbynett.no>
References: <CAPbD+RckkbYXF4Wpr_yzboJ0B+TBZayf0LbT3f4O3xQ-JN3gaA@mail.gmail.com> <alpine.DEB.2.02.1310110827350.20065@uplift.swm.pp.se> <CAPbD+Rc-EDpVvm=-Ge5nWJNgJRBVWseqJKwnfCdDLoBjzC4hzg@mail.gmail.com> <alpine.DEB.2.02.1310110900400.20065@uplift.swm.pp.se> <CAPbD+Rc81u=_VrK0VSNvOdfQxYK4CHse+DYa8-vS1r==b_AN_Q@mail.gmail.com> <20131011081508.GA4995@cthulhu.home.robinhill.me.uk> <CAPbD+RcN-ze=+wP+46N_wkVWkhV_feNXtkyKAuxy-D4MQmRctQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPbD+RcN-ze=+wP+46N_wkVWkhV_feNXtkyKAuxy-D4MQmRctQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guillaume Betous <guillaume.betous@gmail.com>
Cc: Mikael Abrahamsson <swmike@swm.pp.se>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 11/10/13 10:57, Guillaume Betous wrote:
>> Any read
>> error or drive failure during the rebuild and you're in trouble.
> 
> That was exactly what happened to me ! A rebuild is of course a very
> big load and another failure becomes more probable.
> 
>> With RAID 6 you can handle 2 drive failures at any time
> 
> Understood. I'll definitely switch to RAID 6 :)
> 
>> They are more complex, but not enough so to trouble any modern CPU - you
>> might have issues on a 386/486, but I doubt you'll see any difference on
>> an Atom.

On modern CPUs, the raid6 calculations run fast - and on servers you
often have at least one CPU core doing nothing anyway.

The only slow part of raid6 calculations is when you have to read data
when there are two missing disks.  But reading slowly with raid6 beats
no data at all with raid5!

Partial stripe writes (RMW writes) can be faster with raid5 than with
raid6, although I gather this has been under improvement recently.
(I've lost track of the status of these changes.)  Usually, it is a
small price to pay.

> 
> Ok. Maybe I should update French version of Wikipedia RAID article :)
> I'll test by myself.
> For now (RAID 5), on rebuild, it's about 30MB/s. On reading, it's
> about 90MB/s (direct access to /dev/md127, not read from FS).
> 
> gUI
> 


