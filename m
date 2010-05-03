From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: Questions about 4k sector drives
Date: Mon, 3 May 2010 09:17:54 -0400
Message-ID: <4BDECD02.3020401@cfl.rr.com>
References: <4BD42B57.9000703@kusche.de> <1272206601.7734.4.camel@faldara> <4BDE0512.8070502@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BDE0512.8070502@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Florian Kusche <flox@kusche.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 5/2/2010 7:04 PM, Bill Davidsen wrote:
> Is there any reason not to just align partitions for all drives on 32kB
> sectors and expect that to work on 512b 4kB and SSD? Cautious testing
> here says it works fine, no anomalies, no exciting performance data,
> just works.

SSD usually have an erase block size of 512k, which is why Windows 7
aligns partitions to a 1 MB boundary and parted has followed suit.
