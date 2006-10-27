From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Question of PCI bandwidth affect on SW RAID arrays.
Date: Fri, 27 Oct 2006 17:43:08 -0400
Message-ID: <45427D6C.7030909@tmr.com>
References: <Pine.LNX.4.64.0610260612270.24154@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0610260612270.24154@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Justin Piszcz wrote:

>Quick question,
>
>On older systems, regular PCI motherboards, no PCI-e-- which is faster?
>
>1) One 4 port SATA150 card in 1 PCI slot which has 4 drives connected.
>2) Four SATA150 cards in 4 PCI slots, which each have 1 drive connected?
>
>I'd assume 2 would stress the PCI bus more and thus would be slower, but I 
>am curious what other people know/think/etc?
>
You are sending the same amount of data over the bus in either case, 
assuming you are using s/w RAID. This is where (real) hardware RAID has 
an advantage in performance, the parity doesn't go over the bus. If you 
have a server board it may have multiple PCI busses, and therefore a 
higher max bandwidth with multiple cards. I would still expect PCI-e to 
be faster.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

