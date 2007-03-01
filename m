From: rabbit@rabbit.us (Peter Rabbitson)
Subject: Re: swap on raid
Date: Thu, 1 Mar 2007 18:34:20 -0500
Message-ID: <20070301233420.GA12963@rabbit.us>
References: <20070301222739.GA4835@rabbit.us> <45E75CBC.2050003@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <45E75CBC.2050003@sauce.co.nz>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> The fact that you mention you are using partitions on disks that 
> possibly have other partions doing other things, means raw performance 
> will be compromised anyway.
> 
> Regards,
> 
> Richard

You know I never thought about it, but you are absolutely right. The 
times at which my memory usage peaks coincide with high disk activity 
(mostly reads). In this light it actually might be better to keep the 
swap in a file on my raid10 (-p n3) which occupies most of these 4 
drives, and hope that the md code will be able to distribute the io 
across idle drives. Does this sound about right?
