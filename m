From: Chris Dunlop <chris@onthe.net.au>
Subject: Re: [general question] rare silent data corruption when writing data
Date: Thu, 14 May 2020 10:39:54 +1000
Message-ID: <20200514003954.GA23874@onthe.net.au>
References: <b0e91faf-3a14-3ac9-3c31-6989154791c1@yandex.pl>
 <20200513063127.GA2769@onthe.net.au>
 <24252.13078.107482.898516@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <24252.13078.107482.898516@quad.stoffel.home>
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: Michal Soltys <msoltyspl@yandex.pl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, May 13, 2020 at 01:49:10PM -0400, John Stoffel wrote:
> I wonder if this problem can be replicated on loop devices?  Once
> there's a way to cause it reliably, we can then start doing a
> bisection of the kernel to try and find out where this is happening.

I ran a week or so of attempting to replicate the problem in a VM on loop 
devices replicating the lvm/raid config, without success. Basically just 
having a random bunch of 1-25 concurrent writers banging out middling to 
largish files.

The fact it wasn't replicable in that environment could be pointing 
towards the LSI driver or hardware - or I simply wasn't able to match  
the conditions well enough.

> So far, it looks like it happens sometimes on bare RAID6 systems
> without lv-thin in place, which is both good and bad.  And without
> using VMs on top of the storage either.  So this helps narrow down the
> cause.

Note: We don't have any bare RAID6 so I haven't seen it there: our main fs 
is xfs on sequential LVM on raid6 (6 x 11-disk sets), and we saw it once 
on xfs directly on HDD partition.

> Is there any info on the work load on these systems?  Lots of small
> fils which are added/removed?  Large files which are just written to
> and not touched again?

Large files written and not touched again. Most of the time 2-5 concurrent 
writers but regularly (daily) up to 20-25 concurrent.

> I assume finding a bad file with corruption and then doing a cp of the
> file keeps the same corruption?

Yep.
