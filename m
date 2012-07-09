From: Igor M Podlesny <for.poige+lsr@gmail.com>
Subject: Re: commit backport request
Date: Mon, 9 Jul 2012 13:08:44 +0800
Message-ID: <CA+sTkh5j-eGSs7idLib-DroCD100RJec3pxQz0FciDG3o=pXCQ@mail.gmail.com>
References: <20120709140230.3cf926ec@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120709140230.3cf926ec@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: stable@vger.kernel.org, Jose Manuel dos Santos Calhariz <jose.calhariz@netvisao.pt>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 9 July 2012 12:02, NeilBrown <neilb@suse.de> wrote:
>
> Hi Mr Stable,
>
>  please apply patch
>
> commit fab363b5ff502d1b39ddcfec04271f5858d9f26e
> Author: Shaohua Li <shli@kernel.org>
> Date:   Tue Jul 3 15:57:19 2012 +1000
>
>     raid5: delayed stripe fix
>
>
> to 3.4.y and 3.2.y.
>
> It fixes a deadlock in RAID5 which can cause all IO to hang.

   What about RAID6 as well?

> It has been demonstrated to fix a real-life problem (the race is not
> theoretical).
>
> Thanks,
> NeilBrown

--
