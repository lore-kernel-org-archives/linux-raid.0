From: Joshua Baker-LePain <jlb17@duke.edu>
Subject: Re: RAID/Backup Strategies
Date: Wed, 3 Mar 2004 14:18:58 -0500 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0403031415400.18576@chaos.egr.duke.edu>
References: <Pine.LNX.4.56.0403030912270.10347@zeus.rsc.raytheon.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.56.0403030912270.10347@zeus.rsc.raytheon.com>
To: Steve Witt <sawitt@electra.rsc.raytheon.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 3 Mar 2004 at 9:35am, Steve Witt wrote

> The thing I am confused about is how this will affect our amanda backup
> strategy. The array size will be a little over 700 GB. To follow our
> current amanda setup it seems that the RAID device should be split into
> multiple partitions with one dedicated as a holding partition for amanda.
> But I'm not sure this is possible or desireable with a RAID array.

You don't have to do that.  Lines in amanda's disklist need not be 
partitions as long as you use tar as the backup tool.  You can play all 
sorts of tricks with includes and excludes as well.  Search the amanda 
mailing list archives for all details on this, or look in the sample 
disklist included in the amanda tarball for examples.  I currently backup 
5.5TB worth of formatted space (4 partitions) to 2 AIT3 drives with 
amanda.

-- 
Joshua Baker-LePain
Department of Biomedical Engineering
Duke University
