From: KueiHuan Chen <kueihuan.chen@gmail.com>
Subject: Re: Data corruption after raid migration (raid5 to raid6 in 2.6.31
	with mdadm 3.1)
Date: Fri, 6 Nov 2009 09:45:12 +0800
Message-ID: <788014650911051745v2f45cb09jbdaf0a8af26a4b24@mail.gmail.com>
References: <788014650911050154x1861b292i3ab221a9dec7adb0@mail.gmail.com>
	 <4877c76c0911050851y48da6e5did5d8fb39e8aad90b@mail.gmail.com>
Reply-To: khchen@synology.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4877c76c0911050851y48da6e5did5d8fb39e8aad90b@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Evans <mjevans1983@gmail.com>
Cc: neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Michael,

   Did you also reduce the raid disks ? That operation need 2.6.32 and
later. Others such like level change is working at 2.6.31.

Thanks.

Best Regards,
KueiHuan-Chen



2009/11/6 Michael Evans <mjevans1983@gmail.com>:
> My copy of mdadm 3.1 didn't want me to reshape to raid6 without using
> linux-2.6.32 or later (I used the latest RC: 2.6.32-rc5-git5).
>
