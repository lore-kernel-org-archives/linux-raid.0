From: George Duffield <forumscollective@gmail.com>
Subject: Re: Fwd: Adding a new drive to an array
Date: Tue, 24 Jun 2014 10:10:42 +0200
Message-ID: <CAG__1a5mwewruEu1s58jpNw=EtVktZx3gauk7QQtDytCgRHLDQ@mail.gmail.com>
References: <CAG__1a6i-UsOJpy+5GdwV_a-cVDCi_F_5KztwkFbNUEONDhH5w@mail.gmail.com>
	<alpine.DEB.2.02.1406221931230.18361@uplift.swm.pp.se>
	<CAG__1a4EG1PNpy_3Zt23OuEaEn1jTsF3-0-o21EQJBRCTPVORg@mail.gmail.com>
	<CAG__1a5M8RKfk1en3j8Cz9hBsPtB+g=znbzOE3hYOZZ2ZgU++g@mail.gmail.com>
	<20140623154023.GA7171@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140623154023.GA7171@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> Any parity RAID certainly starts to run into issues in this area. RAID-6
> is significantly safer than RAID-5 but will also reach a point where
> it's no longer statistically viable. Higher parity options could be used
> then - they're not currently supported by md, but there's been some ideas
> floated over the last year or so. Non-parity RAID options (e.g. RAID-10)
> are far safer in this respect but have a higher storage overhead.
>
> Manual duplication is unlikely to offer any practical advantages over
> RAID-10 though (or layered RAID-1/RAID-0 if you prefer more control over
> the layout).
>

Intuitively I'd think manual duplication would be a lot cheaper in
terms of storage cost and scale a lot easier?

>> > You cannot avoid the resync, so stop looking into weird options. The
>> > resizing will take days.
Thanks, I'm done looking ;-)
