From: Neil Brown <neilb@suse.de>
Subject: Re: Accidental grow before add
Date: Tue, 5 Oct 2010 16:18:03 +1100
Message-ID: <20101005161803.0ddc874b@notabene>
References: <AANLkTi=PydpqTR1x=KTfW16en3U3+KxoLV85iWpWtRC9@mail.gmail.com>
	<193703.58642.qm@web51305.mail.re2.yahoo.com>
	<AANLkTimWyuvf1_9H8QhLXQ5gYRya1ux6WFGS4EPWP5_U@mail.gmail.com>
	<20100928171451.27293d0o1kotcfi8@cakebox.homeunix.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100928171451.27293d0o1kotcfi8@cakebox.homeunix.net>
Sender: linux-raid-owner@vger.kernel.org
To: Nagilum <nagilum@nagilum.org>
Cc: Mike Hartman <mike@hartmanipulation.com>, Jon@ehardcastle.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 28 Sep 2010 17:14:51 +0200
Nagilum <nagilum@nagilum.org> wrote:

> 
> ----- Message from mike@hartmanipulation.com ---------
> 
> >> I am more interested to know why it kicked off a reshape that would  
> >> leave the array in a degraded state without a warning and
> >> needing a '--force' are you sure there wasn't capacity to 'grow' anyway?
> >
> > Positive. I had no spare of any kind and mdstat was showing all disks
> > were in use.
> 
> Yep, a warning/safety net would be good. At the moment mdadm assumes  
> you know what you're doing.
> 

I've added this to my list of possible enhancements for mdadm-3.2

Thanks,
NeilBrown
