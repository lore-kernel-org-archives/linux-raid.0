From: Ming Zhang <mingz@ele.uri.edu>
Subject: Re: RAID-5 streaming read performance
Date: Fri, 15 Jul 2005 08:29:43 -0400
Message-ID: <1121430583.5548.11.camel@localhost.localdomain>
References: <874qb14btr.fsf@uwo.ca>
	 <1121220487.5552.34.camel@localhost.localdomain> <87mzorfmdx.fsf@uwo.ca>
	 <1121257494.5504.4.camel@localhost.localdomain> <87eka2g9dp.fsf@uwo.ca>
	 <1121259126.5504.14.camel@localhost.localdomain> <87vf3eeqe2.fsf@uwo.ca>
	 <42D5573A.6090801@dgreaves.com> <87r7e23uo5.fsf@uwo.ca>
	 <87wtns7pzc.fsf@uwo.ca>
	 <Pine.LNX.4.61.0507150558330.10696@praktifix.dwd.de>
Reply-To: mingz@ele.uri.edu
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0507150558330.10696@praktifix.dwd.de>
Sender: linux-raid-owner@vger.kernel.org
To: Holger Kiehl <Holger.Kiehl@dwd.de>
Cc: Dan Christensen <jdc@uwo.ca>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

in my previous test, using SATA, i got better result in 2.6 instead of
2.4. :P

Ming

On Fri, 2005-07-15 at 06:01 +0000, Holger Kiehl wrote:
> > I'm trying to figure out why the last two numbers differ.
> >
> Have you checked what the performance with a 2.4.x kernel is? If I
> remember correctly there was some discussion on this list that 2.4
> raid5
> has better read performance.
> 
> Holger
> 

