From: Neil Brown <neilb@suse.de>
Subject: Re: Verifying spare drive, best practices
Date: Tue, 25 Mar 2008 15:48:33 +1100
Message-ID: <18408.33825.920147.425644@notabene.brown>
References: <47E33AF8.6020106@harddata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Maurice Hilarius on Thursday March 20
Sender: linux-raid-owner@vger.kernel.org
To: Maurice Hilarius <maurice@harddata.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday March 20, maurice@harddata.com wrote:
> Given this situation:
> 7 disks in total
> RAID5 of 6 disks, and a hot spare.
> 
> mdadm show the 6 disks, but not the spare.
> 
> As a maintenance question, where one wants to periodically ensure that 
> the hot spare is both available and good.
> How should one best :
> 1) Verify the hot spare is still available.

 - On the relevant line in mdadm.conf, put "spares=1"
 - have a daily cron job that runs
     mdadm --montor --scan --oneshot

It will report every day with a "SparesMissing" event if the right
number of spares is not present.

> 2) Verify that the hot spare is healthy?

Others have answered this.

NeilBrown
