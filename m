From: linux@horizon.com
Subject: Re: Interesting RAID checking observations
Date: 4 Sep 2006 17:15:01 -0400
Message-ID: <20060904211501.26766.qmail@science.horizon.com>
References: <44FC5F55.6000008@tmr.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44FC5F55.6000008@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: davidsen@tmr.com
Cc: linux-raid@vger.kernel.org, linux@horizon.com, neilb@suse.de
List-Id: linux-raid.ids

>> I'd like to note that the symptoms include not even being
>> able to *type* at the console, which I thought was all in-kernel
>> code, not subject to being swapped out.  But whatever.
>
> Really? Or is it just that you can type but the characters don't get 
> echoed. The type part is in the kernel, but the display involves X 
> unless you run a direct console.

No, as I said, it was at a (text-mode) console, /dev/tty2 as I recall.
You're right, I expect it was just not echoing, as I could switch
consoles fine, implying that the lowest-level interrupt handler was
working, but it's still surprising.

The server stopped responding to my login, so I wandered over to the
console to look for kernel panics and encountered the symptom.
