From: Ram Ramesh <rramesh2400@gmail.com>
Subject: Re: Looking to pick PCIe x4/x8 4+ SATA expansion card recommendation.
Date: Mon, 28 Mar 2016 14:42:39 -0500
Message-ID: <56F9892F.3030304@gmail.com>
References: <56F97B91.4070302@gmail.com> <20160328193541.GA9502@EIS>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160328193541.GA9502@EIS>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 03/28/2016 02:35 PM, Andreas Klauer wrote:
> On Mon, Mar 28, 2016 at 01:44:33PM -0500, Ram Ramesh wrote:
>> The recommendations typically go for PCIe x1-2port type cards
> Well, an 8 port card (like HP H220 or similar) is a bit too
> expensive if all you need is two more slots, and it's not
> like mdadm is picky - anything goes, well, as long as it
> meets minimum requirements (no I/O errors etc)...
>
> If you're looking for something on an even larger scale,
> maybe have a look at the Backblaze Storage Pod blog posts.
> Although the hardware they use seems to be hard to get,
> it might give you some ideas.
>
> They actually use port multipliers, I actually wish they
> were as widespread (and as cheap) as USB hubs, so we all
> could simply put three or four disks to a single SATA port,
> but alas...
>
> Maybe next time.
>
> Regards
> Andreas Klauer
Andreas,

   The two links I gave are about $120 and $80. If I used 2-port ones, 
it will be too many (to get 8 ports) and my experience with marvell 
chipset cards (4-port) was not good. So, I thought LSI 8-port is better 
and reasonably priced. I also saw several feenas threads talking about 
these cards working well in linux. Do you see risk in buying these as 
they may not be what they claim to be?

Ramesh

