From: Neil Brown <neilb@suse.de>
Subject: Re: activating spares
Date: Wed, 10 Mar 2010 20:18:09 +1100
Message-ID: <20100310201809.03217bfd@notabene.brown>
References: <20100310074343.GA26813@light.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100310074343.GA26813@light.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: Keld Simonsen <keld@keldix.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 10 Mar 2010 08:43:43 +0100
Keld Simonsen <keld@keldix.com> wrote:

> Hi
> 
> I made a raid10,f2 arrray (actually 2 arrays) with only one
> active disk, one missing. This was after 2 disks were found faulty,
> and I then copied the data from my faulty raid to the new  raid, and
> installed my other new 2 TB disk. I added the new disk with
>      mdadm /dev/md9 --add /dev/sdg1
> and it was then listed as a spare. I wanted to activate it, and thought
> that --add ing it would automatically start resyncing, but no...
> I then tried to force resyncing by 
>      mdadm -A /dev/md9 --update resync
> but it did not work either. Now I am lost. How do I activate the spare?
> 
> kernel 2.6.12 mdadm v1.12.0

Wow, that's OLD!..
Maybe try a newer kernel, it has probably been fixed.

Yes, --adding the device could cause it to store recovery.  I do recall there
have been a few different situations that caused that not to work, but I
don't recall the details.

If you have a service contract, complain to your vendor.  If not, upgraded to 
something a bit less than 5 years old ;-)

sorry I cannot be more helpful.

NeilBrown

> 
> best regards
> keld
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

