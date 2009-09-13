From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: What's in async_tx.git/next for 2.6.32?
Date: Sun, 13 Sep 2009 10:16:34 -0700
Message-ID: <4AAD28F2.3040606@intel.com>
References: <4AA2BA83.5020707@intel.com> <20090914.013052.84972601.anemo@mba.ocn.ne.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090914.013052.84972601.anemo@mba.ocn.ne.jp>
Sender: linux-raid-owner@vger.kernel.org
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "neilb@suse.de" <neilb@suse.de>, "hpa@zytor.com" <hpa@zytor.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
List-Id: linux-raid.ids

Atsushi Nemoto wrote:
> On Sat, 05 Sep 2009 12:22:43 -0700, Dan Williams <dan.j.williams@intel.com> wrote:
>> Provided Neil and Peter provide their acks for the raid6 acceleration 
>> work, here is what is pending in async_tx.git/next for 2.6.32:
> ...
>>     git://git.kernel.org/pub/scm/linux/kernel/git/djbw/async_tx.git next
>>
>> Dan Williams (67):
> ...
>>        dw_dmac: implement a private tx_list
>>        fsldma: implement a private tx_list
>>        iop-adma: implement a private tx_list
>>        ioat: implement a private tx_list
>>        mv_xor: implement a private tx_list
>>        at_hdmac: implement a private tx_list
>>        dmaengine: kill tx_list
> 
> Could you implement a private tx_list for txx9dmac too?

I noticed that too when I merged with -next.  I forgot to send this [1] out.

Thanks,
Dan

[1]: 
http://git.kernel.org/?p=linux/kernel/git/djbw/async_tx.git;a=commitdiff;h=1979b186b80449ac6574d97c254b694c8a99b703
