From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Reshaping raid0/10
Date: Mon, 28 May 2007 21:51:16 -0700
Message-ID: <465BB144.2060003@zytor.com>
References: <Pine.LNX.4.61.0702211726500.12039@yvahk01.tjqt.qr>	<17884.42154.248251.261955@notabene.brown>	<Pine.LNX.4.61.0702231357420.9736@yvahk01.tjqt.qr>	<17887.19400.179239.281711@notabene.brown>	<45F3134C.7070500@zytor.com> <17908.33911.135761.236374@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17908.33911.135761.236374@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Back in March, Neil Brown wrote:
> 
> Well.... it's not straight forward at all.
> 
> Firstly: it can only work if all your drives are the same size
> (rounded to 64K).  If they aren't raid0 will use all the available
> space on each drive, while raid5 will only use the amount that is
> available on the first drive.
> 
> If that condition is met, then you can safely convert to a raid4 with
> one extra (missing) device by simply creating an array with the same
> drives (so you have to stop and restart the array - you cannot do that
> bit while the array is live).  You seem to need --assume-clean
> to create the raid4 degraded... That is probably a bug in mdadm.
> 

[rest of procedure deleted]

I just wanted to let you know we performed this procedure on
mirrors1.kernel.org.  It was successful, and saved us from copying 3 TB
of data across the Internet.

	-hpa
