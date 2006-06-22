From: "Molle Bestefich" <molle.bestefich@gmail.com>
Subject: Re: Ok to go ahead with this setup?
Date: Fri, 23 Jun 2006 00:11:11 +0200
Message-ID: <62b0912f0606221511p74a78ca5id4b5d3f870258815@mail.gmail.com>
References: <bb145bd20606221008p131d4daem289a6b9300757c66@mail.gmail.com>
	 <62b0912f0606221104q2f47f574i86441efed5831957@mail.gmail.com>
	 <bb145bd20606221250y147d0a0bk1e371a3078adc09e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <bb145bd20606221250y147d0a0bk1e371a3078adc09e@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Christian Pernegger <pernegger@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Christian Pernegger wrote:
> Anything specific wrong with the Maxtors?

No.  I've used Maxtor for a long time and I'm generally happy with them.

They break now and then, but their online warranty system is great.
I've also been treated kindly by their help desk - talked to a cute
gal from Maxtor in Ireland over the phone just yesterday ;-).

Then again, they've just been acquired by Seagate, or so, so things
may change for the worse, who knows.

I'd watch out regarding the Western Digital disks, apparently they
have a bad habit of turning themselves off when used in RAID mode, for
some reason:
http://thread.gmane.org/gmane.linux.kernel.device-mapper.devel/1980/

> I read somewhere that this could reduce rebuild time when a "disk"
> (partition in this case) is kicked offline because of a timeout or
> somesuch. Sounds a bit fishy, which is why I'm asking.

The bitmap code in MD is for fast rebuilding, if you need that.

> The point of the whole exercise is that I don't want to be cut off
> from my data, just because a part of the host (not the disks) died.

I don't see any large risks of that happening with the setup you've outlined.

> And iSCSI sounds way too expensive. :)

I think a host adapter is around $100.
