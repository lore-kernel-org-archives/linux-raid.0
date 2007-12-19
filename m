From: Janek Kozicki <janek_listy@wp.pl>
Subject: Re: raid5 reshape/resync - BUGREPORT
Date: Wed, 19 Dec 2007 05:50:27 +0100
Message-ID: <20071219055027.2407442f@absurd>
References: <20071124120209.0t70rfkfswkcww0g@cakebox.homeunix.net>
	<20071125200431.2wbk051yoso4owsk@cakebox.homeunix.net>
	<18254.21183.807123.642613@notabene.brown>
	<20071201154817.5uwtck6ask0ksw8s@cakebox.homeunix.net>
	<20071211225613.5tybri2ickcgk0s4@cakebox.homeunix.net>
	<20071216141645.6a766a85@absurd>
	<20071218110938.0gh9rkr2xc84cscs@cakebox.homeunix.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20071218110938.0gh9rkr2xc84cscs@cakebox.homeunix.net>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

> ----- Message from janek_listy@wp.pl ---------
Nagilum said:     (by the date of Tue, 18 Dec 2007 11:09:38 +0100)

> >> Ok, I've recreated the problem in form of a semiautomatic testcase.
> >> All necessary files (plus the old xfs_repair output) are at:
> >>
> >>   http://www.nagilum.de/md/
> >
> >> After running the test.sh the created xfs filesystem on the raid
> >> device is broken and (at last in my case) cannot be mounted anymore.
> >
> > I think that you should file a bugreport

> ----- End message from janek_listy@wp.pl -----
> 
> Where would I file this bug report? I thought this is the place?
> I could also really use a way to fix that corruption. :(

ouch. To be honest I subscribed here just a month ago, so I'm not
sure. But I haven't seen other bugreports here so far. 

I was expecting that there is some bugzilla?

-- 
Janek Kozicki                                                         |
