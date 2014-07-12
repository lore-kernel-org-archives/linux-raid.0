From: "Wilson, Jonathan" <i400s@hotmail.com>
Subject: Re: Partitioning on top of raid mirror device questions.
Date: Sat, 12 Jul 2014 11:47:35 +0100
Message-ID: <BLU436-SMTP1964880FFD3C6E510316330E1080@phx.gbl>
References: <BLU436-SMTP80DC26546309D9E205B561E10E0@phx.gbl>
	 <53BE925A.1000509@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <53BE925A.1000509@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, 2014-07-10 at 09:17 -0400, Phil Turmel wrote:
> Good morning Jonathan,
> 
> On 07/10/2014 07:24 AM, Wilson Jonathan wrote:
> 
> [trim /]
> 
[snipped]
> 
> > I may just stick with raw files but as I am in the process of upgrading
> > it piqued my interest and might be worth converting to partitions, or
> > possibly LVM which seems the preferred or most documented option (bit
> > I'm not sure I want to add a whole new set of skills and learning curve
> > at the moment). 
> 
> I always use LVM on top of my arrays.  It is also alignment-friendly,
> and is *very* handy when you need to rearrange a machine's storage
> without downtime.  I prefer it over partitions within the raid.

In the end I decided just partitions would be enough, although there
were a couple of gotchas... 

The first was I have to manually manage them which is not really a
problem; which I found out when trying to clone my working env from P1
to P2 "block devices to clone must be libvirt managed storage volumes"
but easy enough to do a dd or I could probably use the "qemu-img
convert" using P1 and P2 as the from and to options (not tested, on my
todo list).

The second was that moving from a wheezy system to a new jessie
(although there were other possible causes in initial miss configuring
of "import from existing") seemed to be enough to trigger a "hardware
has changed" within the XP virtual machine and then one to many
activated counts caused a "this product has been installed to many
times, use the phone..." (thankfully the phone MS auto system still
works even tho' MS no longer supports it)

> 
> > My intention is to add 2 more disks to the mirror raid, which while not
> > changing the write performance I believe will improve the read
> > performance... at least as far as I can tell, again is this assumption
> > correct?
> 
> It will improve multiple-threaded reads, or multiple simultaneous
> programs' reads.  It will not improve single-threaded streaming reads.
> 

Interesting to know... and my initial observation is that the
boot-to-idle time "feels" faster.

There was one final problem that bit me, but with hindsight should have
been obvious...

My on disk partition(s) was 120G, raid on top, then what should have
been 4 partitions of 30G (the original raw file virtual size) but the
4th partition was fractionally smaller than 30G (about 29.99G) because I
forgot to take into account the on disk raid metadata information would
take up space. Obvious when you think about it, DOH!, but as I only need
2 working envs, and one "this copy works and is set up how I like it"
for backup re-replication I can live with it and use the 4th partition
as a scratch test bed :-)


> HTH,
> 
> Phil
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


