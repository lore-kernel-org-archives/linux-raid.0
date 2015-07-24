From: Gionatan Danti <g.danti@assyoma.it>
Subject: Re: [PATCH] raid0: data corruption when using trim
Date: Fri, 24 Jul 2015 08:37:23 +0200
Message-ID: <55B1DD23.30907@assyoma.it>
References: <013e01d0c1d2$f3af4fb0$db0def10$@samsung.com>	<yq1y4ibknz4.fsf@sermon.lab.mkp.net> <20150720173830.GA3274@lazy.lzy>	<yq1a8uq3cu5.fsf@sermon.lab.mkp.net> <20150720183402.GA4439@lazy.lzy>	<yq11tg22kyz.fsf@sermon.lab.mkp.net> <55B11A68.4080706@assyoma.it> <yq1lhe6zfgx.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <yq1lhe6zfgx.fsf@sermon.lab.mkp.net>
Sender: linux-raid-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, Seunguk Shin <seunguk.shin@samsung.com>, neilb@suse.de, linux-raid@vger.kernel.org, g.danti@assyoma.it
List-Id: linux-raid.ids

>
> The problem only occurs if you are using MD linear/raid0/raid10 on top
> of a device that implements either DSM TRIM (SATA) or UNMAP (SCSI). If
> the device prefers WRITE SAME w/ UNMAP or if it does not support
> discards at all there is no problem.
>

Thank you for confirmation! :)

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
