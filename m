From: Joshua Baker-LePain <jlb17@duke.edu>
Subject: Re: Software RAID-0 striping over Hardware RAID-5
Date: Mon, 20 Sep 2004 09:12:17 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0409200910590.6936@chaos.egr.duke.edu>
References: <7e.58df669c.2e7cb92f@aol.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7e.58df669c.2e7cb92f@aol.com>
To: AndyLiebman@aol.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 17 Sep 2004 at 6:03pm, AndyLiebman@aol.com wrote

> I have a Xeon machine (3.06 Ghz single processor, 2 GB RAM, SuperMicro 
> motherboard) with two 3ware 9500S-8 cards. I'm getting good performance with 3ware's 
> Hardware RAID-5 (I have reasons why I don't want to use Software RAID-5 on 
> this machine). 
> 
> My question is, what kind of problems, if any, might I run into if I use 
> Linux Software RAID to stripe the two RAID-5's together into a single RAID-0? The 
> reason I'm thinking about doing this is to squeeze more performance out of the 
> storage system for working with huge video files. 

I have a couple of dual 3ware boxes I do this with, and have never had a 
problem.  I would make sure that you have a hot spare on your RAID5 
arrays, though.  Because if one of them dies, you'll obviously lose 
everything on both arrays.

-- 
Joshua Baker-LePain
Department of Biomedical Engineering
Duke University
