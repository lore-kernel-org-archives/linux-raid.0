From: Joshua Baker-LePain <jlb17@duke.edu>
Subject: Re: 3ware 7500-8 on 32 & 64 bit PCi
Date: Tue, 14 Oct 2003 08:52:43 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0310140851480.11031-100000@chaos.egr.duke.edu>
References: <3F8BF047.6080105@bnap.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3F8BF047.6080105@bnap.hu>
To: Farkas Levente <lfarkas@bnap.hu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 14 Oct 2003 at 2:47pm, Farkas Levente wrote

> what is the performance difference between two 3ware 7500-8 PCI card on 
> a 32 or a 64 bit PCI slot if used with 8 pieces of 120GB hard disk (and 
> linux software raid5:-). I know there is not an exact measurment, but 
> what is your estimate?

You will be limited by the PCI bandwidth on the 32bit bus (133 MB/s - 
whatever else you have on the bus).  I've benched a single board at 
~200MB/s reading using the hardware RAID 5.

-- 
Joshua Baker-LePain
Department of Biomedical Engineering
Duke University

