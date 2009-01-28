From: Tru Huynh <tru@pasteur.fr>
Subject: Re: sun x4500 soft lockup during raid creation
Date: Wed, 28 Jan 2009 23:33:30 +0100
Message-ID: <20090128223330.GA14409@sillage.bis.pasteur.fr>
References: <1233174633.7008.34.camel@hazard2.francoudi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1233174633.7008.34.camel@hazard2.francoudi.com>
Sender: linux-raid-owner@vger.kernel.org
To: Vladimir Ivashchenko <hazard@francoudi.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jan 28, 2009 at 10:30:33PM +0200, Vladimir Ivashchenko wrote:
> Hi,
> 
> We've got these new Sun X4500 servers. The system I'm playing with now
> has 48 x 250 GB SATA HDDs.
> 
> Right now I'm creating two RAID6 arrays, 24 and 22 drives each:
> ...

> CentOS 5.2, 2.6.18-92.1.22.el5PAE, sata_mv. Two dual-core Opterons @ 2.8
> Ghz, 16 GB RAM.
any reason for using the 32 bits version instead of the 64 bits?

you must also be aware of http://kbase.redhat.com/faq/docs/DOC-15593

just my .2 cents

Tru
