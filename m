From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: why the kernel and mdadm report differently
Date: Tue, 6 Sep 2005 11:16:56 +1000
Message-ID: <17180.60936.671491.203659@cse.unsw.edu.au>
References: <431C0968.10301@bppiac.hu>
	<17180.3031.193961.445535@cse.unsw.edu.au>
	<431C30E3.2040404@bppiac.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Farkas Levente on Monday September 5
Sender: linux-raid-owner@vger.kernel.org
To: Farkas Levente <lfarkas@bppiac.hu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday September 5, lfarkas@bppiac.hu wrote:
> Neil Brown wrote:
> > On Monday September 5, lfarkas@bppiac.hu wrote:
> > 
> >>hi,
> >>one of our raid array is crash all the time (once a week), 
> > 
> > 
> > Any kernel error messages?
> 
> i already send report about this a few times to this list without any 
> response, but i send you a private message will all logs.

Yes, so you had, I must has missed them, sorry.

It isn't clear exactly what the problem is from the information you
were able to provide.
There was one bug in raid5 that was hitting you that has been fixed
since 2.9.6, but I don't think it was the main part of your problem.
I'm a bit suspicious of the low-level driver - is it SCSI or SATA?

In any case, I strongly suggest trying 2.6.13 and seeing if that
helps.

NeilBrown
