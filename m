From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: Serial ATA
Date: Fri, 28 Nov 2003 14:49:42 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20031128194942.GC21310@gtf.org>
References: <Pine.LNX.4.53.0311281522230.9312@duplo.agenda.si>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.53.0311281522230.9312@duplo.agenda.si>
To: danci@agenda.si
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Nov 28, 2003 at 03:25:34PM +0100, danci@agenda.si wrote:
> Does anyone know how far Serial ATA support is in Linux? Can we expect
> that in 2.4 kernels?

Silicon Image has been supported for a while, under CONFIG_IDE.

Other Serial ATA is supported by "libata", which has been available for
2.4.x kernels for a while:
ftp://ftp.kernel.org/pub/linux/kernel/people/jgarzik/libata/

	Jeff



