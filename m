From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: Identify actual drives/partitions behind RAID
Date: Tue, 15 Jul 2014 09:33:25 +0100
Message-ID: <CADNH=7EKofDgGmX3zZvk00UWb_h0tQ0uxVGmqR+9cwxk9fp8tQ@mail.gmail.com>
References: <CAHCQOsCarp3nnCyKWGpy=_Xn=NnX_qcn8tSumpNJAc5=q9Weqg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAHCQOsCarp3nnCyKWGpy=_Xn=NnX_qcn8tSumpNJAc5=q9Weqg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Sachin Garg <sgarg.bugreporter@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 15 July 2014 02:55, Sachin Garg <sgarg.bugreporter@gmail.com> wrote:
> Hi,
>
> I want to be able to identify the exact device creating truble for my
> RAID-5 backed LVM.
>
> The issue:
>
> I have a 4 disc RAID-5 array that holds my /home asan LVM volume
> group. Recently, I am getting errors like:
>
> Buffer I/O error on device dm-7, logical block 10526729
>
> So, I do:
>
> # dmsetup table /dev/dm-7
> 0 251658240 linear 9:127 2048
>
> Major 9, Minor 127 is my MD device "/dev/md127"
>
> My /dev/md127 is made up of 4 disk partitions.
>
> I want to know on what disk does "logical block 10526729" lie so that
> I can identify the culprit and replace that disk.
>
> Any ideas?
> Best,
> Sachin
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

That's an odd way of going about it. Why not just scrub/check the
array and see what MD comes back with? Also, "smartctl -t long
/dev/sdX" tests.

Regards,
Mathias
