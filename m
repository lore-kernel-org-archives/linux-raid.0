From: Marcin Krol <admin@domeny.pl>
Subject: Re: Deleting mdadm RAID arrays
Date: Fri, 8 Feb 2008 13:52:33 +0100
Message-ID: <200802081352.33944.admin@domeny.pl>
References: <200802051142.19625.admin@domeny.pl> <200802081035.25722.admin@domeny.pl> <47AC4EA2.4010805@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47AC4EA2.4010805@tmr.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

=46riday 08 February 2008 13:44:18 Bill Davidsen napisa=C5=82(a):

> > This is exactly what is not clear for me: what is it that identifie=
s drive/partition as part of=20
> > the array? /dev/sd name? UUID as part of superblock? /dev/d_n?
> >
> > If it's UUID I should be safe regardless of /dev/sd* designation? Y=
es or no?

> Yes, absolutely.

OK, that's what I needed to know.=20


Regards,
Marcin Krol
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
