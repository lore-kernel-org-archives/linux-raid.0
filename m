From: Adrian Bunk <bunk@stusta.de>
Subject: multiple xor_block() functions
Date: Sat, 2 Jun 2007 20:57:46 +0200
Message-ID: <20070602185746.GI5500@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>, mingo@redhat.com, neilb@suse.de, "John W. Linville" <linville@tuxdriver.com>, Jouni Malinen <j@w1.fi>
Cc: linux-raid@vger.kernel.org, linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

include/linux/raid/xor.h:extern void xor_block(unsigned int count, unsigned int bytes, void **ptr);
drivers/md/xor.c:xor_block(unsigned int count, unsigned int bytes, void **ptr)
drivers/md/xor.c:EXPORT_SYMBOL(xor_block);

and

net/ieee80211/ieee80211_crypt_ccmp.c:static inline void xor_block(u8 * b, u8 * a, size_t len)


At least one of them has to be renamed.


cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

