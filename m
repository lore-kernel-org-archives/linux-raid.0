From: Jon Hardcastle <jonathan.hardcastle@gmail.com>
Subject: Re: Determining which spindle is out of order
Date: Wed, 3 Nov 2010 19:00:32 +0000
Message-ID: <AANLkTinRXL00ruTwOzMq=yxhPbuBadbeBKOP=g3X85M+@mail.gmail.com>
References: <loom.20101103T115828-494@post.gmane.org>
	<20101103193841.57e5cb41@natsu>
	<001301cb7b6a$38d7fce0$aa87f6a0$@woodlea.com>
	<20101103210516.66c5deb8@natsu>
Reply-To: Jon@eHardcastle.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101103210516.66c5deb8@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <roman@rm.pp.ru>
Cc: Graham Mitchell <gmitch@woodlea.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 3 November 2010 16:05, Roman Mamedov <roman@rm.pp.ru> wrote:
> On Wed, 3 Nov 2010 11:17:24 -0400
> "Graham Mitchell" <gmitch@woodlea.com> wrote:
>
>> >
>> > That's totally stupid <snip>
>> >
>> > --
>> > With respect,
>> > Roman
>>
>> Err....
>
> Yeah, sorry about that -- and to make my reply a bit less useless, I should
> elaborate that my suggestion is to not base anything on the sdX or their order
> at all. For example even though I want to have a specific list of looked-at
> devices in mdadm.conf, I point it directly to specific drives -- not
> to /dev/sdX, but to udev symlinks in /dev/disk/by-id/ instead:
>
> # 2TBs
> DEVICE /dev/disk/by-id/ata-WDC_WD20EADS-00S2B0_WD-xxxxxxxxxxxx-part*
> DEVICE /dev/disk/by-id/ata-WDC_WD20EADS-00S2B0_WD-xxxxxxxxxxxx-part*
> DEVICE /dev/disk/by-id/ata-Hitachi_HDS722020ALA330_xxxxxxxxxxxxxx-part*
> # 1.5 TBs
> DEVICE /dev/disk/by-id/ata-WDC_WD15EADS-00S2B0_WD-xxxxxxxxxxxx-part*
> # 1TBs
> DEVICE /dev/disk/by-id/ata-Hitachi_HDT721010SLA360_xxxxxxxxxxxxxx-part*
> DEVICE /dev/disk/by-id/ata-ST31000333AS_xxxxxxxx-part*
>
> Listed like this it will also make mdadm not consider whole block devices for
> addition into RAIDs, only the partitions (which is exactly what I want).
>
> --
> With respect,
> Roman
>

See occasionally little gems of information like that come up... and
they change my world.
