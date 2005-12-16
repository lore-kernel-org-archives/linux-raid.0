From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: SATA controller order
Date: Fri, 16 Dec 2005 04:32:03 -0500
Message-ID: <43A28993.9020000@pobox.com>
References: <20051216091439.GD24593@atc5.vermine.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20051216091439.GD24593@atc5.vermine.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andre Majorel <aym-xunil@teaser.fr>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Andre Majorel wrote:
> Hello all.
> 
> I have a motherboard with two SATA chips (Nvidia nForce 4 and
> Silicon Image SiI 3114) running Linux 2.6.14.3. The drivers are
> SCSI_SATA_NV and SCSI_SATA_SIL, both compiled-in.                               
>                                                                                 
> Ports on the SiI 3114 controller are assigned scsi0 through
> scsi3 and ports on the nForce4 chip are assigned scsi4 through
> scsi7. Is there any way to control the order so that SCSI_SATA_NV
> gets scsi0-scsi3 and SCSI_SATA_SIL gets scsi4-scsi7 instead ?

Use modules, otherwise its defined by link order...

	Jeff



