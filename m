From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Subject: Re: Re-add not selecting drive for correct slot?
Date: Mon, 10 Aug 2015 11:44:20 -0600
Message-ID: <2248170.b8F2naoiGF@balsa>
References: <1817382.9YhZ7ff5Yl@balsa> <1526790.RuPxcltSBQ@nell> <alpine.DEB.2.02.1508101132070.11810@uplift.swm.pp.se>
Reply-To: thomas@fjellstrom.ca
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1508101132070.11810@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon 10 Aug 2015 11:35:13 AM Mikael Abrahamsson wrote:
> On Sat, 8 Aug 2015, Thomas Fjellstrom wrote:
> > I did try that :( It fails to assemble because it only sees sdc as a
> > spare.
> > Maybe because I did things with the old mdadm first, and did a --remove?
> > That seems to have wiped out the "slot" information (it's -1) so the
> > assemble force magic can't figure things out? Just a guess on my part.
> 
> Unless someone else has a better idea, I'd say you're right. If you would
> have unplugged the failed drive (so it disappeared completely), it could
> probably have been re-added. So unless you have a copy of the old
> superblock, your only way to proceed now is to use --create --assume-clean
> and get all the parameters right (order, offsets etc). There are lots of
> examples in the mailing list archives of people trying this and some
> actually suceeding.

I think the only thing that would stop that from working is that there is data 
in the bitmap. So if a assume clean is done, it might ignore that and cause 
some extra corruption?

It'd be interesting to figure out if i can set that slot number manually or 
with a tool. That might be a smarter/safer way of doing it.

-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
