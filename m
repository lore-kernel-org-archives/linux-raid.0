From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: Linux mdadm superblock question.
Date: Sat, 13 Feb 2010 20:02:30 -0800
Message-ID: <4877c76c1002132002s20d942c3i7cee5418cdcf369c@mail.gmail.com>
References: <201002140251.59668.volkerarmin@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201002140251.59668.volkerarmin@googlemail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Volker Armin Hemmann <volkerarmin@googlemail.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Feb 13, 2010 at 5:51 PM, Volker Armin Hemmann
<volkerarmin@googlemail.com> wrote:
>>0.90 has a very bad problem, which is that it is hard to distinguish
>>between a RAID partition at the end of volume and a full RAID device.
>>This is because 0.90 doesn't actually tell you the start of the devic=
e.
>>
>>Then, of course, there are a lot of limitations on size, number of
>>devices, and so on in 0.90.
>
> but it is the only format supporting autodetection.
>
> So - when will autodetection be introduced with 1.X? And if not, why =
not?
>
> All I found was 'autodetection might be troublesome' and nothing else=
=2E
> =A0But dealing with initrds is troublesome too. Pure evil even.
>
> Gl=FCck Auf,
> Volker
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

I remember hearing that 1.x had /no/ plans for kernel level
auto-detection ever.  That can be accomplished in early-userspace
leaving the code in the kernel much less complex, and therefore far
more reliable.

In other words, 'auto-detection' for 1.x format devices is using an
initrd/initramfs.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
