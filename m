From: Jeff Woods <Kazrak+kernel@cesmail.net>
Subject: Re: make hpt37xx fails
Date: Fri, 09 Apr 2004 13:32:40 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <6.0.1.1.0.20040409132124.02880f90@no.incoming.mail>
References: <4076F259.196B@ij.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4076F259.196B@ij.net>
References: <4076F259.196B@ij.net>
To: Felix Miata <mrmazda@ij.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

At 4/9/2004 02:58 PM -0400, Felix Miata wrote (in part):
># make KERNELDIR=/usr/src/linux-2.6.3-7mdk
>
>When I do this, a bunch of messages scroll, ending with:

Sorry, but I don't have an answer for your hard questions.  However:

>Where is this info scrolled off the screen too fast to read logged for 
>later inspection?

It's not saved (unless you happen to be using some 
console/terminal/whatever that logs. Try (assuming you're using bash or 
similar):

         make 
KERNELDIR=/usr/src/linux-2.6.3-7mdk >some-output-filename-you-like 2>&1

or

         make KERNELDIR=/usr/src/linux-2.6.3-7mdk 2>&1 |less

The first instance redirects stdout to a file and then redirects stderr to 
stdout. The second redirects stderr to stdout and then pipes both to less 
to allow you to scroll around and/or save the result. If you don't want or 
need stderr output with stdout then just omit the "2>&1" or even replace it 
with "2>/dev/null" to throw it away.

--
Jeff Woods <kazrak+kernel@cesmail.net> 


