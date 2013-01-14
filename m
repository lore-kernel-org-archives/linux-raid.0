From: Chris Murphy <lists@colorremedies.com>
Subject: Re: recommended way to add ssd cache to mdraid array
Date: Mon, 14 Jan 2013 15:51:20 -0700
Message-ID: <95B458E1-8825-44D1-BCD5-1796A1E69FAE@colorremedies.com>
References: <201212212357.19292.thomas@fjellstrom.ca> <201301141122.15322.thomas@fjellstrom.ca> <50F46075.2090903@hardwarefreak.com> <201301141453.13819.thomas@fjellstrom.ca>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201301141453.13819.thomas@fjellstrom.ca>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid Raid <linux-raid@vger.kernel.org>, Thomas Fjellstrom <thomas@fjellstrom.ca>
Cc: "stan@hardwarefreak.com Hoeppner" <stan@hardwarefreak.com>, Tommy Apel Hansen <tommyapeldk@gmail.com>
List-Id: linux-raid.ids


On Jan 14, 2013, at 2:53 PM, Thomas Fjellstrom <thomas@fjellstrom.ca> wrote:

>                                                            random  random    bkwd   record   stride                                   
>              KB  reclen   write rewrite    read    reread    read   write    read  rewrite     read   fwrite frewrite   fread  freread
>        33554432    8192  124664  121973   524509   527971  376880  104357  336083    40088   392683   213941   215453  631122   631617
> 
> I assume that is to you liking?

No it's getting hosed for me too, I think it's just too wide for the forum. Pastebin it. And I suggest you post the one that has the variable reclen not just the 8MB result.

And also, now I'm confused because the above reclen8192 result doesn't match with the one you posted from before, so I'm goingn to guess this is the one with -I. My suggestion is that you put into the pastebin the command you used to arrive at the results. Both are important.

> p.s. I am seriously tempted to play your little flame game,
> but It's not worth the time.

Don't say that or people won't help. If it's your first day at the rodeo taking a bit of a beating and you announce it's not worth it, most people will agree with you and stop playing.

Chris Murphy