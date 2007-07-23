From: Rene Herman <rene.herman@gmail.com>
Subject: Re: [RFH] Partition table recovery
Date: Mon, 23 Jul 2007 14:39:11 +0200
Message-ID: <46A4A16F.7070100@gmail.com>
References: <200707200813.03553.a1426z@gawab.com> <46A24846.7050803@gmail.com> <20070722011141.GJ26752@thunk.org> <200707220710.31402.a1426z@gawab.com> <20070722162802.GA20174@thunk.org> <46A46399.5090406@gmail.com> <20070723084146.GP22998@lug-owl.de> <46A488EB.2050305@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <46A488EB.2050305@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jan-Benedict Glaw <jbglaw@lug-owl.de>
Cc: Theodore Tso <tytso@mit.edu>, linux-fsdevel@vger.kernel.org, Al Boldi <a1426z@gawab.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On 07/23/2007 12:54 PM, Rene Herman wrote:

> static inline uint32_t le_32(uint32_t n)
> {
> #ifdef __LITTLE_ENDIAN
> 	return n;
> #else
> 	return bswap_32(n);
> #endif
> }

#if __BYTE_ORDER == __LITTLE_ENDIAN, that is. sigh.

Rene.
