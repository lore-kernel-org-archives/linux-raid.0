From: Neil Brown <neilb@suse.de>
Subject: Re: Slow raid10 resync
Date: Wed, 24 Jun 2009 13:19:24 +1000
Message-ID: <19009.39740.60091.349944@notabene.brown>
References: <2A22ECE278A6604A84476172F106BFCE07AC7A5A@CORPUSMX50A.corp.emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Ryan_MichaelS@emc.com on Monday June 22
Sender: linux-raid-owner@vger.kernel.org
To: Ryan_MichaelS@emc.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday June 22, Ryan_MichaelS@emc.com wrote:
> Occasionally one of my devices with a 4 drive raid10 array resyncs very
> slowly.  Typical resync speed is in the 50-60 MB/sec range.  When
> running slow the speed is around 7-10 MB/sec.  sync_speed_min is set to
> 20,000, max is set to 200,000.  By setting sync_speed_min to 5000 I can
> slow the sync further, but setting it back to 20000 doesn't fix the
> speed.  Other IO on the system is normal.  The drives and the CPU are
> not maxed.
> 
> I don't know what is triggering this slow sync state.  Once in this
> state it will continue until the build completes.
> 
> Any idea what might be happening here?  I'm running Debian with a 2.6.22
> kernel.

Not really...
There have been a couple of bugs that cause resync to go faster than
it should, but I can't think of anything that would make it go slower
than sync_speed_min unless that the the fastest that the storage
subsystem could handle.

Is this just a default raid10 with 'near=2' as the layout?

NeilBrown
