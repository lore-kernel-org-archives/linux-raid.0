From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] md/raid1:using else-if instead if.
Date: Sun, 01 Apr 2012 19:11:47 -0700
Message-ID: <4F790AE3.204@zytor.com>
References: <201204011029101719694@gmail.com> <4F78ECBF.3060700@zytor.com> <20120402115836.76e98982@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120402115836.76e98982@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: majianpeng <majianpeng@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 04/01/2012 06:58 PM, NeilBrown wrote:
> 
> I'm really surprised that the compiler doesn't optimise that out.
> 

It depends partly on what it can depend on ... it probably isn't
allowed to because of alias analysis, at least not without the else if.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

