From: Neil Brown <neilb@suse.de>
Subject: Re: RAID5 losing initial synchronization on restart when one disk is spare
Date: Thu, 12 Jun 2008 09:40:47 +1000
Message-ID: <18512.25215.963409.362155@notabene.brown>
References: <48466AD9.5@free.fr>
	<484E6C3F.4090204@free.fr>
	<e9c3a7c20806101556q6315f4c1u67bf8879b66d81a9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Dan Williams on Tuesday June 10
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Hubert Verstraete <hubskml@free.fr>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday June 10, dan.j.williams@intel.com wrote:
> 
> I am able to reproduce this here, and I notice that it does not happen
> with v0.90 superblocks.  In the v0.90 case when the array is stopped
> the last disk remains marked as spare.  The following hack seems to
> achieve the same effect for v1 arrays, but I wonder if it is
> correct... Neil?

No, not correct.

The fact that a v1 array included spares in the array before recovery
completes is deliberate.  It allows recovery to be restarted from
where it got up to if the array is shut down while recovery is
happening.
If you don't mark the drive as a part of the array (though not
in_sync), then there is no opportunity for this optimisation.

Thanks,
NeilBrown
