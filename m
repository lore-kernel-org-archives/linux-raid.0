From: Chris Allen <chris@cjx.com>
Subject: Re: How mdadm can support > 2T
Date: Wed, 15 Nov 2006 16:00:51 +0000
Message-ID: <455B39B3.1080707@cjx.com>
References: <200611151236376090234@dahuatech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200611151236376090234@dahuatech.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?GB2312?B?0+HPyNOh?= <yu_xianyin@dahuatech.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


=D3=E1=CF=C8=D3=A1 wrote:
> Ilinux-raid want to create raid0 use mdadm 2.5.6, kernel 2.6.18-iop3 =
on the intel iop80331(32bit). use 5 disks, and every hard disk is 500G.=
 But it can't beyond > 2T.  How can support >2T on the 32bit cpu ? =20
>
> command and log :
> #mdadm -C /dev/md0 -l0 -n5 /dev/sd[c,d,e,f,g]
> # mdadm --detail /dev/md0
>
>  =20

I have many arrays which are 12TB or greater - so I don't think this is
your problem.
It looks like mdadm is only using 60GB from each disk.

What output do you get from these commands:

fdisk -l /dev/sdc

mdadm --examine /dev/sdc

?

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
