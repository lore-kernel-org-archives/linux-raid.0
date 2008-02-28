From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: Understanding bonnie++ results
Date: Thu, 28 Feb 2008 20:06:09 +0100
Message-ID: <20080228190609.GA29262@rap.rap.dk>
References: <1204191989.16924.10.camel@franck-gusty>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1204191989.16924.10.camel@franck-gusty>
Sender: linux-raid-owner@vger.kernel.org
To: Franck Routier <franck.routier@axege.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Feb 28, 2008 at 10:46:29AM +0100, Franck Routier wrote:
> Hi,
> 
> I am experimenting with Adaptec 31205 hardware raid versus md raid on
> raid level 10 with 3 arrays of 4 disks each.
> md array was created with f2 option.

what are the characteristics of your disks? Are they all the same size
and same speed etc?

What kind of raid are you creating with the Adaptec HW? I assume you
make a RAID1 with this.

What is the chunk size?

Are your figures for one of the arrays, that is for an array of 4
drives?

> I get some results with bonnie++ tests I would like to understand:
> 
> - per char sequential output is consistantly around 70k/sec for both
> setup

I think the common opinion on this list is to ignore this figure.
However, if you are using this for postgresql databases, this may be relevant.

> - but block sequential output shows a huge difference between hw and sw
> raid: about 160k/sec for hw versus 60k/sec for md. Where can this come
> from ??

Strange. Maybe see if the md array has been fully synced before testing.
For sequential writes on a 4 drive raid10,f2 with disks of 90 MB/s
I would expect a writing rate of about 160 MB/s - which is the same as 
your HW rate. (I assume you mean MB/s instead of k/sec)

> On the contrary, md beat hw on inputs:
> - sequential input show 360k/sec versus 220k/sec for hw

raid10,f2 stripes, while normal raid1 does not. Also raid10,f2
tends to only use the outer and faster sectors of disks.

> - random seek 1350/sec for md versus 1150/sec for hw

Random seeks in raid10,f2 tends to be restricted to a smaller range of
sectors, thus making average seek times smaller.
 
> So, these bonnie++ tests show quite huge differences for the same
> hardware between adaptec's hardware setup and md driver.

I like to get such results of comparison between HW and SW raid.
How advanced are Adaptec controllers considered these  days? 
My thoughts are that SW raid is faster than HW raid, because Neil and the
other people here together can develop more sophisticated algorithms,
but I would like some hard figures to back up that thought.

