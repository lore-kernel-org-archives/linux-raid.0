From: Joshua Baker-LePain <jlb17@duke.edu>
Subject: Re: Measuring RAID-0 CPU load
Date: Mon, 8 Mar 2004 12:21:08 -0500 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0403081220430.8750@chaos.egr.duke.edu>
References: <404CAA28.6030502@comcast.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <404CAA28.6030502@comcast.net>
To: Ian Pilcher <i.pilcher@comcast.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 8 Mar 2004 at 11:15am, Ian Pilcher wrote

> I need to quantify the additional CPU load that RAID-0 adds (vs. the
> boost in I/O performance).  I don't need to do anything fancy;
> 'dd if=/dev/zero of=/dev/md?" should do the trick, but I'm not sure how
> to track the processor utilization during the run.

bonnie++ reports CPU usage.

-- 
Joshua Baker-LePain
Department of Biomedical Engineering
Duke University
