From: Franc Carter <franc@tech.sirca.org.au>
Subject: Re: multipath - stable ?
Date: Sat, 13 Dec 2003 10:35:43 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200312131035.43175.franc@tech.sirca.org.au>
References: <200312121552.02975.franc@tech.sirca.org.au> <1071250518.13240.32.camel@persist.az.mvista.com>
Reply-To: Franc Carter <franc@tech.sirca.org.au>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1071250518.13240.32.camel@persist.az.mvista.com>
Content-Disposition: inline
To: sdake@mvista.com
Cc: Linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


Thanks, 

can you give me a ballpark on 'high' >5 minutes ?

cheers

On Sat, 13 Dec 2003 04:35 am, Steven Dake wrote:
> The multipath code is simple and seems pretty stable to me.
> 
> There is one issue, in that failover can sometimes take a long time
> because of the SCSI layer's insistence upon executing error recovery. 
> In the case of multipath I/O's, there is no need to error recover before
> processing the I/O.  Instead, once error is detected, failover, then
> start error recovery.
> 
> The SCSI layer doesn't do this currently, so failover times are high.
> 
> Thanks
> -steve
> 
> 
> On Thu, 2003-12-11 at 21:52, Franc Carter wrote:
> > Hi,
> > 
> > I've been using linux sofwtare raid for years and had no problems.
> > We are about to install some disk systems that have dual contollers
> > and am wondering wether multipath is as stable as the rest of software
> > raid ?
> > 
> > thanks
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

-- 
Franc Carter     Ph:61-2-8374-5071      Fax: 61-2-8374-5070
Systems Manager, SIRCA Ltd              http://www.sirca.org.au/

DISCLAIMER: The contents of this email, inclusive of attachments, may
be legally privileged and confidential. Any unauthorised use of the
contents is expressly prohibited. If you have received this message in
error or are not the intended recipient, you should destroy the email
message along with any attachment(s).  Unintended recipients of this
email are prohibited from retaining, disclosing, distributing or using
any information contained herein.  This email is also subject to
copyright. No part of it should be reproduced, adapted or transmitted
without the written consent of the copyright owner.

