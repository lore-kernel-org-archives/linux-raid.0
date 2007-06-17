From: dean gaudet <dean@arctic.org>
Subject: Re: limits on raid
Date: Sat, 16 Jun 2007 18:44:14 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0706161837490.24938@twinlark.arctic.org>
References: <Pine.LNX.4.64.0706141957020.29630@asgard.lang.hm>
 <18034.479.256870.600360@notabene.brown> <Pine.LNX.4.64.0706142034400.29630@asgard.lang.hm>
 <18034.3676.477575.490448@notabene.brown> <20070616020320.GB2002@animx.eu.org>
 <18035.23867.576212.859440@notabene.brown> <4673E69A.4020309@dgreaves.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1759064AbXFQBoZ@vger.kernel.org>
In-Reply-To: <4673E69A.4020309@dgreaves.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: Neil Brown <neilb@suse.de>, Wakko Warner <wakko@animx.eu.org>, david@lang.hm, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 16 Jun 2007, David Greaves wrote:

> Neil Brown wrote:
> > On Friday June 15, wakko@animx.eu.org wrote:
> >  
> > >                                                   As I understand the way
> > > raid works, when you write a block to the array, it will have to read all
> > > the other blocks in the stripe and recalculate the parity and write it
> > > out.
> > 
> > Your understanding is incomplete.
> 
> Does this help?
> [for future reference so you can paste a url and save the typing for code :) ]
> 
> http://linux-raid.osdl.org/index.php/Initial_Array_Creation

i fixed a typo and added one more note which i think is quite fair:

	It is also safe to use --assume-clean if you are performing
	performance measurements of different raid configurations. Just
	be sure to rebuild your array without --assume-clean when you
	decide on your final configuration.

-dean
