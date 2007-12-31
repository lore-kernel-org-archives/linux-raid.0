From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: New XFS benchmarks using David Chinner's recommendations for  XFS-based  optimizations.
Date: Mon, 31 Dec 2007 14:14:02 +1300
Message-ID: <4778425A.4050805@sauce.co.nz>
References: <Pine.LNX.4.64.0712301752550.29138@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0712301752550.29138@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Justin Piszcz wrote:

> Why does mdadm still use 64k for the default chunk size?

Probably because this is the best balance for average file sizes, which 
are smaller than you seem to be testing with?

Regards,

Richard
