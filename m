From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: Data corruption after raid migration (raid5 to raid6 in 2.6.31
	with mdadm 3.1)
Date: Thu, 5 Nov 2009 21:46:38 -0800
Message-ID: <4877c76c0911052146w2b9b1362s7615925adb1763dc@mail.gmail.com>
References: <788014650911050154x1861b292i3ab221a9dec7adb0@mail.gmail.com>
	 <4877c76c0911050851y48da6e5did5d8fb39e8aad90b@mail.gmail.com>
	 <788014650911051745v2f45cb09jbdaf0a8af26a4b24@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <788014650911051745v2f45cb09jbdaf0a8af26a4b24@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: khchen@synology.com
Cc: neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Yeah, I did it the wrong way the first time and wound up with a raid-6
array that expected one more drive than I had.  It would be a lot
easier if I could have specified the target number of destination
stripes and then also specified the number of parity stripes.

I needed to reduce the added space back out, so that it could be added
as a parity device instead of another data-device.

On Thu, Nov 5, 2009 at 5:45 PM, KueiHuan Chen <kueihuan.chen@gmail.com>=
 wrote:
> Dear Michael,
>
> =A0 Did you also reduce the raid disks ? That operation need 2.6.32 a=
nd
> later. Others such like level change is working at 2.6.31.
>
> Thanks.
>
> Best Regards,
> KueiHuan-Chen
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
