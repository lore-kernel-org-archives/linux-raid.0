From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: Reshaping raid0/10
Date: Sat, 10 Mar 2007 22:19:00 +0100 (MET)
Message-ID: <Pine.LNX.4.61.0703102218150.26332@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0702211726500.12039@yvahk01.tjqt.qr>
 <17884.42154.248251.261955@notabene.brown> <Pine.LNX.4.61.0702231357420.9736@yvahk01.tjqt.qr>
 <17887.19400.179239.281711@notabene.brown> <45F3134C.7070500@zytor.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <45F3134C.7070500@zytor.com>
Sender: linux-raid-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Mar 10 2007 12:21, H. Peter Anvin wrote:
> Neil Brown wrote:
>> 
>> If I wanted to reshape a raid0, I would just morph it into a raid4
>> with a missing parity drive, then use the raid5 code to restripe it.
>> Then morph it back to regular raid0.
>
> Wow, that made my brain hurt.
>
> Given the fact that we're going to have to do this on kernel.org soon, what
> would be the concrete steps involved (we're going to have to change 3-member
> raid0 into 4-member raid0)...

Iff it was in the kernel, mdadm -G would suffice.


Jan
-- 
