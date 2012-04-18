From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: Is this enough for us to have triple-parity RAID?
Date: Wed, 18 Apr 2012 20:22:01 +0200
Message-ID: <20120418182201.GA2733@lazy.lzy>
References: <CAMqP1GVnOErhxj8RV=KFtzHHEJqtguEd1L_vmsS=AAi_rAPoVg@mail.gmail.com>
 <4F8D228D.8060005@westcontrol.com>
 <20120417171609.GA2859@lazy.lzy>
 <4F8DD02F.1060504@westcontrol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4F8DD02F.1060504@westcontrol.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david@westcontrol.com>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi David,

On Tue, Apr 17, 2012 at 10:18:55PM +0200, David Brown wrote:
[...]

> For quad parity, we can try g3 = 8 as the obvious next choice in the
> pattern.  Unfortunately, we start hitting conflicts.  To recover

you should not use 8, because this is not a generator
of GF(256) with polynomial 285, the standard for the
RAID-5/6 setup.

This means than 8^k does not cover the complete field
for k in [0 254], thus having cycles and, consequently,
creating conflicts.

Some generators could be:

2, 4, 6, 9 13, 14, 16...

but not 32 nor 64.

I know that powers of two are nice, but if you want to
have generic RAID, you must use other values.

The log/exp tables, are, of course, always valid.

BTW, the GF(256) with polynomial 285 has exactly 128
generators, so it would be possible to have up to 129
parity disk (1 is not a generator), for, I guess, a
max of 256 disks (or maybe 255?).

Hope this helps,

bye,

-- 

piergiorgio
