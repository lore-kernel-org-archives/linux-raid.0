From: Jack Wang <jack.wang.usish@gmail.com>
Subject: Re: Manually failing a disk during a md raid6 reshape
Date: Thu, 6 Dec 2012 11:47:09 +0800
Message-ID: <CA+res+RBGOVZ_ih8zRaRKdAbRfGM1PJDXmNi96WVh6ix+f4f+w@mail.gmail.com>
References: <50BE44A8.1040502@ejane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50BE44A8.1040502@ejane.org>
Sender: linux-raid-owner@vger.kernel.org
To: EJ Vincent <ej@ejane.org>
Cc: linux-raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

2012/12/5 EJ Vincent <ej@ejane.org>:
> Greetings,
>
> I currently have a md raid6 reshape (growth, adding a disk) under-way.
> Dmesg is beginning to fill up with:
>
> [23661.913556] ata15.00: status: { DRDY }
> [23661.914443] ata15.00: failed command: WRITE FPDMA QUEUED
> [23661.915326] ata15.00: cmd 61/80:f0:00:34:e9/00:00:45:00:00/40 tag 30 ncq
> 65536 out
> [23661.915329]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4
> (timeout)
> [23661.917110] ata15.00: status: { DRDY }
> [23661.917977] ata15: hard resetting link
> [23664.116087] ata15: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [23664.118667] ata15.00: configured for UDMA/100
> [23664.118685] ata15.00: device reported invalid CHS sector 0
>
>
> Also, any conjecture on what might lead to the above error(s)?

If you do not enable async scan, you may find the ataxx to sdx mapping
from looking into dmesg.

the error seems because disk not respouse ncq write command, lead to
command timeout by upper layer, which lead to error handler action.

I gusse the reason is the faulty disk not return respounse in time.

Jack
