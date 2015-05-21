From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Recent drive errors
Date: Thu, 21 May 2015 09:58:48 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1505210956210.9487@uplift.swm.pp.se>
References: <3296560.sGbn0HyrQY@balsa> <555B2DEF.60905@turmel.org> <84264713.v03zHsT0Cj@balsa>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <84264713.v03zHsT0Cj@balsa>
Sender: linux-raid-owner@vger.kernel.org
To: Thomas Fjellstrom <thomas@fjellstrom.ca>
Cc: Phil Turmel <philip@turmel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, 19 May 2015, Thomas Fjellstrom wrote:

> How many UREs are considered "ok"? Tens, hundreds, thousands, tens of 
> thousands?

I will replace any drive that have developed UNC sectors a few times, so 
I'd say "less than 10".

+1 on the "set kernel timeout to more than 120 seconds". I have this in 
/etc/rc.local:

for x in /sys/block/sd[a-z] ; do
         echo 180  > $x/device/timeout
done

echo 4096 > /sys/block/md0/md/stripe_cache_size

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
