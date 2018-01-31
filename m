From: David Brown <david.brown@hesbynett.no>
Subject: Re: [LSF/MM TOPIC] De-clustered RAID with MD
Date: Wed, 31 Jan 2018 15:41:11 +0100
Message-ID: <5A71D587.2070409@hesbynett.no>
References: <mqdvafkhep0.fsf@linux-x5ow.site> <5A6F4CA6.5060802@youngman.org.uk> <87fu6o5o83.fsf@notabene.neil.brown.name> <5A71933B.1050908@hesbynett.no> <5A71D24F.9090604@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <5A71D24F.9090604@youngman.org.uk>
Sender: linux-block-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, NeilBrown <neilb@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, lsf-pc@lists.linux-foundation.org
Cc: linux-raid@vger.kernel.org, linux-block@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

On 31/01/18 15:27, Wols Lists wrote:
> On 31/01/18 09:58, David Brown wrote:
>> I would also be interested in how the data and parities are distributed
>> across cabinets and disk controllers.  When you manually build from
>> smaller raid sets, you can ensure that in set the data disks and the
>> parity are all in different cabinets - that way if an entire cabinet
>> goes up in smoke, you have lost one drive from each set, and your data
>> is still there.  With a pseudo random layout, you have lost that.  (I
>> don't know how often entire cabinets of disks die, but I once lost both
>> disks of a raid1 mirror when the disk controller card died.)
> 
> The more I think about how I plan to spec raid-61, the more a modulo
> approach seems to make sense. That way, it'll be fairly easy to predict
> what ends up where, and make sure your disks are evenly scattered.
> 
> I think both your and my approach might have problems with losing an
> entire cabinet, however. Depends on how many drives per cabinet ...

Exactly.  I don't know how many cabinets are used on such systems.

> 
> Anyways, my second thoughts are ...
> 
> We have what I will call a stripe-block. The lowest common multiple of
> "disks needed" ie number of mirrors times number of drives in the
> raid-6, and the disks available.
> 
> Assuming my blocks are all stored sequentially I can then quickly
> calculate their position in this stripe-block. But this will fall foul
> of just hammering the drives nearest to the failed drive. But if I
> pseudo-randomise this position with "position * prime mod drives" where
> "prime" is not common to either the number of drives or the number or
> mirrors or the number of raid-drives, then this should achieve my aim of
> uniquely shuffling the location of all the blocks without collisions.
> 
> Pretty simple maths, for efficiency, that smears the data over all the
> drives. Does that sound feasible? All the heavy lifting, calculating the
> least common multiple, finding the prime, etc etc can be done at array
> set-up time.

Something like that should work, and be convenient to implement.  I am
not sure off the top of my head if such a simple modulo system is valid,
but it won't be difficult to check.

> 
> (If this then allows feasible 100-drive arrays, we won't just need an
> incremental assemble mode, we might need an incremental build mode :-)
> 

You really want to track which stripes are valid here, and which are not
yet made consistent.  A blank array will start with everything marked
invalid or inconsistent - build mode is just a matter of writing the
metadata.  You only need to make stripes consistent when you first write
to them.
