From: Joshua Baker-LePain <jlb17@duke.edu>
Subject: Re: RAID-5 making big partition fails
Date: Tue, 19 Sep 2006 16:42:40 -0400 (EDT)
Message-ID: <Pine.LNX.4.62.0609191641200.29261@chaos.egr.duke.edu>
References: <Pine.SOL.4.58.0609191633020.24136@titan.cfa.harvard.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.SOL.4.58.0609191633020.24136@titan.cfa.harvard.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Gaspar Bakos <gbakos@cfa.harvard.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 19 Sep 2006 at 4:39pm, Gaspar Bakos wrote

> I have a 12 disk RAID-5 hardware RAID with an ARECA card.
> This is under FC5,  2.6.17.6 kernel. The areca driver correcly reports
> 5Tb diskspace on this unit, shown as /dev/sdc:
>
> # fdisk /dev/sdc

fdisk won't work.

> I also tried 'gparted', but the same problem.

In parted, you need to 'mklabel gpt'.  Standard msdos disklabels don't 
handle devices >2TiB.

You won't be able to boot off this device, but it looks like that's not a 
concern for you.

-- 
Joshua Baker-LePain
Department of Biomedical Engineering
Duke University
