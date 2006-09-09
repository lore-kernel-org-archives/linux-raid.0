From: dean gaudet <dean@arctic.org>
Subject: Re: UUID's
Date: Fri, 8 Sep 2006 20:12:41 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0609082011050.8584@twinlark.arctic.org>
References: <4501E9C6.10403@sauce.co.nz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4501E9C6.10403@sauce.co.nz>
Sender: linux-raid-owner@vger.kernel.org
To: Richard Scobie <richard@sauce.co.nz>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



On Sat, 9 Sep 2006, Richard Scobie wrote:

> If I have specified an array in mdadm.conf using UUID's:
> 
> ARRAY /dev/md0 UUID=3aaa0122:29827cfa:5331ad66:ca767371
> 
> and I replace a failed drive in the array, will the new drive be given the
> previous UUID, or do I need to upate the mdadm.conf entry?

once you do the "mdadm /dev/mdX -a /dev/newdrive" the new drive will have 
the UUID.  no need to update the mdadm.conf for the UUID...

however if you're using "DEVICE foo" where foo is not "partitions" then 
you should make sure foo includes the new drive.  ("DEVICE partitions" is 
recommended.)

-dean
