From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: component device mismatches found: 9600
Date: Sun, 31 Jul 2011 19:32:57 +0100
Message-ID: <CADNH=7H0+RP7yiE01NmxncTBapsMLRt1XkqAHxZr=FEAC9Zx1A@mail.gmail.com>
References: <4E359DC0.5090608@vorgon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E359DC0.5090608@vorgon.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Timothy D. Lenz" <tlenz@vorgon.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 31 July 2011 19:24, Timothy D. Lenz <tlenz@vorgon.com> wrote:
> Looking through the logs, I found this in daemon.log.0. Is this a sig=
n of a
> problem? Below is the entire log:
>
> Jul =C2=A03 00:57:01 x64VDR mdadm[2003]: RebuildStarted event detecte=
d on md
> device /dev/md0
> Jul =C2=A03 00:57:02 x64VDR mdadm[2003]: RebuildStarted event detecte=
d on md
> device /dev/md3
> Jul =C2=A03 01:02:10 x64VDR mdadm[2003]: RebuildStarted event detecte=
d on md
> device /dev/md1
> Jul =C2=A03 01:02:10 x64VDR mdadm[2003]: RebuildFinished event detect=
ed on md
> device /dev/md0
> Jul =C2=A03 01:03:01 x64VDR mdadm[2003]: RebuildStarted event detecte=
d on md
> device /dev/md2
> Jul =C2=A03 01:03:01 x64VDR mdadm[2003]: RebuildFinished event detect=
ed on md
> device /dev/md1, component device =C2=A0mismatches found: 9600
> Jul =C2=A03 01:19:41 x64VDR mdadm[2003]: Rebuild29 event detected on =
md device
> /dev/md3
> Jul =C2=A03 01:19:41 x64VDR mdadm[2003]: Rebuild21 event detected on =
md device
> /dev/md2
> Jul =C2=A03 01:36:21 x64VDR mdadm[2003]: Rebuild50 event detected on =
md device
> /dev/md3
> Jul =C2=A03 01:36:21 x64VDR mdadm[2003]: Rebuild41 event detected on =
md device
> /dev/md2
> Jul =C2=A03 01:53:01 x64VDR mdadm[2003]: Rebuild67 event detected on =
md device
> /dev/md3
> Jul =C2=A03 02:09:41 x64VDR mdadm[2003]: Rebuild83 event detected on =
md device
> /dev/md3
> Jul =C2=A03 02:09:41 x64VDR mdadm[2003]: Rebuild75 event detected on =
md device
> /dev/md2
> Jul =C2=A03 02:26:21 x64VDR mdadm[2003]: Rebuild88 event detected on =
md device
> /dev/md2
> Jul =C2=A03 02:32:20 x64VDR mdadm[2003]: RebuildFinished event detect=
ed on md
> device /dev/md3
> Jul =C2=A03 02:43:23 x64VDR mdadm[2003]: RebuildFinished event detect=
ed on md
> device /dev/md2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>

Could you post the output of:

smartctl -a /dev/your_hdd (all HDDs used by the arrays)
cat /proc/mdstat
mdadm -D /dev/md(your arrays)

/Mathias
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
