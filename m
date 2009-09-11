From: Ryan Wagoner <rswagoner@gmail.com>
Subject: Re: Array Power Management
Date: Fri, 11 Sep 2009 08:27:40 -0400
Message-ID: <7d86ddb90909110527l38bbe234p6c82b3a7bdf99528@mail.gmail.com>
References: <292245.77763.qm@web55804.mail.re3.yahoo.com>
	 <20090910165156.GA30820@sewage>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090910165156.GA30820@sewage>
Sender: linux-raid-owner@vger.kernel.org
To: Matt Garman <matthew.garman@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I remember this used to be the case, but it seems to be the opposite
now. What is interesting is in the lower priced drives there seems to
be a trade off for the non recoverable error rate and load / unload
cycles.

When I looked at drives over year ago for my storage I went with 1TB
Hitachi 7K1000 as they were a good price, rated for 24/7 operation,
and had the 1 per 1.0 E15 bits error rate. Recently prices have come
down and when I put together my ESXi box I went with 500GB WD RE3
drives which offer the best rating all around.

Ryan

WD RE3
http://products.wdc.com/library/specsheet/eng/2879-701281.pdf
Load/Unload Cycles 300,000
Error Rate: 1 per 1.0 E15 bits

WD Caviar Black
http://products.wdc.com/library/specsheet/eng/2879-701276.pdf
Load/Unload Cycles 300,000
Error Rate: 1 per 1.0 E14 bits

WD Caviar Blue
http://products.wdc.com/library/specsheet/eng/2879-701277.pdf
Load/Unload Cycles 50,000 minimum
Error Rate: 1 per 1.0 E15 bits

Seagate ES.2
http://www.seagate.com/docs/pdf/datasheet/disc/ds_barracuda_es_2.pdf
Load/Unload Cycles: Not Published
Error Rate: 1 per 1.0 E15 bits

Seagate Barracuda 7200.12
http://www.seagate.com/docs/pdf/datasheet/disc/ds_barracuda_7200_12.pdf
Load/Unload Cycles 50,000
Error Rate: 1 per 1.0 E14 bits

Hitachi 7K1000
http://www.hitachigst.com/tech/techlib.nsf/techdocs/67A68C59B27368FC862=
572570080FC70/$file/Deskstar7K1000_010307_final.pdf
Load/Unload Cycles 50,000
Error Rate: 1 per 1.0 E15 bits

Hitachi 7K1000.B
http://www.hitachigst.com/tech/techlib.nsf/techdocs/D70FC3A0F3216186862=
5747B00832876/$file/Deskstar_7K1000.B_DS.pdf
Load/Unload Cycles 300,000
Error Rate: 1 per 1.0 E14 bits

On Thu, Sep 10, 2009 at 12:51 PM, Matt Garman <matthew.garman@gmail.com=
> wrote:
> On Sun, Sep 06, 2009 at 08:48:03PM -0700, jahammonds prost wrote:
>> I can do this on single drives using hdparm -S to set the spindown
>> timeout, and the disks will spin up on activity as needed. Is
>> there something similar I can do with an md array? I can see
>> there's a /sys/block/md0/power/wakeup file, but I can't seem to
>> find any documentation on it. I have thought about doing an hdparm
>> -S on the array disks, but I suspect that would be A Bad Thing
>> (tm).
>
> On the same note, does anyone have any thoughts on the wear-and-tear
> caused by frequent spinup/spindown cycles?
>
> My fileserver has the Western Digital RE2 "enterprise" grade drives.
> I remember reading (years ago) that, in general, "enterprise" grade
> drives were designed to be always running (think 24/7 server), and
> rarely spun down. =A0As such, they did not tolerate a "consumer
> desktop" usage pattern very well, and trying to save power in this
> way would actually cause them to fail prematurely.
>
> Is/was such a thing true? =A0Is it worth worrying about?
>
> Thanks,
> Matt
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
