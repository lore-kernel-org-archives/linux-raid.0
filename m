From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Replacing Dead Disks in Hardware Array
Date: Tue, 4 Jan 2005 09:30:47 +0100 (CET)
Message-ID: <Pine.LNX.4.44.0501040930120.3584-100000@uplift.swm.pp.se>
References: <41D9E3B0.6080808@ruthless.ws>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41D9E3B0.6080808@ruthless.ws>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Thompson <mark@ruthless.ws>
Cc: Mailing List - Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, 4 Jan 2005, Mark Thompson wrote:

> Hi there,
> 
> While this isn't specific to linux, I've recently had a 160 gig 5400 RPM 
> Maxtor drive die in my Hardware raid (3ware Escalade PATA Controller) as 
> I am unable to find a suitable drive to replace it, would it be possible 
> to repleace it with a 7200RPM Maxtor 160 gig drive?

You need it to have at least the same amount of blocks. If you want to be 
sure, replace it with a larger drive.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se

