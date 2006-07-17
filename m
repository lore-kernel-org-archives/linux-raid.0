From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: second controller: what will my discs be called, and does it
 matter?
Date: Mon, 17 Jul 2006 14:28:06 -0400
Message-ID: <44BBD6B6.6080602@tmr.com>
References: <200607062012.14684.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200607062012.14684.Dexter.Filmore@gmx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Dexter Filmore <Dexter.Filmore@gmx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dexter Filmore wrote:

>Currently I have 4 discs on a 4 channel sata controller which does its job 
>quite well for 20 bucks. 
>Now, if I wanted to grow the array I'd probably go for another one of these.
>
>How can I tell if the discs on the new controller will become sd[e-h] or if 
>they'll be the new a-d and push the existing ones back?
>  
>
For software RAID you shouldn't care, for other things you might.

>Next question: assembling by UUID, does that matter at all?
>  
>
No. There's the beauty of it.

>(And while talking UUID - can I safely migrate to a udev-kernel? Someone on 
>this list recently ran into trouble because of such an issue.)
>
You shouldn't lose data unless you panic at the first learning 
experience and do something without thinking of the results. I would 
convert to UUID first, obviously.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

