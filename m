From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Help! I killed my mdadm raid 5
Date: Thu, 18 Nov 2010 19:32:06 -0600
Message-ID: <8F.28.07087.893D5EC4@cdptpa-omtalb.mail.rr.com>
References: <20101118195109.1GA4L.64443.root@cdptpa-web04-z02>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101118195109.1GA4L.64443.root@cdptpa-web04-z02>
Sender: linux-raid-owner@vger.kernel.org
To: p3-500@roadrunner.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of p3-500@roadrunner.com
> Sent: Thursday, November 18, 2010 1:51 PM
> To: linux-raid@vger.kernel.org
> Subject: Help! I killed my mdadm raid 5
> 
> Arrg, Major goof. I managed to kill my raid 5 through my own stupidity.
> Here is the chain of events, Your help is greatly appreciated.
> 
> I added disk #6 to my working 5 disk array, after about 24 hours it was
> done but i did not see the extra space (I now know all I needed to do was
> fsck and resize).
> 
> I failed and removed the new disk from the array then somehow also failed
> and removed drive # 5 from the array. At this point the array was still
> running so I added drive #5 & 6 back to the array but they got added as
> spares instead of active components. next I rebooted and could not
> assemble the array.
> 
> I tried --assemble and --assemble --force which results with "mdadm:
> /dev/md0 assembled from 4 drives and 1 spare - not enough to start the
> array". I am naming all 6 drives on the command line.
> 
> Several posts have suggested I --create the array again but I am hesitant
> to do this as I do not want to lose my data.

	Yep, that's it.  I would carefully inspect each drive using
--examine to determine its proper place, but the two failed drives are a bit
of a craps shoot, since you have already overwritten their metafiles.  I
would assemble the array in read-only mode and then read-only fsck the
unmounted file system.  IF this passes, the do a read-write fsck.  Finally,
mount the file system read-only and test the data well before continuing.
The first file system access should trigger a resync.  When creating the
array, use the --assume-clean option so no resync will occur.

