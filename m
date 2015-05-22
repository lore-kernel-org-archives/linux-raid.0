From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Subject: Re: Recent drive errors
Date: Fri, 22 May 2015 08:19:08 -0600
Message-ID: <1841554.OffkGPDYdo@balsa>
References: <3296560.sGbn0HyrQY@balsa> <21066296.95yN8USVxi@balsa> <alpine.DEB.2.02.1505221535550.9487@uplift.swm.pp.se>
Reply-To: thomas@fjellstrom.ca
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1505221535550.9487@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: Phil Turmel <philip@turmel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri 22 May 2015 03:38:06 PM Mikael Abrahamsson wrote:
> On Thu, 21 May 2015, Thomas Fjellstrom wrote:
> >> for x in /sys/block/sd[a-z] ; do
> >> 
> >>          echo 180  > $x/device/timeout
> >> 
> >> done
> > 
> > I presume it's ok to do that even if the drives do ERC/TLER? Just woke up,
> > but my brain seems to be telling me it shouldn't break anything since the
> > ERC drives should always return after 7s no matter what...
> 
> Correct, the only downside is that if the drive really dies, it's going to
> take longer to detect this.
> 
> I'd rather have longer timeouts to make sure drives never kicked out
> because of lack of ERC or something else, than to have drives kicked for
> some reason (controller reset, lack of ERC, or something else).
> 
> I really really want to avoid drives being kicked for any other reason
> than them really being dead. I'd rather have reads stalled for a few
> minutes than this happening. For other use-cases, the requirements may be
> different.

Yeah, I agree. Especially given this is just my home nas and nas backup setup, 
It's better to just stall rather than die horribly.

-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
