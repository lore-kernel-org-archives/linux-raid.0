From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: =?UTF-8?B?562U5aSN77ya562U5aSN77yadHdvIHJhaWQ1IHBlcmZvcm1hbmM=?=
 =?UTF-8?B?ZQ==?=
Date: Mon, 16 Dec 2013 22:37:19 -0600
Message-ID: <52AFD4FF.4050400@hardwarefreak.com>
References: <386c52f5-dd36-4697-b76a-d24038bbded3@aliyun.com> <fc24d5bd-da62-4c2d-8c51-c9b76a3f9dd7@aliyun.com>,3600622.49q3PtzSug@eseries.newtech.fi <a9545b2f-d9be-4616-be40-59bfff151032@aliyun.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <a9545b2f-d9be-4616-be40-59bfff151032@aliyun.com>
Sender: linux-raid-owner@vger.kernel.org
To: lilofile <lilofile@aliyun.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 12/16/2013 7:13 AM, lilofile wrote:
> mpt2sas 6Gb/s, PCIE 2.0=EF=BC=8Cthe card is four port,so theoretical =
ratio can reach to 2.4Gb/s,it is not bottleneck. I test read two raid5 =
using dd,
> such as  dd if=3D/dev/md0 of=3D/dev/zero 1M
>              dd if=3D/dev/md1 of=3D/dev/zero 1M=20
> the total read bandwidth  can reach to 2.3GB/s,so I/O bus is not a pr=
oblem.

Why are you using dd again?  I explained to you in your previous thread
why dd will never saturate your SSDs with write IO.  Use FIO.  If you
don't know how to make FIO do what you want then ask.

BTW, don't start a new thread for the same issue.  Your last thread and
this thread deal with the same RAID5 on STEC SSDs issue.  By starting a
new thread everyone loses context and history, which are critically
important when keeping track of performance tests and configurations.

I can't help but point out some irony here.  You're concerned with
throughput, yet you're connecting 12 SSDs, ~500 MB/s each, to an SAS
backplane which connects via 4-lane 6G SAS to the HBA.  With RAID5
that's 5 GB/s SAS hardware throughput funneled through a 2.4 GB/s
SFF-8088 cable.  So once you test properly, and see the write throughpu=
t
you already have, you'll see you're limited to half the hardware
throughput by your cabling/backplane.  For reads you already are seeing
this limit.

--=20
Stan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
