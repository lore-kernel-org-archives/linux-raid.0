From: Marcin Krol <admin@domeny.pl>
Subject: Re: Deleting mdadm RAID arrays
Date: Wed, 6 Feb 2008 10:35:20 +0100
Message-ID: <200802061035.21055.admin@domeny.pl>
References: <200802051142.19625.admin@domeny.pl> <47A84BE3.407@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47A84BE3.407@pobox.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Tuesday 05 February 2008 12:43:31 Moshe Yudkowsky napisa=C5=82(a):

> > 1. Where this info on array resides?! I have deleted /etc/mdadm/mda=
dm.conf=20
> > and /dev/md devices and yet it comes seemingly out of nowhere.

> /boot has a copy of mdadm.conf so that / and other drives can be star=
ted=20
> and then mounted. update-initramfs will update /boot's copy of mdadm.=
conf.

Yeah, I found that while deleting mdadm package...

Thanks for answers everyone anyway.

Regards,
Marcin Krol


-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
