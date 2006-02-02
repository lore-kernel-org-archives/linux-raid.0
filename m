From: Joshua Baker-LePain <jlb17@duke.edu>
Subject: Re: benchmarking
Date: Wed, 1 Feb 2006 19:35:23 -0500 (EST)
Message-ID: <Pine.LNX.4.62.0602011934050.11725@chaos.egr.duke.edu>
References: <5.1.0.14.2.20060201182533.0b78b008@localhost>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5.1.0.14.2.20060201182533.0b78b008@localhost>
Sender: linux-raid-owner@vger.kernel.org
To: Tom Peters <tpeters@mixcom.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 1 Feb 2006 at 6:28pm, Tom Peters wrote

> Does Linux (SuSE 9) have a tool that will give me a handle on read/write 
> throughput to a drive without trashing anything on the drive (i.e. using 
> empty space on it)?  I have an 8-drive array and sometimes writes to it fail 
> over the network (Samba) and I can't prove its the array and not the network.
>
> I've played with hdparm -Tt and gotten some idea. What else can I try that 
> won't take a lot of setup?

bonnie++ is very easy to compile and use, and tiobench only slightly less 
so.

-- 
Joshua Baker-LePain
Department of Biomedical Engineering
Duke University
