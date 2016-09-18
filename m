From: Guoqing Jiang <gqjiang@suse.com>
Subject: Re: Question about commit f9a67b1182e5 ("md/bitmap: clear bitmap if
 bitmap_create failed").
Date: Sun, 18 Sep 2016 05:19:42 -0400
Message-ID: <57DE5C2E.6040903@suse.com>
References: <752ab1d9-412a-149b-a241-e604040ebaff@wanadoo.fr>
 <20160913172433.GB24264@kernel.org> <57D9097C.5050202@suse.com>
 <5e0b941c-1536-3242-eb26-a500e5bb4ff6@wanadoo.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5e0b941c-1536-3242-eb26-a500e5bb4ff6@wanadoo.fr>
Sender: linux-raid-owner@vger.kernel.org
To: Marion & Christophe JAILLET <christophe.jaillet@wanadoo.fr>, Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids



On 09/14/2016 04:39 PM, Marion & Christophe JAILLET wrote:
>
> I don't share your feeling.
> bitmap_create() can return ERR_PTR(-ENOMEM) or ERR_PTR(-EINVAL).
>
> In such cases 'if (!bitmap)' will not be helpful.
>
> Maybe it should be turned into 'if (IS_ERR_OR_NULL(bitmap))' to handle 
> errors returned by bitmap_create.
> Maybe just removing the call to 'bitmap_free(bitmap)' is enough.
>

I agreed we can remove it, if so, seems we are not consistent with the 
previous comment  of bitmap_create.

/*
  * initialize the bitmap structure
  * if this returns an error, bitmap_destroy must be called to do clean up
  */

What about revert it and re-use v1 patch? see 
http://www.spinics.net/lists/raid/msg51819.html.

Thanks,
Guoqing
