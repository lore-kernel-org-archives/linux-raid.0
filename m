From: Joshua Baker-LePain <jlb17@duke.edu>
Subject: Re: 3ware 7500-8 confusion
Date: Mon, 24 Feb 2003 09:41:44 -0500 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0302240937520.2586-100000@chaos.egr.duke.edu>
References: <5.1.1.6.2.20030222232508.039dbda0@mail.harddata.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5.1.1.6.2.20030222232508.039dbda0@mail.harddata.com>
To: Maurice Hilarius <maurice@harddata.com>
Cc: Gregory Leblanc <gleblanc@linuxweasel.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 23 Feb 2003 at 12:53am, Maurice Hilarius wrote

> Actually it makes tons of sense.
*snip*
> 2) If you lose a disk at a later date, you don;t have to worry about 
> getting the same exact drive to replace it with.

Don't most hardware RAIDs (including the 3ware) deal just fine with 
dissimilar new disks, as long as their block count is >= that of the 
original disks?  My external IDE-SCSI unit does this, and I know my 3wares 
deal with disks with different rotation speeds.

-- 
Joshua Baker-LePain
Department of Biomedical Engineering
Duke University


