From: Brad Dameron <brad@seatab.com>
Subject: Re: More tales of horror from the linux (HW) raid crypt
Date: Wed, 22 Jun 2005 14:15:18 -0700
Message-ID: <1119474918.11039.18.camel@dhcpc226.office.pivotlink.com>
References: <5d96567b05061804477325d743@mail.gmail.com>
	 <200506201853.11768.hjm@tacgi.com>  <42B9BCF6.1010206@h3c.com>
	 <1119473663.22853.189.camel@seki.nac.uci.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1119473663.22853.189.camel@seki.nac.uci.edu>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 2005-06-22 at 13:54 -0700, Dan Stromberg wrote:
> On Wed, 2005-06-22 at 12:33 -0700, Mike Hardy wrote:
> 
> > I'm very interested in the relative SW raid / HW raid performance. I
> > have both in service (two raid 5 sets are actually the same size with
> > the same number of components) and see roughly the same as you mention.
> > One difference that I see is that HW raid should generate fewer
> > interrupts and lower bus traffic.
> 
> In the early days of RAID, people always used to say that for speed, you
> had to get a hardware RAID controller instead of doing software RAID.
> 
> However, I saw an interesting comment on a local linux user group
> mailing list recently.  That comment was to the effect that hardware
> RAID controllers tend to have no where near the horsepower of a modern
> desktop CPU - so the claim was (I've not verified this!) that using
> software RAID would be much faster.
> 
> I'm thinking that if you can do software RAID with a dedicated box
> that's doing nothing but RAID and a little network, then yes, that
> likely would be faster than some scaled-down hardware RAID controller -
> but it would also likely cost more, be less likely to have good hot
> swap, and so on.


This is very true. Especially with 64bit machines. The software RAID is
much faster and efficient. However with servers that are using a lot of
CPU resources it can become a bottleneck. Our inhouse application is
proven faster with hardware RAID than with software RAID. Mainly due to
the 100% CPU utilization. It being able to offload the IO to the
MegaRAID card helps. I can't wait to test it with the new 320-2E. The
CPU is twice as fast as the 320-2X we use now.

Brad Dameron
SeaTab Software
www.seatab.com

