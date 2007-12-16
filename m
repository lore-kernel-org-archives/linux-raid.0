From: Janek Kozicki <janek_listy@wp.pl>
Subject: Re: raid5 reshape/resync
Date: Sun, 16 Dec 2007 14:16:45 +0100
Message-ID: <20071216141645.6a766a85@absurd>
References: <20071124120209.0t70rfkfswkcww0g@cakebox.homeunix.net>
	<20071125200431.2wbk051yoso4owsk@cakebox.homeunix.net>
	<18254.21183.807123.642613@notabene.brown>
	<20071201154817.5uwtck6ask0ksw8s@cakebox.homeunix.net>
	<20071211225613.5tybri2ickcgk0s4@cakebox.homeunix.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20071211225613.5tybri2ickcgk0s4@cakebox.homeunix.net>
Sender: linux-raid-owner@vger.kernel.org
To: Nagilum <nagilum@nagilum.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Nagilum said:     (by the date of Tue, 11 Dec 2007 22:56:13 +0100)

> Ok, I've recreated the problem in form of a semiautomatic testcase.
> All necessary files (plus the old xfs_repair output) are at:
>   http://www.nagilum.de/md/

> After running the test.sh the created xfs filesystem on the raid  
> device is broken and (at last in my case) cannot be mounted anymore.

I think that you should file a bugreport, and provide there the
explanations you have put in there. An automated test case that leads
to xfs corruption is a neat snack for bug squashers ;-)

I wonder however where to report this - the xfs or raid ? Eventually
cross report to both places and write in the bugreport that you are
not sure on which side there is a bug.

best regards
-- 
Janek Kozicki                                                         |
