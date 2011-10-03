From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: How to stress test an RAID 6 array?
Date: Mon, 3 Oct 2011 14:39:43 +0100
Message-ID: <CADNH=7E9n-uj-xNPq-DuYgfJ+Js9b4bWn_QyeDJ8O+ka4GjLiQ@mail.gmail.com>
References: <4E89B81D.5000800@yazzy.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E89B81D.5000800@yazzy.org>
Sender: linux-raid-owner@vger.kernel.org
To: lists@yazzy.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 3 October 2011 14:26, Marcin M. Jessa <lists@yazzy.org> wrote:
> Hi guys.
>
> After a rather long thread with many questions about my failed RAID a=
rray
> I'm trying to give it another shot.
> I replaced all the SATA cables and I want to stress test my array.
> Short description of what it was used for when it failed:
> I had a 5 drive (5x2TB Seagate Green Barracuda) RAID 6 array with LVM=
 on top
> of it.
> - One of the LVs was serving as a samba storage
> - One as a NFS exported storage with web sites
> - 3 LVs had KVM hosts installed to them (heavy hammered web server, M=
ySQL
> server and mail/imap/pop3 server)
>
> The load seemed to have stressed my array/the HDs to the point when 3=
 of the
> drives were kicked off the array resulting in loss of data.
> It's hard to find a cause of it - some forum threads on the Interner =
suggest
> it may be the kernel, some say it could be the SATA controller, the S=
ATA
> cables and most of them suggest it's because of the hard drives.
>
> Now I would like to stress test the array and see whether it would fa=
il
> again or not. What would be the best way to do that?
>
>
>
>
> --
>
> Marcin M. Jessa
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>

Hi,

I would run badblocks on the md0 device. (increase number of blocks to
check at a time until you use all your available RAM)
After that I'd run dd. I would also check the SMART data on all
drives, and the health of the controller.

/M
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
