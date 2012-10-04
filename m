From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: 4HDD Raid5 - 2 Disk fails
Date: Thu, 4 Oct 2012 10:52:33 +0100
Message-ID: <CADNH=7EbXAat0-CgPMC=LSgMcwMvgTUrbOoDYQb0FRSRqCChcw@mail.gmail.com>
References: <BLU0-SMTP21143DB89A7F6581069200BC9840@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BLU0-SMTP21143DB89A7F6581069200BC9840@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: Dominique <dcouot@hotmail.com>
Cc: linux-raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 4 October 2012 10:33, Dominique <dcouot@hotmail.com> wrote:
> Hi,
>
> I am writing here out of desperation, and lost hope. I have a NAS with a 4
> HDD Raid 5 setup. A week ago, we suffered a power outage that seemed to have
> fried 2 of the 4 disks at the same time. I say seemed, since I have some
> contradictory information: 3 of the 4 power leds are still active, the web
> interface shows only 2 of 4 disks, and cli information shows that disk sda
> is partially answering, sbd and sdc are ok, sdd seems to be totally dead.
>
> Don't ask about the backup.
>
> Is there anything I can do to get sda back to some life to save what can be
> saved ?
>
> Thanks for any help.
>
> Dominique
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Hi,

Is this a PC? Can you SSH in and get some information? (dmesg, cat
/proc/mdstat, etc)

Mathias
