From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: Degraded array but drive healthy
Date: Wed, 4 Dec 2013 22:59:11 +0000
Message-ID: <CADNH=7G+JF6TOs6ANoaOtaX-H_mZ_yP3KvqGoUkqGP=LwbsdJw@mail.gmail.com>
References: <CAONsccXLi+1rqZQPsUSfzfuTD3+jWugiH4jAFPKQNLh0aAKSuA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAONsccXLi+1rqZQPsUSfzfuTD3+jWugiH4jAFPKQNLh0aAKSuA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Phill Watkins <phill.watkins@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 4 December 2013 22:23, Phill Watkins <phill.watkins@gmail.com> wrote:
>
> Hi,
>
> I have an issue that I can't really pin down.
>
> I have two RAID 1 arrays, one for /boot and another for an LVM.
>
> Yesterday one of the arrays (the LVM) became degraded after a reboot
> which included an automated fsck on all filesystems.
>
> I've run full SMART tests on both drives and both completed without errors:
> [SNIP]
>
> I'd really appreciate some advice.
>
> Regards
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Hi,

Full SMART Self-test does that mean smartctl -t long? You could try a
nondestructive badblocks session on both drives, but it takes a while.
http://www.pantz.org/software/badblocks/badblocksusage.html

Regards,
Mathias
