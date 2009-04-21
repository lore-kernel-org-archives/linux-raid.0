From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Proposal: make RAID6 code optional
Date: Tue, 21 Apr 2009 10:23:05 -0700
Message-ID: <49EE00F9.6090000@zytor.com>
References: <200904180946.27722.prakash@punnoor.de> <49E98AD2.8060601@msgid.tls.msk.ru> <200904181117.03418.prakash@punnoor.de> <alpine.LNX.2.00.0904181551320.16493@swampdragon.chaosbits.net> <20090418145850.GD28512@mea-ext.zmailer.org> <49EDD11E.2030309@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49EDD11E.2030309@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Matti Aarnio <matti.aarnio@zmailer.org>, Jesper Juhl <jj@chaosbits.net>, Prakash Punnoor <prakash@punnoor.de>, Michael Tokarev <mjt@tls.msk.ru>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

Bill Davidsen wrote:
> It would seem that that space could be allocated and populated when
> raid6 was first used, as part of the initialization. I haven't looked at
> that code since it was new, so I might be optimistic about doing it that
> way.

We could use vmalloc() and generate the tables at initialization time.
However, having a separate module which exports the raid6 declaration
and uses the raid5 module as a subroutine library seems easier.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

