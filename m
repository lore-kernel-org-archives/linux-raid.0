From: Mads Peter Bach <mpb@hum.auc.dk>
Subject: Re: Perhaps this has been answered before...
Date: Wed, 21 Aug 2002 20:16:28 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3D63D8FC.8020408@hum.auc.dk>
References: <Pine.OSF.4.30.0208212024340.15250-100000@soul.helsinki.fi> 	<3D63D0BD.50005@hum.auc.dk> <1029953242.31114.76.camel@zimmerman>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Chris Zimmerman wrote:

> So where can I get the appropriate kernel patches for 2.4 and will I
> have to update raidtools? 


No patches needed! Just install a bog-standard 2.4, and compile in 
support for raid.

You shouldn't need to update raidtools, but you may want to look at 
mdadm (http://www.cse.unsw.edu.au/~neilb/source/mdadm/) instead. It is 
superior to raidtools, IMHO.

Regards,
Mads

