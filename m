From: "Jon Nelson" <jnelson-linux-raid@jamponi.net>
Subject: Re: AWFUL reshape speed with raid5.
Date: Wed, 30 Jul 2008 12:48:35 -0500
Message-ID: <cccedfc60807301048t4aef1c1nd9f55e4424b0c057@mail.gmail.com>
References: <cccedfc60807281039y67c27685n161708146d7c2b3d@mail.gmail.com>
	 <alpine.DEB.1.10.0807281414020.3288@p34.internal.lan>
	 <cccedfc60807281124w6301915bo88b8be45599f4fb3@mail.gmail.com>
	 <cccedfc60807281155u7a6561a7jce3ca46799f46e4@mail.gmail.com>
	 <48909578.9020307@tmr.com>
	 <cccedfc60807300931g5a05b197j38022a024fa1f0e@mail.gmail.com>
	 <alpine.DEB.1.10.0807301306510.1848@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0807301306510.1848@p34.internal.lan>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Bill Davidsen <davidsen@tmr.com>, LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Jul 30, 2008 at 12:08 PM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
> In dstat, the speed is doubled for the total for some reason, divide by 2
> (if you compare with iostat -x -k 1) you should see the difference.

Ah, nice catch. It still doesn't change my question.
Upon further reflection, I believe I know what has caused the
read/write disparity:

1. I've done so much testing with these devices that the contents have
been zeroed many times.
2. I am GUESSING that if the raid recovery code reads from drives A,
B, and C, builds the appropriate checksum and verifies it, if the
checksum matches it skips the write. I believe that this is what is
happening. To confirm, I wrote a few gigs of /dev/urandom to one of
the devices and re-tested. Indeed, this time around I saw plenty of
writing. One mystery solved.

Remaining questions:

1. Why does the version of metadata matter so much in a --grow --size operation?
2. There appear to be bugs when a bitmap is used. Can somebody else confirm?
3. I'll look into the awful speed thing later as that doesn't seem to
be an issue.

-- 
Jon
