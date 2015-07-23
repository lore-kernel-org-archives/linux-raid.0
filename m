From: Gionatan Danti <g.danti@assyoma.it>
Subject: Re: [PATCH] raid0: data corruption when using trim
Date: Thu, 23 Jul 2015 18:46:32 +0200
Message-ID: <55B11A68.4080706@assyoma.it>
References: <013e01d0c1d2$f3af4fb0$db0def10$@samsung.com>	<yq1y4ibknz4.fsf@sermon.lab.mkp.net> <20150720173830.GA3274@lazy.lzy>	<yq1a8uq3cu5.fsf@sermon.lab.mkp.net> <20150720183402.GA4439@lazy.lzy> <yq11tg22kyz.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <yq11tg22kyz.fsf@sermon.lab.mkp.net>
Sender: linux-raid-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: Seunguk Shin <seunguk.shin@samsung.com>, neilb@suse.de, linux-raid@vger.kernel.org, g.danti@assyoma.it
List-Id: linux-raid.ids

>
> Piergiorgio> There is LVM on top, I wonder if this makes a difference.
>
> It does not.
>

Hi all,
it is my understanding that, when backed by SSDs (and configured for 
passing down TRIM requests), ThinLVM are prime condidate for trigger the 
bug.

But what about ThinLVM + MDRAID10 on top of normal (spinning HDD)? 
Generally SATA HDDs do not support TRIM/UNMAP, but when using ThinLVM, 
the thin-provision mapper advertise TRIM support, and indeed an "fstrim 
-v /" succeeds.

I *think* that, as this TRIM command is processed way above the ATA 
layer (it is processed inside the device-mapper code), the bug should 
not happen here. Is it correct? Are we safe with ThinLVM + MDRAID10 + HDDs?

Thanks.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
