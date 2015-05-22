From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Recent drive errors
Date: Fri, 22 May 2015 15:38:06 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1505221535550.9487@uplift.swm.pp.se>
References: <3296560.sGbn0HyrQY@balsa> <84264713.v03zHsT0Cj@balsa> <alpine.DEB.2.02.1505210956210.9487@uplift.swm.pp.se> <21066296.95yN8USVxi@balsa>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <21066296.95yN8USVxi@balsa>
Sender: linux-raid-owner@vger.kernel.org
To: Thomas Fjellstrom <thomas@fjellstrom.ca>
Cc: Phil Turmel <philip@turmel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, 21 May 2015, Thomas Fjellstrom wrote:

>> for x in /sys/block/sd[a-z] ; do
>>          echo 180  > $x/device/timeout
>> done
>
> I presume it's ok to do that even if the drives do ERC/TLER? Just woke up, but
> my brain seems to be telling me it shouldn't break anything since the ERC
> drives should always return after 7s no matter what...

Correct, the only downside is that if the drive really dies, it's going to 
take longer to detect this.

I'd rather have longer timeouts to make sure drives never kicked out 
because of lack of ERC or something else, than to have drives kicked for 
some reason (controller reset, lack of ERC, or something else).

I really really want to avoid drives being kicked for any other reason 
than them really being dead. I'd rather have reads stalled for a few 
minutes than this happening. For other use-cases, the requirements may be 
different.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
