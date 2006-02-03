From: Bill Davidsen <tmrbill@tmr.com>
Subject: Re: RAID 16?
Date: Thu, 2 Feb 2006 21:54:59 -0500 (EST)
Message-ID: <Pine.LNX.4.44.0602022152320.12829-100000@firewall2.tmr.com>
References: <43E27716.10506@dynaconnections.com>
Reply-To: davidsen@tmr.com
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43E27716.10506@dynaconnections.com>
Sender: linux-raid-owner@vger.kernel.org
To: "J. Ryan Earl" <ryan@dynaconnections.com>
Cc: Gordon Henderson <gordon@drogon.net>, Mattias Wadenstein <maswan@acc.umu.se>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 2 Feb 2006, J. Ryan Earl wrote:

>      
> X-UID: 40928
> 
> Gordon Henderson wrote:
> 
> >I've actually had very good results hot swapping  SCSI drives on a live
> >linux system though.
> >
> >Anyone tried SATA drives yet?
> >
> Yes, and it does NOT work yet.  libata does not support hotplugging of 
> harddrives yet: http://linux.yyz.us/sata/features.html 
> 
> It supports hotplugging of the PCI controller itself, but not harddrives.

I can add controllers but no devices? I have to think the norm is exactly 
the opposite... One of the SATA controllers with the plugs on the back for 
your little external box.

A work in progress, I realize.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
Doing interesting things with little computers since 1979

