From: Wakko Warner <wakko@animx.eu.org>
Subject: Re: limits on raid
Date: Mon, 18 Jun 2007 17:46:33 -0400
Message-ID: <20070618214633.GA15468@animx.eu.org>
References: <18035.23867.576212.859440@notabene.brown> <Pine.LNX.4.64.0706160037220.7557@asgard.lang.hm> <4676BEC2.7090809@redhat.com> <Pine.LNX.4.64.0706181026170.12717@asgard.lang.hm> <20070618180327.GP10008@csclub.uwaterloo.ca> <Pine.LNX.4.64.0706181111020.12717@asgard.lang.hm> <20070618183324.GL10006@csclub.uwaterloo.ca> <Pine.LNX.4.64.0706181138210.12717@asgard.lang.hm> <4676D8DE.3050903@redhat.com> <Pine.LNX.4.64.0706181349290.14890@asgard.lang.hm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706181349290.14890@asgard.lang.hm>
Sender: linux-raid-owner@vger.kernel.org
To: david@lang.hm
Cc: Brendan Conoboy <blc@redhat.com>, Lennart Sorensen <lsorense@csclub.uwaterloo.ca>, Neil Brown <neilb@suse.de>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

david@lang.hm wrote:
> On Mon, 18 Jun 2007, Brendan Conoboy wrote:
> 
> >david@lang.hm wrote:
> >> yes, sorry, ultra 320 wide.
> >
> >Exactly how many channels and drives?
> 
> one channel, 2 OS drives plus the 45 drives in the array.

Given that the drives only have 4 ID bits, how can you have 47 drives on 1
cable?  You'd need a minimum of 3 channels for 47 drives.  Do you have some
sort of external box that holds X number of drives and only uses a single
ID?

-- 
 Lab tests show that use of micro$oft causes cancer in lab animals
 Got Gas???
