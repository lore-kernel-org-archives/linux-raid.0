From: Joshua Baker-LePain <jlb17@duke.edu>
Subject: Re: IDE Soft-RAID5, poor performance (suspected)
Date: Thu, 13 Mar 2003 12:37:19 -0500 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0303131235450.2065-100000@chaos.egr.duke.edu>
References: <20030313150047.ALLYOURBASEAREBELONGTOUS.C10081@bla.fasel.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20030313150047.ALLYOURBASEAREBELONGTOUS.C10081@bla.fasel.org>
To: Wolfram Schlich <lists@schlich.org>
Cc: Linux-RAID mailinglist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, 13 Mar 2003 at 4:00pm, Wolfram Schlich wrote

> I'd be pleased to give more details as needed.
> Should I run any tiobench/tiotest or bonnie++ benchmarks?

Yes.  AFAICT, all your benchmarks involved another disk system (or read 
and wrote to the array simultaneously), which confounds the results.  A 
benchmark tool will source the data from /dev/zero or somesuch (or send it 
to /dev/null), so all you're testing is the array.

Good luck.

-- 
Joshua Baker-LePain
Department of Biomedical Engineering
Duke University

