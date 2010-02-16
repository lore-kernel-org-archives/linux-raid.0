From: Michael <michael@rw23.de>
Subject: Re: =?UTF-8?Q?Slow=28=3F=29=20raid=35=20to=20raid=36=20reshape=20speed?=
Date: Tue, 16 Feb 2010 20:11:13 +0100
Message-ID: <8d1abe44b332189eb67b55af57b4ba94@rw23.de>
References: <ee1fb9c4204eafc9daffb4341d0de646@rw23.de> <4B7AD738.6080503@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B7AD738.6080503@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 16 Feb 2010 12:34:48 -0500, Bill Davidsen <davidsen@tmr.com>
wrote:
> Michael wrote:
>> setting the stripe_cache to 8192 or something did not show a real
>> performance gain.
>>
>>   
> You can go larger than that, double it or try 32k. I have heard reports 
> of evil at 64k, I wouldn't go there other than with test data.

well, my "evil" value is at 32k, crashed my system to a unuseable state.
could be related to my 4gb memory in a 32bit system. i think people with 64
bit can go higher.

something from my logfile can be read here if it is interesting:
http://pastebin.ca/1798794
my x server crashed, and i was not able to do anything anymore related to
the raid device.
i.e. echo 1024 > /sys/block/md2/md/stripe_cache_size hangs, also cat
/proc/mdstat.

was a nice crash that stopped my heart for some seconds. thanks to neil
for making "resuming" of reshape processes possible.
