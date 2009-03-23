From: Neil Brown <neilb@suse.de>
Subject: Re: raid 1 single drive failure. rebuilt with replacement drive.
	missing 20G of data
Date: Mon, 23 Mar 2009 17:09:58 +1100
Message-ID: <18887.10166.209184.82788@notabene.brown>
References: <20090312021024.GA31067@earthlink.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Mitchell Laks on Wednesday March 11
Sender: linux-raid-owner@vger.kernel.org
To: Mitchell Laks <mlaks@post.harvard.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday March 11, mlaks@post.harvard.edu wrote:
> Hi,
> 
> I have used linux software raid1 for many years without any data loss. Now I seem to have a problem.
> 
> I run a server with a pair of WD 400G drives that I keep in a raid 1 configuration. The raid became degraded
> but continued to function and continue to store data on the remaining  drive. 
> 
> I simply replaced the faulty drive and rebuilt the raid. All seemed to be   ok,  however now I notice that 20G of data are 
> missing from the raid. I see this by comparing to a backup device that I mirror to every night.
> 
> Any idea on how can this have happened? These are the most recent 20G of data. Perhaps this is the last 20 G since the 
> raid went bad,  however that the data was clearly stored initially - I see it on the backup device I copied to.
> 
> Could the data   have been lost in the rebuild process? seems strange. Total of 220G of data on the device at present.

Seems very strange indeed.  I cannot explain it at all.
So you have complete kernel logs covering the time when the drive
failed, and the time when you added a new device?  They might shed
some light.

An explanation that fits most of the available data is that you
actually replaced the good drive rather than the bad drive.  Was the
'bad' drive totally dead, or just a bit sick and might have recovered
after cooling down?

NeilBrown
