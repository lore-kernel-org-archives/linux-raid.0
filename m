From: Neil Brown <neilb@suse.de>
Subject: Re: Wierd critical node problem
Date: Thu, 19 Jun 2008 15:07:35 +1000
Message-ID: <18521.59799.628735.193839@notabene.brown>
References: <200806100924.48763.wayne@flashmedia.co.za>
	<200806101030.09019.wayne@flashmedia.co.za>
	<42492.192.168.1.70.1213092370.squirrel@neil.brown.name>
	<200806101235.00027.wayne@flashmedia.co.za>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Wayne Gemmell on Tuesday June 10
Sender: linux-raid-owner@vger.kernel.org
To: wayne@flashmedia.co.za
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday June 10, wayne@flashmedia.co.za wrote:
> >
> > > I have found the following in my logs,
> > > Jun  9 17:01:50 lloyd kernel: [   52.912904] mdadm[2656]: segfault at
> > > 0000000000000004 rip 000000000041724c rsp 00007ffff99d9b30 error 4
> >
> > I suspect this is the real problem.
> > Which version of mdadm (mdadm -V)?
> mdadm - v2.6.2 - 21st May 2007
> 

I don't know of any segfault problems with this version.  It might be
worth trying a newer release:  2.6.4 or 2.6.7.

If you are still having problems, can you get the exact text of the
error messages, they might show something useful.

NeilBrown
