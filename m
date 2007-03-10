From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Reshaping raid0/10
Date: Sat, 10 Mar 2007 12:21:32 -0800
Message-ID: <45F3134C.7070500@zytor.com>
References: <Pine.LNX.4.61.0702211726500.12039@yvahk01.tjqt.qr>	<17884.42154.248251.261955@notabene.brown>	<Pine.LNX.4.61.0702231357420.9736@yvahk01.tjqt.qr> <17887.19400.179239.281711@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17887.19400.179239.281711@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> 
> If I wanted to reshape a raid0, I would just morph it into a raid4
> with a missing parity drive, then use the raid5 code to restripe it.
> Then morph it back to regular raid0.
> 

Wow, that made my brain hurt.

Given the fact that we're going to have to do this on kernel.org soon, 
what would be the concrete steps involved (we're going to have to change 
3-member raid0 into 4-member raid0)...

	-hpa
