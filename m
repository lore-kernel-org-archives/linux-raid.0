From: Mark Davies <mark@curly.ii.net>
Subject: Re: raid5 recovery dramas.
Date: Mon, 30 Jun 2008 15:03:22 +0800
Message-ID: <4868853A.4050202@curly.ii.net>
References: <48608E9B.6080904@curly.ii.net>	<18532.49368.984453.933541@notabene.brown>	<4864CBAB.90201@curly.ii.net> <18533.20771.286899.160882@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18533.20771.286899.160882@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

Neil Brown wrote:

> I would create some loop back devices over files and try to make a
> similar situation and assemble the array and assure my self that
> reshape doesn't start automatically (it shouldn't while the array is
> readonly) before actually doing anything to the real devices.

Hmm, I understand what you're asking and what it means, however actually 
/doing/ it is beyond my skills at the moment.

I haven't had a chance to bring down the box and try booting from a 
liveCD, but based on the above, I don't think that's likely to work.

Thanks for your help, but I'm feeling a little discouraged at this point.


Cheers,


Mark.
