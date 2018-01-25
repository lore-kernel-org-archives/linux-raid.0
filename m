From: Roger Heflin <rogerheflin@gmail.com>
Subject: Re: USB-to-SATA and RAID
Date: Thu, 25 Jan 2018 09:38:47 -0600
Message-ID: <CAAMCDefsU_Zbp+KU=mMx9SJvXuj3wOuJ303Fo68wLhg2efcTwg@mail.gmail.com>
References: <20180123201614.GI23784@otheros> <ea8286c7-d5de-610a-8bd0-40481dfa2cd4@hardwarefreak.com>
 <20180125003628.GB1756@otheros>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20180125003628.GB1756@otheros>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?Q?Linus_L=C3=BCssing?= <linus.luessing@c0d3.blue>
Cc: Stan Hoeppner <stan@hardwarefreak.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Based on my experience most motherboards only have 2 or 3 actual usb
ports, and all of the others ports are off a hub connected to the real
ports.   And if you put more than one high bandwidth device on the
same port then things get really ugly if both devices are being
heavily used.  Most add-on cards also only have 1 port, if you look
hard enough you can find cards with 2-4 real ports.   I have one that
has 4 actual real ports, and worked reasonably well for several
webcams, but I believe this one was the only one on the market that
had 4 ports and was reasonably cheap.   In general the sharing apears
to be the major issue so it is probably kind of related to the SATA
port multiplier issue since most usb ports are shared resources and
really a similar design, with similar issues.  I am guessing if you
put one usb disk per real usb port and did not plug anything else into
it it would probably work reasonably well, but to built out a setup
like that you might was well just build out an esata setup.

On Wed, Jan 24, 2018 at 6:36 PM, Linus L=C3=BCssing <linus.luessing@c0d3.bl=
ue> wrote:
> Hi,
>
> Many thanks for all the quick and helpful responses so far!
>
>
> On Tue, Jan 23, 2018 at 06:40:14PM -0600, Stan Hoeppner wrote:
>> > Could someone elaborate further on this? Does "interacts very
>> > badly" mean that there will be potential data loss / data
>> > corruption? Or does "very badly" just mean short, temporary
>> > performance issues / lags upon a disk failure?
>>
>> Potential data loss / data corruption.  Don't use USB.  Use eSATA instea=
d.
>> The list archives of linux-raid and linux-xfs are dotted with USB disk
>> horror stories.
>
> Interesting. Do you know what they could be attributed to
> technically? Were they usually similar to what Vojt=C4=9Bch had
> described, so connectivity issues due to the poor connectors and
> thin cables which can often be found with USB? And things then
> fell over when for a brief moment connectivity issues occured for
> more disks than redundant disks were configured? Or do the extra
> latencies with USB create an extended exposure to the write loop
> hole in RAID5? Or something else?
>
> Would you guys say that ARM boards with a SATA connector
> internally weird to USB (for instance the Ordoid HC2[*]), and then
> maybe some SATA Port Multiplier are similarly affected? Or would say
> that those are mainly unaffected of the common issues with RAIDs
> via SATA over USB?
>
> Regards, Linus
>
> [*]: http://www.hardkernel.com/main/products/prdt_info.php?g_code=3DG1515=
05170472&tab_idx=3D2
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
