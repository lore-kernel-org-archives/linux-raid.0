From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: how to recreate a raid5 array with n-1 drives?
Date: Tue, 06 May 2008 19:17:52 +1200
Message-ID: <48200620.6060600@sauce.co.nz>
References: <20080506054819.GA6413@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080506054819.GA6413@merlins.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Marc MERLIN wrote:

> In the olden days (pre-mdadm), I could bring up the array by giving 5 drives
> and marking /dev/sde1 as failed-disk instead of read-disk (or somesuch).
> 
> I could not find a way to do this with mdadm in the man page. How do I give
> /dev/sde1 on the command line as a failed drive?

Looking at the mdadm man page in the "CREATE MODE" section:

"To create a "degraded" array in which some devices are missing,  simply
give  the  word  "missing"  in place of a device name.  This will cause
mdadm to leave the corresponding slot in the array empty.  For a  RAID4
or  RAID5 array at most one slot can be "missing"; for a RAID6 array at
most two slots.  For a RAID1 array, only one real device  needs  to  be 
given.  All of the others can be "missing"."

Regards,

Richard
