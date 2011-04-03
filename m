From: Jonathan Tripathy <jonnyt@abpni.co.uk>
Subject: Re: Raid Checks
Date: Sun, 03 Apr 2011 12:04:46 +0100
Message-ID: <4D98544E.9000107@abpni.co.uk>
References: <4D983064.30808@abpni.co.uk>	<4D98346F.8090502@abpni.co.uk> <20110403210157.2c3ac83d@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110403210157.2c3ac83d@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


>> My main concern, is that during these resyncs, I loose redundancy, don't I?
> No.
>
> NeilBrown
>
Ah right, so by letting the raid-check script resync my RAID1 arrays 
every Sunday, the only thing I loose is disk performance during the 
resync? This is what state my server is currently in:

State : clean, resyncing
  Active Devices : 2
Working Devices : 2
  Failed Devices : 0
   Spare Devices : 0

  Rebuild Status : 77% complete

Thanks
