From: Joshua Baker-LePain <jlb17@duke.edu>
Subject: Re: =?iso-8859-1?Q?=BF_the_best_journalist-filesystem_for_a_?=
 raid5 ?
Date: Thu, 3 Jul 2003 11:59:15 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0307031157450.18503-100000@chaos.egr.duke.edu>
References: <5.2.1.1.2.20030703173829.023eabe8@192.168.2.130>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5.2.1.1.2.20030703173829.023eabe8@192.168.2.130>
To: system_lists@nullzone.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 3 Jul 2003 at 5:42pm, system_lists@nullzone.org wrote

>     i dont wanna create a discusion between gurus. My question is so simple 
> (well .. its not simple but ...).
> 
> What do u think is the best journalist filesystem for a software raid5 of 
> 4*120 GB IDE UATA ?
> I will use this one for big files (lots of them) and small ones (just a ftp 
> but too for the users space).
> 
> For a non-specific BIG/SMALL files .... JFS? Reiser3? Reiser4? EXT3?

I've had very good luck with XFS for a long time now (over 2 years in 
production, currently 5.5TB of formatted space).

-- 
Joshua Baker-LePain
Department of Biomedical Engineering
Duke University

