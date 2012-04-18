From: Jack Wang <jack.wang.usish@gmail.com>
Subject: Re: RAID6 syncing at 24 MB/s?
Date: Wed, 18 Apr 2012 12:47:32 +0800
Message-ID: <CA+res+RKvCPa+8uPa+amO1LNos7EoPdh2ThnMJqSBa9hRvgYNg@mail.gmail.com>
References: <20120418043540.19923.qmail@science.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120418043540.19923.qmail@science.horizon.com>
Sender: linux-raid-owner@vger.kernel.org
To: George Spelvin <linux@horizon.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

change  speed_limit_max to a bigger value will help.

Jack

2012/4/18 George Spelvin <linux@horizon.com>:
> I'm putting together a 7x2TB RAID6 for a home media server, and after
> encountering a fun kernel bug building the array (old kernel, a new o=
ne
> fixed it), I fot things working, but now notice that each disk is syn=
cing
> at 23.8 MB/s. =C2=A0hdparm -t reports they can do well over 100 MB/s =
each,
> and the processor, while only an i3, is spending about 20% of one cor=
e
> in the raid6 task.
>
> Basicall, it was created with:
> mdadm -C -l 6 -n 7 -c 128 -b internal /dev/md0 /dev/sd[b-h]
> (The kernel bug was in 2.6.35, and was triggered by forgetting the
> "/dev/md0"; one of the RAID ioctls it tries confused up the /dev/sd
> driver quite thoroughly)
>
> It's an Intel chipset motherboard with a jmicros 2xSATA+PATA chip,
> and one port on a SiI3132 plug-in card. =C2=A0And mostly cheap Caviar=
 green
> EARS drives (yes, I know about the lack of TLER). =C2=A0Note that I d=
idn't
> partition the drives, so there's no risk of a 4K-unaligned partition.
>
> A friend with his own Linux media server said he saw the exact same s=
peed
> building his RAID6 array.
>
> The speed_limit_max is set to the default, the system is idle, and th=
e
> resultant md drive is not mounted.
>
> Is there a web page somewhere with speed tuning suggestions?
>
>
> Thank you!
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
