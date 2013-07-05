From: Sam Bingner <sam@bingner.com>
Subject: Re: some general questions on RAID
Date: Fri, 5 Jul 2013 01:39:30 +0000
Message-ID: <CDFB4726.1374F%sam@bingner.com>
References: <51D61DA5.9090507@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51D61DA5.9090507@fnarfbargle.com>
Content-Language: en-US
Content-ID: <FC3FE4580BC52242AE93B7893B665CC5@ds.sbdhi.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <lists2009@fnarfbargle.com>, Christoph Anton Mitterer <calestyo@scientia.net>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 7/4/13 3:13 PM, "Brad Campbell" <lists2009@fnarfbargle.com> wrote:

>On 05/07/13 02:30, Christoph Anton Mitterer wrote:
>> Hi.
>>
>> Well for me personally these are follow up questions to my scenario
>> presented here: http://thread.gmane.org/gmane.linux.raid/43405
>>
>> But I think these questions would be generally interesting an I'd like
>> to add them to the Debian FAQ for mdadm (and haven't found real good
>> answers in the archives/google).
>>
>>
>> 1) I plan to use dmcrypt and LUKS and had the following stacking in
>> mind:
>> physical devices -> MD -> dmcrypt -> LVM (with multiple LVs) ->
>> filesystems
>
>I have two arrays with dmcrypt on top of MD.
>Array 1 is 4 x Seagate 15k SAS drives in a RAID10 f2.
>Array 2 is 6 x 240G SSD's in a RAID10 n2.
>
>Array 2 is partitoned. All run ext4.
>The CPU is an AMD FX8350. I can max out all arrays with sequential or
>random r/w loads. So dmcrypt is not a limiting factor for me.
>
>When I say max out, I run into bandwidth limits on the hardware before
>dmcrypt gets in the way.
>

That is because your CPU has encryption features - the QNAP devices
largely do not; I replaced the CPU in mine with one that had encryption
features because otherwise there was nothing that could bring the
performance above about 80MB/sec


Once I put in a CPU supporting AESNI I could get up to about 500MB/sec -
and this was still not CPU bound

