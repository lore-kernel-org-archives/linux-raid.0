From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Linux Software RAID is really RAID?
Date: Wed, 4 Jul 2007 10:14:24 +0100
Message-ID: <20070704101424.5808543e@the-village.bc.nu>
References: <cd98e0260706261043t32fe6609ye1e4e252c722358c@mail.gmail.com>
	<46815C3F.6090204@wasp.net.au>
	<468A05A4.60006@gmail.com>
	<cd98e0260707030517y1fbb60ban29063439f2665834@mail.gmail.com>
	<468AD708.2010806@rtr.ca>
	<468AF5F8.9060703@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <468AF5F8.9060703@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Mark Lord <liml@rtr.ca>, Johny Mail list <maillist.johny@gmail.com>, Brad Campbell <brad@wasp.net.au>, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-raid.ids

> > A hard(ware) lockup, not software.
> > That's why Intel says ICH5 doesn't do hotplug.
> 
> OIC.  I don't think there's much left to do from the driver side then.
> Or is there any workaround?

I'm not familiar with the ICH5 SATA side but on the PATA side we also
need to run code to fix up chips on a hotplug (and *before* the plug in
some cases) - eg the ICH2 requires we turn off IORDY.
