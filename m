From: Tim Small <tim@seoss.co.uk>
Subject: Re: Determining which spindle is out of order
Date: Wed, 03 Nov 2010 20:03:20 +0000
Message-ID: <4CD1C008.5040605@seoss.co.uk>
References: <loom.20101103T115828-494@post.gmane.org>	<4CD17583.6070909@seoss.co.uk> <AANLkTim7F+JVDb008XkcH0+4t+vzivV6CprejAQp5xa1@mail.gmail.com> <4CD1992D.3050008@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4CD1992D.3050008@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Jon@eHardcastle.com, Jon Hardcastle <jonathan.hardcastle@gmail.com>, Nat Makarevitch <Shelso@makarevitch.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 03/11/10 17:17, Bill Davidsen wrote:
> When I ran servers for an ISP we had a utility which blinked the light
> on the drive (assumes it hasn't gone utterly belly up, of course).
>

I believe that this is part of the SCSI standard, certainly a brief look
around a few months ago didn't turn up a way of doing this for SATA
drives (i.e. nothing in the relevant standards, particular drive vendors
may have their own non-standard commands to do this, or enclosure
manufacturers may have out-of-band methods for this).

If anyone knows better, please let me know!


Cheers,

Tim.

-- 
South East Open Source Solutions Limited
Registered in England and Wales with company number 06134732.  
Registered Office: 2 Powell Gardens, Redhill, Surrey, RH1 1TQ
VAT number: 900 6633 53  http://seoss.co.uk/ +44-(0)1273-808309

