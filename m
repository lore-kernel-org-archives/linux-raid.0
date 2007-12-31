From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: New XFS benchmarks using David Chinner's recommendations for
  XFS-based  optimizations.
Date: Tue, 01 Jan 2008 08:32:15 +1300
Message-ID: <477943BF.2030101@sauce.co.nz>
References: <Pine.LNX.4.64.0712301752550.29138@p34.internal.lan>	<4778425A.4050805@sauce.co.nz> <18297.1341.691034.679513@base.ty.sabi.co.UK>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18297.1341.691034.679513@base.ty.sabi.co.UK>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Peter Grandi wrote:

> In particular if one uses parity-based (not a good idea in
> general...) arrays, as small chunk sizes (as well as stripe
> sizes) give a better chance of reducing the frequency of RMW.

Thanks for your thoughts - the above was my thinking when I posted.

Regards,

Richard
