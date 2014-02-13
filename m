From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Automatically drop caches after mdadm fails a drive out of an
 array?
Date: Thu, 13 Feb 2014 18:25:59 +0100 (CET)
Message-ID: <alpine.DEB.2.02.1402131822190.24915@uplift.swm.pp.se>
References: <1413719638.30344.1392138285471.JavaMail.zimbra@xes-inc.com> <1090802800.32078.1392138664718.JavaMail.zimbra@xes-inc.com> <20140212065420.4643f9a1@notabene.brown> <700319865.79921.1392160257000.JavaMail.zimbra@xes-inc.com> <52FABC1A.1010804@hardwarefreak.com>
 <1113712961.13129.1392216288183.JavaMail.zimbra@xes-inc.com> <52FC8250.4080903@hardwarefreak.com> <669652530.12040.1392303427052.JavaMail.zimbra@xes-inc.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <669652530.12040.1392303427052.JavaMail.zimbra@xes-inc.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Martin <amartin@xes-inc.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 13 Feb 2014, Andrew Martin wrote:

> Note that I added a new, replacement drive to the array at 17:09. In 
> lieu of Marvel SAS cards, what would you recommend?

LSI 2008 is very well tested HBA controller, it exists in many vendors' 
cards. Works properly with 4TB drives (and larger I presume). For instance 
the LSI SAS 9211-8i HBA has this chip.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
