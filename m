From: Krzysztof Adamski <k@adamski.org>
Subject: Re: It is safe to stop Raid being reshaped
Date: Fri, 30 Dec 2011 09:51:25 -0500
Message-ID: <1325256685.7358.34.camel@oxygen.netxsys.com>
References: <CAK90R-Bc8z3vOcitrqyEk0Lb7Pgr+ghwL7Zfq4HZRxJ1-jNHag@mail.gmail.com>
	 <4EFB67CC.7010500@shiftmail.org>
	 <CAK90R-ATCf6iSgod4ktvaaiDmGaiaAPFQ+On=t0Ob4g6tUWhYA@mail.gmail.com>
	 <4EFBCA47.9010401@shiftmail.org>
	 <CAK90R-A9BmfjO4DtA+n+pXvv9ud39G8QqkvNOJ6c0Mo3aaBNow@mail.gmail.com>
	 <4EFCF93F.6000607@fnarfbargle.com>
	 <CAK90R-DWAAhOx_yJsVev4+szUmkkPr-fpvT0jUFD_W1aMNhYRw@mail.gmail.com>
	 <alpine.DEB.2.00.1112300528300.808@uplift.swm.pp.se>
	 <Pine.GSO.4.64.1112301310190.24961@montezuma.acc.umu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.GSO.4.64.1112301310190.24961@montezuma.acc.umu.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mattias Wadenstein <maswan@acc.umu.se>
Cc: Mikael Abrahamsson <swmike@swm.pp.se>, Jeremy Thompson <jeremythompson82@gmail.com>, Brad Campbell <brad@fnarfbargle.com>, Asdo <asdo@shiftmail.org>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, 2011-12-30 at 13:16 +0100, Mattias Wadenstein wrote:
> On Fri, 30 Dec 2011, Mikael Abrahamsson wrote:
> 
> > On Thu, 29 Dec 2011, Jeremy Thompson wrote:
> >
> >> I thought about this as well - I have an Enermax 450 in there right now... 
> >> I'll have to look for a higher watt power supply next I guess.
> >
> > Also look at how your feeds are balanced. Some PSUs have two rails, putting 
> > all drives on a single rail causes your load handling capacity to go down 
> > significantly. I recommend getting a single rail PSU as well, well above the 
> > capacity you think you need.
> 
> Not only that, take a good look at both the 5V and 12V specs, and compare 
> them to the draw needed by the drives (and the rest of the system). I've 
> found that the ammount of 5V available varies lots between PSUs, without 
> much correlation with the 12V supply. Which is fine for modern CPUs/GPUs 
> which mostly uses 12V, but drives seem to want quite a bit of 5V too.
> 
> One other common problem with multiple rail PSUs is that often all the 
> useful power connectors (sata/molex) are only on one rail. I wouldn't mind 
> multiple rails if I could actually use all of them for drives.
> 
> For the 24-drive home build I've done, I've actually ended up running two 
> PSUs in parallel (joining ground), but this is hardly something to 
> recommend to anyone sane. ;)

I can give you my recommendation for a power supply based on my box.
The box has 22 drives (all 7200), dual core Phenom II, 8 Gig ram.
The PS is a OCZ ModXstream Pro 700. It has been running for over a year
without showing any problems. In a normal steady state the box draws 260
Watts from the wall as measures by a Kill-A-Watt device.

K

