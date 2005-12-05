From: Neil Brown <neilb@suse.de>
Subject: Re: RAID5 problem
Date: Mon, 5 Dec 2005 13:44:17 +1100
Message-ID: <17299.43393.992231.121500@cse.unsw.edu.au>
References: <4392FB7C.6080600@gmx.de>
	<17299.25606.806494.749914@cse.unsw.edu.au>
	<20051205014408.GA20602@jose.lug.udel.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Ross Vandegrift on Sunday December 4
Sender: linux-raid-owner@vger.kernel.org
To: Ross Vandegrift <ross@jose.lug.udel.edu>
Cc: Alfons Andorfer <a_a@gmx.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday December 4, ross@jose.lug.udel.edu wrote:
> 
> Neil - did you get a chance to look at the syslog and text
> messaging patches I posted?
> 

Didn't I reply to those?... No, I guess I didn't.  Thanks for the
reminder.

The text-messaging I don't like.  That is what the --program option if
for.  If you don't want the very-basic email message, then write
yourself a little script to do exactly what you want.

The 'syslog' stuff looks fine : -y and --syslog.... though I wander if
--syslog should be the default...

I wish I could remember why I didn't do this at the start!  I have a
strong feeling that it was more than just laziness, but I cannot
remember what more :-(

Oh well... expect to see you syslog support in 2.2.

Thanks,
NeilBrown
