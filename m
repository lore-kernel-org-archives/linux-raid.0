From: Thomas Backlund <tmb@mandriva.org>
Subject: Re: Configure speed of checkarray in mdadm?
Date: Sun, 03 May 2009 22:50:32 +0300
Message-ID: <49FDF588.2040500@mandriva.org>
References: <49FDB2E2.6000300@kth.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49FDB2E2.6000300@kth.se>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

David Vuorio skrev:
> Hi,
> 
> I'm a happy user of mdadm 2.6.7.1 (2.6.7.1-1ubuntu8) and would like to
> make a request.
> 
> When my monthly RAID check is triggered (I have two SATA disks in a
> RAID1 setup) it consumes a significant amount of resources, essentially
> freezing the system for the most part.
> 
> While I might cancel or reschedule these checks as needed, I would
> prefer if the bandwidth usage could be configured manually, or even
> adjusted dynamically. Alternatively, is there already a way to minimize
> the impact beforehand?
> 
> Thanks a lot for your help.
> 

Change value of /sys/block/mdX/md/sync_speed_max ?

--
Thomas
