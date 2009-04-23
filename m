From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Proposal: make RAID6 code optional
Date: Wed, 22 Apr 2009 18:35:25 -0700
Message-ID: <49EFC5DD.9090201@zytor.com>
References: <200904180946.27722.prakash@punnoor.de> <49E98AD2.8060601@msgid.tls.msk.ru> <200904181117.03418.prakash@punnoor.de> <alpine.LNX.2.00.0904181551320.16493@swampdragon.chaosbits.net> <20090418145850.GD28512@mea-ext.zmailer.org> <49EDD11E.2030309@tmr.com> <49EE00F9.6090000@zytor.com> <20090422180051.GD13280@skl-net.de> <49EF6457.90505@zytor.com> <20090422185703.GF13280@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090422185703.GF13280@skl-net.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: Bill Davidsen <davidsen@tmr.com>, Matti Aarnio <matti.aarnio@zmailer.org>, Jesper Juhl <jj@chaosbits.net>, Prakash Punnoor <prakash@punnoor.de>, Michael Tokarev <mjt@tls.msk.ru>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

Andre Noll wrote:
> On 11:39, H. Peter Anvin wrote:
>> Yes, I believe it would be easier than having dynamically allocated 
>> arrays.  Dynamically generated arrays using static memory allocations 
>> (bss) is one thing, but that would only reduce size of the module on 
>> disk, which I don't think anyone considers a problem.
> 
> We would save 64K of RAM in the raid5-only case if we'd defer the
> allocation of the multiplication table until the first raid6 array
> is about to be started.

Yes, and we'd have to access it through a pointer for the rest of eternity.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

