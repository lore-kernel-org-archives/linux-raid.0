From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: Which controller is recommended for a hardware-raid
Date: Fri, 28 Nov 2003 14:45:15 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20031128194515.GA21310@gtf.org>
References: <35566.194.153.178.110.1070043394.squirrel@mail.valli.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <35566.194.153.178.110.1070043394.squirrel@mail.valli.org>
To: linuxraid@valli.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Nov 28, 2003 at 07:16:34PM +0100, linuxraid@valli.org wrote:
> Hello all,
> After painful experiences with some raid-controllers, namely
>    - Adaptec AIC-7902 in the HostRAID (RAID 1) configuration
>      (After 9 hours trying, searching compiling, I found this
>       http://mbserver.adaptec.com/view.php?bn=linux_scsi&key=1064363305&pattern=AIC-7902+hostraid
>       It's a shame!)
>    - FastTrak 100 (RAID 1 configuration)
>      (I was forced to use either SuSE or Red Hat, download a driver, and
> taint the kernel)
> So I don't want to make the same mistakes (first buy, then try) again.

There is an open source driver for the FastTrak now...
(assuming it's SATA not PATA)

	Jeff



