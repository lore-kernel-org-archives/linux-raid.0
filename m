From: Brad Campbell <brad@fnarfbargle.com>
Subject: Re: It is safe to stop Raid being reshaped
Date: Fri, 30 Dec 2011 14:19:15 +0800
Message-ID: <4EFD57E3.7060905@fnarfbargle.com>
References: <CAK90R-Bc8z3vOcitrqyEk0Lb7Pgr+ghwL7Zfq4HZRxJ1-jNHag@mail.gmail.com> <4EFB67CC.7010500@shiftmail.org> <CAK90R-ATCf6iSgod4ktvaaiDmGaiaAPFQ+On=t0Ob4g6tUWhYA@mail.gmail.com> <4EFBCA47.9010401@shiftmail.org> <CAK90R-A9BmfjO4DtA+n+pXvv9ud39G8QqkvNOJ6c0Mo3aaBNow@mail.gmail.com> <4EFCF93F.6000607@fnarfbargle.com> <CAK90R-DWAAhOx_yJsVev4+szUmkkPr-fpvT0jUFD_W1aMNhYRw@mail.gmail.com> <alpine.DEB.2.00.1112300528300.808@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1112300528300.808@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: Jeremy Thompson <jeremythompson82@gmail.com>, Asdo <asdo@shiftmail.org>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 30/12/11 12:31, Mikael Abrahamsson wrote:
> On Thu, 29 Dec 2011, Jeremy Thompson wrote:
>
>> I thought about this as well - I have an Enermax 450 in there right now... I'll have to look for 
>> a higher watt power supply next I guess.
>
> Also look at how your feeds are balanced. Some PSUs have two rails, putting all drives on a single 
> rail causes your load handling capacity to go down significantly. I recommend getting a single 
> rail PSU as well, well above the capacity you think you need.
>
I made the move to a beefy single rail supply a few years ago. Wished I'd done it sooner.

I'm using two of these :

http://www.pcpower.com/power-supply/silencer-610-eps12v.html

Both machines have 6 core Phenoms with 16GB of ram.
Machine A has 15 7200RPM drives
Machine B has 10 7200RPM and 4 15000RPM Drives

The power supplies are well within limits, run cool and I've not had an issue since I upgraded to 
them a couple of years ago.

I do staggered spin-ups on machine B, but Machine A fires all drives at boot. They've been running 
in this configuration for about 4 years on these PSU's.

Regards,
Brad
