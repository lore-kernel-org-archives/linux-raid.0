From: Alistair John Strachan <alistair@devzero.co.uk>
Subject: Re: md (regression): reboot/shutdown hangs
Date: Mon, 1 Sep 2008 12:43:50 +0100
Message-ID: <200809011243.50300.alistair@devzero.co.uk>
References: <200808282005.09416.alistair@devzero.co.uk> <18619.20642.697691.541752@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18619.20642.697691.541752@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
List-Id: linux-raid.ids

Hi Neil,

On Monday 01 September 2008 03:17:06 Neil Brown wrote:
> On Thursday August 28, alistair@devzero.co.uk wrote:
> > Please let me know if there's any more information you need from me.
>
> Thanks for the report.
[snip]
> So I plan to remove it.  With it gone I cannot reproduce a hang.  If
> you can, I would love to hear about it.

I haven't tested it too much but it's passed a few reboots on this box which 
was previously hanging reliably. I think it would be OK to merge on top of 
2b25000bf5157c28d8591f03f0575248a8cbd900.

Thanks for the explanation and for the fix.

-- 
Cheers,
Alistair.
