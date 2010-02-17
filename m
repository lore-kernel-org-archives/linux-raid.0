From: Neil Brown <neilb@suse.de>
Subject: Re: Linux mdadm superblock question.
Date: Thu, 18 Feb 2010 10:15:00 +1100
Message-ID: <20100218101500.18c53517@notabene.brown>
References: <201002140251.59668.volkerarmin@googlemail.com>
	<alpine.LNX.2.01.1002161541370.24961@filesrv1.baby-dragons.com>
	<20100217130103.3ca65ef3@notabene.brown>
	<201002170338.47302.volkerarmin@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201002170338.47302.volkerarmin@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Volker Armin Hemmann <volkerarmin@googlemail.com>
Cc: "Mr. James W. Laferriere" <babydr@baby-dragons.com>, Bill Davidsen <davidsen@tmr.com>, Michael Evans <mjevans1983@gmail.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 17 Feb 2010 03:38:46 +0100
Volker Armin Hemmann <volkerarmin@googlemail.com> wrote:

> On Mittwoch 17 Februar 2010, Neil Brown wrote:
> 
> > I will not be removing 0.90 or auto-assemble from the kernel in the
> > foreseeable future.
> > None the less, I recommend weaning yourself from your dependence on it.
> > initramfs is the future, embrace it.
> > 
> > NeilBrown
> 
> a future that is worse than the present. For what reason?

Reason: some things are easier to implement and maintain in userspace.
Implementing them in the kernel would likely produce a worse products.

Worse than the present:  only if you refuse to embrace it and there-by
contribute to fixing/improving it.

NeilBrown
