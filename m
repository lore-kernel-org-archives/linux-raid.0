From: Neil Brown <neilb@suse.de>
Subject: Re: RAID5 recovery trouble, bd_claim failed?
Date: Tue, 18 Apr 2006 10:24:56 +1000
Message-ID: <17476.12760.843811.483031@cse.unsw.edu.au>
References: <1145106091.18173.18.camel@nemo.qabal.org>
	<17474.51499.479497.322081@cse.unsw.edu.au>
	<1145242458.18173.49.camel@nemo.qabal.org>
	<17475.1455.344850.506978@cse.unsw.edu.au>
	<1145268508.18173.61.camel@nemo.qabal.org>
	<17475.28176.159396.519547@cse.unsw.edu.au>
	<444386C6.2070201@qabal.org>
	<4443EC9E.9010502@qabal.org>
	<17476.3083.900753.898632@cse.unsw.edu.au>
	<1145312490.9148.0.camel@nemo.qabal.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Nathanial Byrnes on Monday April 17
Sender: linux-raid-owner@vger.kernel.org
To: Nathanial Byrnes <nate@qabal.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday April 17, nate@qabal.org wrote:
> Unfortunately nothing changed. 

Weird... so hdf still reports as 'busy'?
Is it mentioned anywhere in /var/log/messages since reboot?

What version of mdadm are you using?  Try 2.4.1 and see if that works
differently.

NeilBrown

> 
> 
> On Tue, 2006-04-18 at 07:43 +1000, Neil Brown wrote:
> > On Monday April 17, nate@qabal.org wrote:
> > > Hi Neil, List,
> > >     Am I just out of luck? Perhaps a full reboot? Something else?
> > >     Thanks,
> > >     Nate
> > 
> > Reboot and try again seems like the best bet at this stage.
> > 
> > NeilBrown
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> > !DSPAM:44440c1a90901937570534!
> > 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
