From: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: RE: multiple xor_block() functions
Date: Mon, 4 Jun 2007 10:48:35 -0700
Message-ID: <0C7297FA1D2D244A9C7F6959C0BF1E5201F034A9@azsmsx413.amr.corp.intel.com>
References: <20070602185746.GI5500@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <20070602185746.GI5500@stusta.de>
Sender: linux-raid-owner@vger.kernel.org
To: Adrian Bunk <bunk@stusta.de>, mingo@redhat.com, neilb@suse.de, "John W. Linville" <linville@tuxdriver.com>, Jouni Malinen <j@w1.fi>
Cc: linux-raid@vger.kernel.org, linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

> From: Adrian Bunk [mailto:bunk@stusta.de]
> include/linux/raid/xor.h:extern void xor_block(unsigned int count,
unsigned
> int bytes, void **ptr);
> drivers/md/xor.c:xor_block(unsigned int count, unsigned int bytes,
void **ptr)
> drivers/md/xor.c:EXPORT_SYMBOL(xor_block);
> 
> and
> 
> net/ieee80211/ieee80211_crypt_ccmp.c:static inline void xor_block(u8 *
b, u8 *
> a, size_t len)
> 
> 
> At least one of them has to be renamed.
> 
I'll rename the raid version to 'xor_blocks' in the md-accel series.  [
I would have suggested xor_n_blocks except that xor_blocks is limited to
5-blocks (MAX_XOR_BLOCKS) ]

> 
> cu
> Adrian
> 

Dan
