From: Franc Carter <franc@tech.sirca.org.au>
Subject: Re: How safe is software RAID compared to how safe hardware RAID is!?
Date: Wed, 19 Nov 2003 10:51:48 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200311191051.48540.franc@tech.sirca.org.au>
References: <16314.40792.616508.878124@notabene.cse.unsw.edu.au> <PPEOJEIEFLAONFNHJPOOAEICGOAA.jim@jimtreats.com> <16314.44161.438158.27514@notabene.cse.unsw.edu.au>
Reply-To: Franc Carter <franc@tech.sirca.org.au>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16314.44161.438158.27514@notabene.cse.unsw.edu.au>
Content-Disposition: inline
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Excellent, answer - I'm going to 'lift' your concept of 'you are part
of the sytem', it describes the situation vary nicely.

cheers

On Wed, 19 Nov 2003 10:34 am, Neil Brown wrote:
> On Tuesday November 18, jim@jimtreats.com wrote:
> > Hi folks..
> > 
> > hopefully everything will be working soon and i can get on with trying to
> > get some backup scripts working :)
> > 
> > I am going to stick with this software RAID for the near future if it
> > carries on working correctly.. I was just wondering what peoples views 
were
> > of software vs hardware raid... anything and everything really.. I'm not
> > that up on all the technology... I know that 3ware have a good rep in
> > hardware... I also imagine that for more exotic RAID configurations its
> > obviously a help to not stress the CPU with the RAID tasks.. for me tho 
with
> > simple mirroring the CPU costs are minimal.. the linux core is a sturdy 
base
> > to build upon so is software raid in this way a perfectly acceptible
> > reliable RAID solution..
> > 
> > Just curious..
> 
> Not an easy question to answer.
> RAID is all about surviving failures, and there are alots of possible
> failure modes, some more predictable than others.
> 
> The obvious failure modes are handled perfectly well by all solutions.
> 
> The less obvious failure modes are probably handled as best as
> possible by all solutions, but with these, the question is usually
> "how can I recover", and the answer there depends on how much support
> you can get, and how much you can work out yourself.
> 
> For support: linux-raid is an adequate support community, but there is
> no guarantee of instant support.  I don't know what support there
> might be around various hardware raid solution.  Again, someone on
> linux-raid might be able to help, or they might not.
> 
> For "how much you can work out yourself", that depends partly on you.
> Your hardware raid might come with good doco, or it might not.
> Software RAID somes with assorted bits of doco, and complete source.
> 
> You are part of your system, and system reliability depends in-part of
> how much you know.  With software raid you can learn as much as you
> want to, but it might require more work that you care to put it.
> 
> Software raid can be affected by lots of parts of the system.
> Reliability of hardware raid is more tightly connected to the
> controller and drives.
> 
> As examples of "less obvious failure modes":
> 
>  I had a mirrored pair that kept getting data corruption.  It turned
>  out that one of the drives had a bad bit in an internal buffer, and
>  would occasionally return 1 for the 12th bit (or similar) of each
>  sector even when it should be zero.   Neither software raid or
>  hardware raid would cope with that.
> 
>  Some people find that their IDE controller works fine until they try
>  to use RAID1.  RAID1 hits multiple discs concurrently a lot, and some
>  (few, specific) ide controllers don't appear to cope.  You probably
>  would not get that with hardware raid.  You can with software raid
>  because it is a "whole-system" thing.
> 
> 
> I prefer software raid because I like the fact that I can see inside
> and understand it completely.  Some people like hardware raid because
> "it just works".
> Both are valid perspectives and as you, the sys-admin, are part of
> the system, your prespective and opinion is a significant part of what
> makes the system "reliable".
> 
> NeilBrown
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

