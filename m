From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: which CPU for XOR?
Date: Tue, 13 Jun 2006 14:40:50 -0400
Message-ID: <448F06B2.6000802@tmr.com>
References: <200606091349.24109.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200606091349.24109.Dexter.Filmore@gmx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Dexter Filmore <Dexter.Filmore@gmx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dexter Filmore wrote:

>What type of operation is XOR anyway? Should be ALU, right?
>So - what CPU is best for software raid? One with high integer processing 
>power? 
>
Unless you're running really low on CPU, it probably doesn't matter... 
you run out of memory bandwidth on large data (larger than cache) 
anyway. That's my take on it.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

