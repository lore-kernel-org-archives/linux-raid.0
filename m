From: carlos@fisica.ufpr.br (Carlos Carvalho)
Subject: Re: How to un-degrade an array after a totally spurious failure?
Date: Mon, 8 Jun 2009 10:12:26 -0300
Message-ID: <18989.3642.996238.323569@fisica.ufpr.br>
References: <18988.28487.697258.566987@fisica.ufpr.br>
	<20090608015637783.ESCT2045@cdptpa-omta01.mail.rr.com>
	<20090608075136.GA3000@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090608075136.GA3000@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

 >On Sun Jun 07, 2009 at 08:56:42PM -0500, Leslie Rhorer wrote:
 >
 >> > -----Original Message-----
 >> > From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
 >> > owner@vger.kernel.org] On Behalf Of Carlos Carvalho
 >> > Sent: Sunday, June 07, 2009 8:54 PM
 >> > To: linux-raid@vger.kernel.org
 >> > Subject: RE: How to un-degrade an array after a totally spurious failure?
 >> > 
 >> > Leslie Rhorer (lrhorer@satx.rr.com) wrote on 7 June 2009 20:43:
 >> >  >OK, what about a RAID 6 array with one failed disk?  Is the remove & add
 >> >  >the best option there, or should one apply a different method?
 >> > 
 >> > It is, since that's what the raid is for. It's still operational.
 >> > We've done it here and it works.
 >> 
 >> Well, yes, I know it should work.  The question is, "Is it the best method?"

I don't understand what you mean. It is the only method. Everything
should be perfectly fine because of the redundancy. You only have to
do tricks when you have more failed disks than the array supports,
which always involves a certain risk.
