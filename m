From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: Is this enough for us to have triple-parity RAID?
Date: Tue, 17 Apr 2012 19:16:09 +0200
Message-ID: <20120417171609.GA2859@lazy.lzy>
References: <CAMqP1GVnOErhxj8RV=KFtzHHEJqtguEd1L_vmsS=AAi_rAPoVg@mail.gmail.com>
 <4F8D228D.8060005@westcontrol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4F8D228D.8060005@westcontrol.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david@westcontrol.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi David,

> My current state is that I've got theory worked out and written up -
> not just for triple parity, but for more parities as well.  For some
> of it, I've got Python code to test and verify the maths.  It turns
> out that triple parity can work well - but for quad parity the limit
> is 21 data disks (using generators 2, 4, and 8), or up to 33 (using
> for example 0x07, 0x35 and 0x8b as generators).  Realistically, I
> think triple parity is the limit for practical implementations.

Why is that? An RS code (255,251) should be possible, like
it is a (255,223). What's the limitation?
I'm sure there is even a "RAID-96", which is (96,64).

My wild guess would be that the generators must be chosen
in some way.

Have you had a look at the "par2" code? That seems to be
capable of doing a parametric RS, even if in 16bit words.

bye,

-- 

piergiorgio
