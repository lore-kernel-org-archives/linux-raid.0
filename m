From: Dave <dave.jiang@gmail.com>
Subject: Re: max_sectors in libata when using md
Date: Thu, 26 Aug 2004 10:34:06 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <8746466a04082610346b07ea11@mail.gmail.com>
References: <412DFFA9.8030504@wasp.net.au> <8746466a0408260852205a7842@mail.gmail.com> <412E1039.7030508@pobox.com> <412E135B.1030605@wasp.net.au> <412E1D3E.2050307@pobox.com>
Reply-To: Dave <dave.jiang@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <412E1D3E.2050307@pobox.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Brad Campbell <brad@wasp.net.au>, linux-ide@vger.kernel.org, SCSI Mailing List <linux-scsi@vger.kernel.org>, RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, 26 Aug 2004 13:26:22 -0400, Jeff Garzik <jgarzik@pobox.com> wrote:
> Brad Campbell wrote:
> > In which case, these drives need to be knocked back to UDMA66 to
> > function properly on anything later than 2.6.6. Don't know why.
> > I have tried multiple drives (I have 5 of them), multiple cables (lots
> > of those) and multiple bridge boards (I have 6 of those). There is no
> > combination that is reliable on the VIA controller with any transfer
> > larger than about 0x80 sectors *OR* speeds greater than UDMA66 *OR*
> > Kernel 2.6.6 or prior.
> 
> We could always eliminate lba48 max-sectors increase on VIA controllers...
> 
>        Jeff
> 
> 

Has Brad tried it with native SATA drives instead of bridges? Could be
VIA controllers incompatible with PATA->SATA bridges.....

-- 
-= Dave =-

Software Engineer - Advanced Development Engineering Team 
Storage Component Division - Intel Corp. 
mailto://dave-DOT-jiang-AT-intel-DOT-com 
----
The views expressed in this email are
mine alone and do not necessarily 
reflect the views of my employer
(Intel Corp.).
