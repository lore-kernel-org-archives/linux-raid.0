From: Roberto Nunnari <roberto.nunnari@supsi.ch>
Subject: Re: replacing drives
Date: Tue, 30 Apr 2013 17:10:28 +0200
Message-ID: <517FDEE4.8040605@supsi.ch>
References: <517A8EB5.8080100@supsi.ch> <20130426155347.GA9928@cthulhu.home.robinhill.me.uk> <517FC46A.1080702@supsi.ch> <alpine.DEB.2.00.1304301519350.26743@uplift.swm.pp.se> <517FD7BE.8040401@supsi.ch> <alpine.DEB.2.00.1304301640490.2118@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1304301640490.2118@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Mikael Abrahamsson wrote:
> On Tue, 30 Apr 2013, Roberto Nunnari wrote:
> 
>> what the... these are SECONDS! What on earth could delay a sata 
>> attached disk read for 30 (now 180) seconds if not a disk failure? I 
>> OS hang? Sorry about that question, but I don't understand.. I have 
>> never seen such a problem.
> 
> A consumer drive will spend considerable time trying to read a sector 
> before giving up. I believe 120 seconds is not uncommon.
> 
> The raid drives will typically give up after 7 seconds.
> 
> http://en.wikipedia.org/wiki/Time-Limited_Error_Recovery

ok.. thank you for the explanation. Now I got it. :-)

Robi
