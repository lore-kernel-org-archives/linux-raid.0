From: Andrew Martin <amartin@xes-inc.com>
Subject: Re: Automatically drop caches after mdadm fails a drive out of an
 array?
Date: Fri, 14 Feb 2014 16:40:37 -0600 (CST)
Message-ID: <518410588.65674.1392417637212.JavaMail.zimbra@xes-inc.com>
References: <1413719638.30344.1392138285471.JavaMail.zimbra@xes-inc.com> <700319865.79921.1392160257000.JavaMail.zimbra@xes-inc.com> <52FABC1A.1010804@hardwarefreak.com> <1113712961.13129.1392216288183.JavaMail.zimbra@xes-inc.com> <52FC8250.4080903@hardwarefreak.com> <669652530.12040.1392303427052.JavaMail.zimbra@xes-inc.com> <alpine.DEB.2.02.1402131822190.24915@uplift.swm.pp.se> <52FDA12E.2070502@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52FDA12E.2070502@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: Mikael Abrahamsson <swmike@swm.pp.se>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

----- Original Message -----
> From: "Stan Hoeppner" <stan@hardwarefreak.com>
> To: "Mikael Abrahamsson" <swmike@swm.pp.se>, "Andrew Martin" <amartin@xes-inc.com>
> Cc: linux-raid@vger.kernel.org
> Sent: Thursday, February 13, 2014 10:53:02 PM
> Subject: Re: Automatically drop caches after mdadm fails a drive out of an array?
> 
> On 2/13/2014 11:25 AM, Mikael Abrahamsson wrote:
> > On Thu, 13 Feb 2014, Andrew Martin wrote:
> > 
> >> Note that I added a new, replacement drive to the array at 17:09. In
> >> lieu of Marvel SAS cards, what would you recommend?
> > 
> > LSI 2008 is very well tested HBA controller, it exists in many vendors'
> > cards. Works properly with 4TB drives (and larger I presume). For
> > instance the LSI SAS 9211-8i HBA has this chip.
> 
> Agreed, LSI based HBAs are all pretty reliable.  These chips can be
> found on motherboards, LSI branded HBAs, as well as IBM, Intel, and
> other branded HBAs.  The multi-lane Adaptecs are good as well.
> 
> Honestly, I've only really heard of serious problems with the mvsas
> driver and the Marvell SAS 88SE64xx based HBAs, most often the
> Supermicro, but also the Highpoint 2600 family.  There may be others.
> 

Thanks for the help!

Andrew
