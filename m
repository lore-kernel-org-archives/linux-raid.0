From: Joshua Baker-LePain <jlb17@duke.edu>
Subject: Re: Problems with huge filesystem
Date: Mon, 12 Apr 2004 13:10:46 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0404121309580.26077@chaos.egr.duke.edu>
References: <407AC316.8040605@tracersinfo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <407AC316.8040605@tracersinfo.com>
To: Mike Barnard <mike@tracersinfo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 12 Apr 2004 at 12:25pm, Mike Barnard wrote

>     I'm running Redhat Linux 9 with the stock 2.4.20smp kernel on a dual 
> Athlon MP 1800+ box with 2G RAM.

Max block device size in the 2.4 kernel is 2TB.  You'll need to use 2.6 
(or apply the LBD patch to 2.4) to get over that.

-- 
Joshua Baker-LePain
Department of Biomedical Engineering
Duke University
