From: Vladimir Ivashchenko <hazard@francoudi.com>
Subject: Re: sun x4500 soft lockup during raid creation
Date: Fri, 30 Jan 2009 21:38:06 +0200
Message-ID: <1233344286.14088.36.camel@hazard2.francoudi.com>
References: <1233174633.7008.34.camel@hazard2.francoudi.com>
	 <20090128223330.GA14409@sillage.bis.pasteur.fr>
	 <20090128230852.GA8495@francoudi.com>  <49831CBB.8010609@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49831CBB.8010609@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Tru Huynh <tru@pasteur.fr>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 2009-01-30 at 10:28 -0500, Bill Davidsen wrote:

> > I changed the kernel to 2.6.27.12-78.2.8.fc9.i686 and so far it is stable. 
> >
> > x64 will be the next step. i686 is what our guys install by default, I didn't bother to reinstall it.
> >
>    
> In spite of the theoretical benefits of 64 bit, I find that the 
> advantages are "measurable but not noticeable" for most things. The lack 
> of 64 bit versions of some applications was a problem for me, but may 
> not be for you. I did find that even building from source not all 
> applications worked right, or worked at all, or in some cases compiled. :-(

More or less this is our experience also, but this box will only be used
as a file-server.

Does anybody know if software RAID benefits when being run in 64-bit ?

-- 
Best Regards,
Vladimir Ivashchenko
Chief Technology Officer
PrimeTel PLC, Cyprus - www.prime-tel.com
Tel: +357 25 100100 Fax: +357 2210 2211


