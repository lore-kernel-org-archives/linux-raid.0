From: Robert L Mathews <lists@tigertech.com>
Subject: Re: RAID 1 failure on single disk causes disk subsystem to lock up
Date: Mon, 31 Mar 2008 10:30:42 -0700
Message-ID: <47F11FC2.6000401@tigertech.com>
References: <47F020C6.1060809@tigertech.com> <alpine.DEB.1.00.0803310600330.10181@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.00.0803310600330.10181@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Justin Piszcz wrote:

>Did you have swap on the RAID1 as well?

Yes, although swap usage on these machines is generally zero (they have 
4 GB of RAM and there's rarely anything in swap at all).

Even if there was some swap usage, though, that shouldn't cause this 
problem, should it? The point of putting swap on RAID is to avoid 
exactly this kind of issue.

-- 
Robert L Mathews
