From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: It is safe to stop Raid being reshaped
Date: Fri, 30 Dec 2011 05:31:05 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1112300528300.808@uplift.swm.pp.se>
References: <CAK90R-Bc8z3vOcitrqyEk0Lb7Pgr+ghwL7Zfq4HZRxJ1-jNHag@mail.gmail.com> <4EFB67CC.7010500@shiftmail.org> <CAK90R-ATCf6iSgod4ktvaaiDmGaiaAPFQ+On=t0Ob4g6tUWhYA@mail.gmail.com> <4EFBCA47.9010401@shiftmail.org> <CAK90R-A9BmfjO4DtA+n+pXvv9ud39G8QqkvNOJ6c0Mo3aaBNow@mail.gmail.com>
 <4EFCF93F.6000607@fnarfbargle.com> <CAK90R-DWAAhOx_yJsVev4+szUmkkPr-fpvT0jUFD_W1aMNhYRw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAK90R-DWAAhOx_yJsVev4+szUmkkPr-fpvT0jUFD_W1aMNhYRw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jeremy Thompson <jeremythompson82@gmail.com>
Cc: Brad Campbell <brad@fnarfbargle.com>, Asdo <asdo@shiftmail.org>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, 29 Dec 2011, Jeremy Thompson wrote:

> I thought about this as well - I have an Enermax 450 in there right 
> now... I'll have to look for a higher watt power supply next I guess.

Also look at how your feeds are balanced. Some PSUs have two rails, 
putting all drives on a single rail causes your load handling capacity to 
go down significantly. I recommend getting a single rail PSU as well, well 
above the capacity you think you need.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
