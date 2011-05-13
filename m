From: NeilBrown <neilb@suse.de>
Subject: Re: New device for RAID array
Date: Fri, 13 May 2011 11:21:19 +1000
Message-ID: <20110513112119.79e67ceb@notabene.brown>
References: <DF.A6.28813.F428CCD4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <DF.A6.28813.F428CCD4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: lrhorer@satx.rr.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 12 May 2011 19:59:01 -0500 "Leslie Rhorer" <lrhorer@satx.rr.com>
wrote:

> 
> I read through the man page for mdadm a couple of times and did not spot how
> to do this.  I currently have a RAID array that I need to upgrade from 1T
> drives to 3T drives.  To accomplish this, I intend to create a larger array,
> but with fewer spindles, and then rsync the contents of the old array to the
> new.  Once I am done, I then want to stop the old array (/dev/md0) and start
> up the new array under /dev/md0.  Do I have to stop the array and then
> re-create it with all the same parameters, except the device target?

For v0.90:  --update=super-minor
For v1.x    --update=name

NeilBrown
