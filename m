From: Ming Zhang <mingz@ele.uri.edu>
Subject: how to understand this bitmap_zero
Date: Wed, 09 Nov 2005 12:28:57 -0500
Message-ID: <1131557337.8969.466.camel@localhost.localdomain>
Reply-To: mingz@ele.uri.edu
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

could anybody help me on this? thanks!

see if we call bitmap_zero(dst, 2), it will do *dst = 0UL and thus clear
whole *dst, but what if we intent to clear 2 bits? not 32bits?

static inline void bitmap_zero(unsigned long *dst, int nbits)
{
        if (nbits <= BITS_PER_LONG)
                *dst = 0UL;
        else {
                int len = BITS_TO_LONGS(nbits) * sizeof(unsigned long);
                memset(dst, 0, len);
        }
}


Ming


