From: Tejun Heo <tj@kernel.org>
Subject: Re: exception Emask 0x0 SAct 0x1 / SErr 0x0 action 0x2 frozen
Date: Sat, 04 Oct 2008 11:27:13 +0900
Message-ID: <48E6D481.7050407@kernel.org>
References: <3E6D0C24877245C3A5A327129A7B4CA7@909927SOSLA>  <alpine.DEB.1.10.0809220828490.23159@p34.internal.lan>  <5419A02543384E69AF2BA82FF6E66C14@909927SOSLA>  <alpine.DEB.1.10.0809220903400.23159@p34.internal.lan>  <4B1ABD0393EF40FFB0A12242FE8356AF@909927SOSLA>  <alpine.DEB.1.10.0809220915470.23159@p34.internal.lan>  <alpine.DEB.1.10.0809220926240.23159@p34.internal.lan>  <e7510f760809231114y6cbaf13aqf7c63bd48a73c978@mail.gmail.com>  <48DBAB81.8050900@tmr.com> <48E08E2D.6050905@kernel.org> <a52a95e30809301347s70b57ebfh280a6871329afd72@mail.gmail.com> <alpine.DEB.1.10.0809301715280.14600@p34.internal.lan> <alpine.LNX.2.00.0809301946020.16014@filesrv1.baby-dragons.com> <alpine.DEB.1.10.0810010403500.16900@p34.internal.lan> <alpine.DEB.1.10.0810010710520.22435@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0810010710520.22435@p34.internal.lan>
Sender: linux-ide-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: "Mr. James W. Laferriere" <babydr@baby-dragons.com>, Tom Mortensen <tmmlkml@gmail.com>, Bill Davidsen <davidsen@tmr.com>, Gwendal Grignou <gwendal@google.com>, Brian Rademacher <rad@radfiles.net>, linux-ide@vger.kernel.org, linux-raid maillist <linux-raid@vger.kernel.org>, Linux Kernel Maillist <linux-kernel@vger.kernel.org>, Bruce Allen <ballen@gravity.phys.uwm.edu>
List-Id: linux-raid.ids

Justin Piszcz wrote:
> [469680.004654] ata2.00: status: { DRDY }
> [469680.004660] ata2: hard resetting link
> [469680.309567] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [469680.333461] ata2.00: configured for UDMA/133
> [469680.333477] ata2: EH complete
> [469680.333461] sd 1:0:0:0: [sdb] 586072368 512-byte hardware sectors
> (300069 MB)
> [469680.340461] sd 1:0:0:0: [sdb] Write Protect is off
> [469680.340461] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
> [469680.345461] sd 1:0:0:0: [sdb] Write cache: enabled, read cache:
> enabled, doesn't support DPO or FUA

You're leaving the good part out.  Please always attach full kernel
log.

Thanks.

-- 
tejun
