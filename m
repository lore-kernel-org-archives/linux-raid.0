From: Yeechang Lee <ylee@pobox.com>
Subject: Re: [linux-lvm] Re: more info on the hang with 2.6.15-rc5
Date: Mon, 9 Jan 2006 09:27:10 -0800
Message-ID: <17346.40174.865171.160466@dobie.ylee.org>
References: <E1EpIfb-0001e2-GR@highlab.com>
	<43C1580B.9020609@tmr.com>
	<E1Evmqw-0001pO-Ng@highlab.com>
	<43C28E52.8080104@mattgillen.net>
	<43C290D4.5030209@projecthugo.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43C290D4.5030209@projecthugo.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: kernel-lists@projecthugo.co.uk
Cc: LVM general discussion and development <linux-lvm@redhat.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Matt Darcy <kernel-lists@projecthugo.co.uk> says:
> Judging from the ammount of problems with this driver it is %90 the
> driver and %10 raid interaction with the dirver
>
> I don't believe this is an LVM issue, more a case of the driver's
> just not ready for use, so if you use it with raid and lvm you speed
> up the crash.

I'm coming into this late, but could your issue be related to
<URL:https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=167173>?

-- 
Yeechang Lee <ylee@pobox.com> | +1 650 776 7763 | San Francisco CA US
