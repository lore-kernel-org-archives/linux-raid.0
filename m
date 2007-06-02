From: Jouni Malinen <j@w1.fi>
Subject: Re: multiple xor_block() functions
Date: Sat, 2 Jun 2007 12:43:22 -0700
Message-ID: <20070602194321.GB31754@jm.kir.nu>
References: <20070602185746.GI5500@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20070602185746.GI5500-HeJ8Db2Gnd6zQB+pC5nmwQ@public.gmane.org>
Sender: linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Adrian Bunk <bunk-HeJ8Db2Gnd6zQB+pC5nmwQ@public.gmane.org>
Cc: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org, "John W. Linville" <linville-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-raid.ids

On Sat, Jun 02, 2007 at 08:57:46PM +0200, Adrian Bunk wrote:
> include/linux/raid/xor.h:extern void xor_block(unsigned int count, unsigned int bytes, void **ptr);
> drivers/md/xor.c:xor_block(unsigned int count, unsigned int bytes, void **ptr)
> drivers/md/xor.c:EXPORT_SYMBOL(xor_block);
> 
> and
> 
> net/ieee80211/ieee80211_crypt_ccmp.c:static inline void xor_block(u8 * b, u8 * a, size_t len)
> 
> 
> At least one of them has to be renamed.

Why? Not that I would really mind renaming one of these, but I don't see
a good reason for it. ieee80211_crypt_ccmp.c should not include
linux/raid/xor.h and the xor_block() in CCMP code is a static inline
function that should not show up outside the scope of this file. Do we
have some magic that makes exported symbols pollute name space for
inlined helper functions?

-- 
Jouni Malinen                                            PGP id EFC895FA
