From: Vladimir Ivashchenko <hazard@francoudi.com>
Subject: Re: sun x4500 soft lockup during raid creation
Date: Thu, 29 Jan 2009 01:08:52 +0200
Message-ID: <20090128230852.GA8495@francoudi.com>
References: <1233174633.7008.34.camel@hazard2.francoudi.com> <20090128223330.GA14409@sillage.bis.pasteur.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090128223330.GA14409@sillage.bis.pasteur.fr>
Sender: linux-raid-owner@vger.kernel.org
To: Tru Huynh <tru@pasteur.fr>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Wed, Jan 28, 2009 at 11:33:30PM +0100, Tru Huynh wrote:

> > CentOS 5.2, 2.6.18-92.1.22.el5PAE, sata_mv. Two dual-core Opterons @ 2.8
> > Ghz, 16 GB RAM.
> any reason for using the 32 bits version instead of the 64 bits?
> 
> you must also be aware of http://kbase.redhat.com/faq/docs/DOC-15593
> 
> just my .2 cents

Always welcome :)

According to http://epubs.cclrc.ac.uk/bitstream/2943/ThumperReport.pdf, x4500 was shown to be unstable under centos/rhel 4.x (he didn't 
use mv_sata though). In any case, centos 4.x is way too old.

I changed the kernel to 2.6.27.12-78.2.8.fc9.i686 and so far it is stable. 

x64 will be the next step. i686 is what our guys install by default, I didn't bother to reinstall it.

-- 
Best Regards
Vladimir Ivashchenko
Chief Technology Officer
PrimeTel, Cyprus - www.prime-tel.com
