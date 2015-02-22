From: Christer Solskogen <christer.solskogen@gmail.com>
Subject: Re: Optimal chunk size for RAID5?
Date: Sun, 22 Feb 2015 13:46:19 +0100
Message-ID: <mccj2t$8eu$1@ger.gmane.org>
References: <mccemd$8pi$1@ger.gmane.org> <20150222173047.1ea65d67@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150222173047.1ea65d67@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 22.02.2015 13:30, Roman Mamedov wrote:
> On Sun, 22 Feb 2015 12:31:23 +0100
> Christer Solskogen <christer.solskogen@gmail.com> wrote:
>
>> There are so many different views on the internet
>
> ...and yet you're asking for some more? :)
>

Heh, yes. I see the irony in that :-) But this is pretty much as the 
source as you can get.

>> Is there even such a thing as optimal chunk size?
>
> 64K should be fine:
> http://louwrentius.com/linux-raid-level-and-chunk-size-the-benchmarks.html
>

Okay, even if this is almost 5 years old, it is still applicable?

The disks I have are 4k sectors. Is there anything special I need to 
think about or is this handled automagicly these days? (I run a pretty 
fresh distro)

-- 
chs

