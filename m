From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Strangeness when booting raid1: md5 already running?
Date: Tue, 22 Mar 2005 09:38:29 +1100
Message-ID: <16959.19685.520138.180516@cse.unsw.edu.au>
References: <1111407978.757.7.camel@filestore.ivimey.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
In-Reply-To: message from Ruth Ivimey-Cook on Monday March 21
Sender: linux-raid-owner@vger.kernel.org
To: Ruth Ivimey-Cook <Ruth.Ivimey-Cook@ivimey.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday March 21, Ruth.Ivimey-Cook@ivimey.org wrote:
> Folks,
> 
> I had to pull the plug on my box today, and when it rebooted got this
> rather strange raid issue. The box has 5 raid1 arrays, consisting of 5
> partitions on each of 2 drives. When it rebooted, the md5 array came up
> like so:
> 
> raid1: raid set md0 active with 2 out of 2 mirrors
> md: ... autorun DONE.
> md: Autodetecting RAID arrays.
> md: autorun ...
> md: considering hda9 ...
> md:  adding hda9 ...
...repeated several times....
> md: export_rdev(hda9)
> md: ... autorun DONE.
> EXT3-fs: INFO: recovery required on readonly filesystem.
> EXT3-fs: write access will be enabled during recovery.
> EXT3-fs: recovery complete.
> 
> Now this was the first time the string "md5" appears in the log. And
> indeed, it appears that hda9 has been kicked out of the array:

So was md5 actually running (what did /proc/mdstat show? What about
mdadm -D /dev/md5?).
My guess is that your startup scripts, possibly in an initrd used the
RAID_AUTORUN command several times, and each time it found the drive
which wasn't part of an array but couldn't be added to one.  Nothing
particularly interesting.

If md5 hadn't actually been started, then that is interesting.

NeilBrown
