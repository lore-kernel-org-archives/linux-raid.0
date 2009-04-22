From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: Proposal: make RAID6 code optional
Date: Wed, 22 Apr 2009 20:31:13 +0200
Message-ID: <87vdowlevi.fsf@frosties.localdomain>
References: <200904180946.27722.prakash@punnoor.de>
	<49E98AD2.8060601@msgid.tls.msk.ru>
	<200904181117.03418.prakash@punnoor.de>
	<alpine.LNX.2.00.0904181551320.16493@swampdragon.chaosbits.net>
	<20090418145850.GD28512@mea-ext.zmailer.org>
	<49EDD11E.2030309@tmr.com> <49EE00F9.6090000@zytor.com>
	<20090422180051.GD13280@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090422180051.GD13280@skl-net.de> (Andre Noll's message of
	"Wed, 22 Apr 2009 20:00:51 +0200")
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Bill Davidsen <davidsen@tmr.com>, Matti Aarnio <matti.aarnio@zmailer.org>, Jesper Juhl <jj@chaosbits.net>, Prakash Punnoor <prakash@punnoor.de>, Michael Tokarev <mjt@tls.msk.ru>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

Andre Noll <maan@systemlinux.org> writes:

> On 10:23, H. Peter Anvin wrote:
>
>> We could use vmalloc() and generate the tables at initialization time.
>> However, having a separate module which exports the raid6 declaration
>> and uses the raid5 module as a subroutine library seems easier.
>
> Really? Easier than keeping only two 256-byte arrays for exp() and
> log() and use these at runtime to populate the (dynamically allocated)
> 64K GF multiplication table? That seems to be really simple and would
> still shave off 64K of kernel memory for raid5-only users.
>
> Andre

Oh, you mean when the first raid6 device is started and not when the
module is loaded. That would work.

MfG
        Goswin
