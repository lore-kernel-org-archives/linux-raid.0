From: Joshua Baker-LePain <jlb17@duke.edu>
Subject: Re: Real Time Mirroring of a NAS
Date: Fri, 7 Apr 2006 07:04:52 -0400 (EDT)
Message-ID: <Pine.LNX.4.62.0604070703560.27432@chaos.egr.duke.edu>
References: <44364336.7060704@aol.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44364336.7060704@aol.com>
Sender: linux-raid-owner@vger.kernel.org
To: andy liebman <andyliebman@aol.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 7 Apr 2006 at 6:47am, andy liebman wrote

> I'm looking for a way to create a real-time mirror of a NAS. In other words, 
> say I have a 5.5 TB NAS (3ware 16-drive array, RAID-5, 500 GB drives). I want 
> to mirror it in real time to a completely separate 5.5 TB NAS. RSYNCing in 
> the background is not an option. The two NAS boxes need to hold identical 
> data at all times. It is NOT necessary that the data be accessed from both 
> NAS boxes simultaneously. One is simply a backup of the other.
>
> I guess one option might be to use Redhat's Global File System (GFS). 
> Although there seems to be an 8TB limit for a GFS filesystem, which could be 
> an issue down the road.

I don't have any experience with it, but I've often seen DRBD mentioned 
for just this sort of situation.  I'd look into that.

-- 
Joshua Baker-LePain
Department of Biomedical Engineering
Duke University
