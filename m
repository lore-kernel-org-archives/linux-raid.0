From: Tim Small <tim@seoss.co.uk>
Subject: Re: Is this likely to cause me problems?
Date: Wed, 22 Sep 2010 10:09:04 +0100
Message-ID: <4C99C7B0.4090807@seoss.co.uk>
References: <94202.62107.qm@web51304.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <94202.62107.qm@web51304.mail.re2.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Cc: Jon@eHardcastle.com
List-Id: linux-raid.ids

On 21/09/10 22:07, Jon Hardcastle wrote:
> Are you sure this is the issue?

Pretty sure.

>   the number of blocks is different in both measurements see below..
>    

Yes - differing CHS-compatible geometry will do this, because 
CHS-compatible partitions will start/end on the fake "cylinder" 
boundaries.  So you have different amounts of unnecessary wastage at 
both the start and the end when using different number of pretend 
cylinders, heads, and sectors per track...

If there's nothing on the disk yet, then surely you haven't got anything 
to lose by telling fdisk to use different CHS layouts (using the command 
line switches) anyway, or just ignoring CHS entirely and using the whole 
disk - and like I said it's highly unlikely anything on your system ever 
does anything with CHS block addressing anyway - Linux uses LBA 
addressing exclusively, and so do its bootloaders.

Tim.

-- 
South East Open Source Solutions Limited
Registered in England and Wales with company number 06134732.
Registered Office: 2 Powell Gardens, Redhill, Surrey, RH1 1TQ
VAT number: 900 6633 53  http://seoss.co.uk/ +44-(0)1273-808309

