From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Lots of con-current I/O = resets SATA link? (2.6.25.10)
Date: Sat, 05 Jul 2008 13:04:50 -0600
Message-ID: <486FC5D2.80600@shaw.ca>
References: <fa.u8J+BqAcxU1mg8ob9pMBJaAHBPo@ifi.uio.no>
 <486FBFAB.5050303@shaw.ca>
 <cccedfc60807051154m7d0a8b44h3294ec29fe07d35a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <cccedfc60807051154m7d0a8b44h3294ec29fe07d35a@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jon Nelson wrote:
> Where should APIC errors be posted?
> My EPoX MF570-SLI *will not boot* without noapic or nolapic.

Post on linux-kernel about that one, with the dmesg from noapic mode and 
whatever info you can gather from when it won't boot. You might want to 
also test with 2.6.26-rc8 to see if the problem has already been fixed 
there.
