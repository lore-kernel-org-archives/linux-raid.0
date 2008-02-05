From: Neil Brown <neilb@suse.de>
Subject: Re: when is a disk "non-fresh"?
Date: Tue, 5 Feb 2008 13:02:00 +1100
Message-ID: <18343.50072.164266.861934@notabene.brown>
References: <200802030354.33435.Dexter.Filmore@gmx.de>
	<200802042305.11860.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Dexter Filmore on Monday February 4
Sender: linux-raid-owner@vger.kernel.org
To: Dexter Filmore <Dexter.Filmore@gmx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday February 4, Dexter.Filmore@gmx.de wrote:
> Seems the other topic wasn't quite clear...

not necessarily.  sometimes it helps to repeat your question.  there
is a lot of noise on the internet and somethings important things get
missed... :-)

> Occasionally a disk is kicked for being "non-fresh" - what does this mean and 
> what causes it?

The 'event' count is too small.  
Every event that happens on an array causes the event count to be
incremented.
If the event counts on different devices differ by more than 1, then
the smaller number is 'non-fresh'.

You need to look to the kernel logs of when the array was previously
shut down to figure out why it is now non-fresh.

NeilBrown


> 
> Dex
> 
> 
> 
> -- 
> -----BEGIN GEEK CODE BLOCK-----
> Version: 3.12
> GCS d--(+)@ s-:+ a- C++++ UL++ P+>++ L+++>++++ E-- W++ N o? K-
> w--(---) !O M+ V- PS+ PE Y++ PGP t++(---)@ 5 X+(++) R+(++) tv--(+)@ 
> b++(+++) DI+++ D- G++ e* h>++ r* y?
> ------END GEEK CODE BLOCK------
> 
> http://www.vorratsdatenspeicherung.de
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
