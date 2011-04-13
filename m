From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: RAID6 data-check took almost 2 hours, clicking sounds, system unresponsive
Date: Wed, 13 Apr 2011 23:28:05 +0100
Message-ID: <BANLkTinc-+cb-ZLJBr7m4283xf_MjZ2VmQ@mail.gmail.com>
References: <724474.42236.qm@web65102.mail.ac2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <724474.42236.qm@web65102.mail.ac2.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Gavin Flower <gavinflower@yahoo.com>
Cc: neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 13 April 2011 23:24, Gavin Flower <gavinflower@yahoo.com> wrote:
>
> --- On Fri, 8/4/11, Gavin Flower <gavinflower@yahoo.com> wrote:
>
>> From: Gavin Flower <gavinflower@yahoo.com>
>> Subject: RAID6 data-check took almost 2 hours, clicking sounds, syst=
em unresponsive
> [...]
>> This morning, I noticed my system was extremely
>> unresponsive, and that there were clicking sounds coming
>> from one of my 5 hard drives.
> [...]
>
> Hi Neil,
>
> When I do
> =C2=A0 badblocks -s -v /dev/sdc
> I hear clicking sounds from the hard drive, and notice lots and lots =
of log messages such as:
> ata3: exception Emask 0x10 SAct 0x0 SErr 0x90200 action 0xe frozen
> ata3: irq_stat 0x00400000, PHY RDY changed
> ata3: SError: { Persist PHYRdyChg 10B8B }
> ata3: hard resetting link
> ata3: softreset failed (device not ready)
> ata3: applying SB600 PMP SRST workaround and retrying
> ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
> ata3.00: configured for UDMA/33
> ata3: EH complete
>
> So I assume that the clicking corresponds to the hard reset, but I'm =
not certain of that. =C2=A0Initially, I thought it might be some kind o=
f disk head problems. =C2=A0Note that smart reports no bad blocks.
>
>
> Regards,
> Gavin
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>

Perhaps you could post the full smartctl -a output?

Regards,
Mathias
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
