From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Subject: Re: What's in async_tx.git/next for 2.6.32?
Date: Mon, 14 Sep 2009 01:30:52 +0900 (JST)
Message-ID: <20090914.013052.84972601.anemo@mba.ocn.ne.jp>
References: <4AA2BA83.5020707@intel.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754994AbZIMQaw@vger.kernel.org>
In-Reply-To: <4AA2BA83.5020707@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dan.j.williams@intel.com
Cc: linux-kernel@vger.kernel.org, neilb@suse.de, hpa@zytor.com, linux-raid@vger.kernel.org, maciej.sosnowski@intel.com
List-Id: linux-raid.ids

On Sat, 05 Sep 2009 12:22:43 -0700, Dan Williams <dan.j.williams@intel.com> wrote:
> Provided Neil and Peter provide their acks for the raid6 acceleration 
> work, here is what is pending in async_tx.git/next for 2.6.32:
...
>     git://git.kernel.org/pub/scm/linux/kernel/git/djbw/async_tx.git next
> 
> Dan Williams (67):
...
>        dw_dmac: implement a private tx_list
>        fsldma: implement a private tx_list
>        iop-adma: implement a private tx_list
>        ioat: implement a private tx_list
>        mv_xor: implement a private tx_list
>        at_hdmac: implement a private tx_list
>        dmaengine: kill tx_list

Could you implement a private tx_list for txx9dmac too?

---
Atsushi Nemoto
