From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: [PATCH md 9 of 9] Optimise reconstruction when re-adding a recently
 failed drive.
Date: Fri, 18 Feb 2005 11:58:45 +1100
Message-ID: <16917.15813.415663.814622@cse.unsw.edu.au>
References: <20050218111131.790.patches@notabene>
	<E1D1wCK-0000Xe-Qm@notabene.cse.unsw.edu.au>
	<42153C0F.1030904@h3c.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
In-Reply-To: message from Mike Hardy on Thursday February 17
Sender: linux-raid-owner@vger.kernel.org
To: Mike Hardy <mhardy@h3c.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday February 17, mhardy@h3c.com wrote:
> 
> NeilBrown wrote:
> > When an array is degraded, bit in the intent-bitmap are
> > never cleared. So if a recently failed drive is re-added, we only need
> > to reconstruct the block that are still reflected in the
> > bitmap.
> > This patch adds support for this re-adding.
> 
> Hi there -
> 
> If I understand this correctly, this means that:
> 
> 1) if I had a raid1 mirror (for example) that has no writes to it since 
> a resync
> 2) a drive fails out, and some writes occur
> 3) when I re-add the drive, only the areas where the writes occurred 
> would be re-synced?
> 
> I can think of a bunch of peripheral questions around this scenario, and 
> bad sectors / bad sector clearing, but I may not be understanding the 
> basic idea, so I wanted to ask first.

You seem to understand the basic idea.
I believe one of the motivators for this code (I didn't originate it)
is when a raid1 has one device locally and one device over a network
connection.

If the network connection breaks, that device has to be thrown
out. But when it comes back, we don't want to resync the whole array
over the network.  This functionality helps there (though there are a
few other things needed before that scenario can work smoothly).

You would only re-add a device if you thought it was OK.  i.e. if it
was a connection problem rather than a media problem, or if you had
resolved any media issues.


NeilBrown
