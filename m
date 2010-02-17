From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Linux mdadm superblock question.
Date: Wed, 17 Feb 2010 14:26:20 -0800
Message-ID: <4B7C6D0C.6020801@zytor.com>
References: <201002140251.59668.volkerarmin@googlemail.com> <201002171927.07051.volkerarmin@googlemail.com> <20100217183703.GA15446@emergent.ellipticsemi.com> <201002171946.09884.volkerarmin@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201002171946.09884.volkerarmin@googlemail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Volker Armin Hemmann <volkerarmin@googlemail.com>
Cc: Nick Bowler <nbowler@elliptictech.com>, david@lang.hm, Kyle Moffett <kyle@moffetthome.net>, Rudy Zijlstra <rudy@grumpydevil.homelinux.org>, Neil Brown <neilb@suse.de>, "Mr. James W. Laferriere" <babydr@baby-dragons.com>, Bill Davidsen <davidsen@tmr.com>, Michael Evans <mjevans1983@gmail.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/17/2010 10:46 AM, Volker Armin Hemmann wrote:
> 
> well at the moment it takes less than two seconds until init takes over.
> 
> Adding .5 seconds is a lot. And loading the initrd and changing root isn't 
> free either, true?
> 
> I remember well all the noise in the past about making linux booting faster. 
> So why slow it down with an initrd - especially if you can do without?
> 

Note that an extremely lightweight initramfs can quite possibly be
faster than doing it in the kernel, just because userspace is so much
less constrained.  I was hoping klibc would catch on for this stuff, but
it hasn't as much as I'd like.

	-hpa
