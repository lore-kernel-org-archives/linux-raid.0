From: Joshua Baker-LePain <jlb17@duke.edu>
Subject: Re: 3ware 9500s-8
Date: Thu, 16 Sep 2004 08:08:18 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0409160807560.6936@chaos.egr.duke.edu>
References: <20040916120440.GA19566@bluff>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040916120440.GA19566@bluff>
To: Sandro Dentella <sandro@e-den.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 16 Sep 2004 at 2:04pm, Sandro Dentella wrote

>   I'd like to know if 3ware 9500s SATA controller is supported by
>   3w-xxxx module. I'm using 2.4.26 kernel. When I try to load the module I
>   get:
> 
> /lib/modules/2.4.26-fix/kernel/drivers/scsi/3w-xxxx.o: init_module: No such device
> Hint: insmod errors can be caused by incorrect module parameters, including invalid IO or IRQ parameters
> /lib/modules/2.4.26-fix/kernel/drivers/scsi/3w-xxxx.o: insmod /lib/modules/2.4.26-fix/kernel/drivers/scsi/3w-xxxx.o failed
> /lib/modules/2.4.26-fix/kernel/drivers/scsi/3w-xxxx.o: insmod 3w-xxxx failed

No, it isn't.  You need 3w-9xxx, which you can download from 3ware.

-- 
Joshua Baker-LePain
Department of Biomedical Engineering
Duke University
