From: Mike Fedyk <mfedyk@matchmail.com>
Subject: Re: recovery of hosed raid5 array
Date: Sun, 26 Oct 2003 11:40:51 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20031026194051.GA4511@matchmail.com>
References: <slrnbog9og.t0c.lunz@orr.homenet> <no.Yo.24973.N.nN.0310111457280@business.com> <slrnboirt8.me8.lunz@orr.homenet> <Pine.LNX.4.58.0310121034090.7866@twinlark.arctic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0310121034090.7866@twinlark.arctic.org>
To: dean gaudet <dean-list-linux-raid@arctic.org>
Cc: Jason Lunz <lunz@falooley.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Oct 12, 2003 at 10:39:50AM -0700, dean gaudet wrote:
> 
> 
> On Sun, 12 Oct 2003, Jason Lunz wrote:
> 
> > What was foolish was me provoking /dev/hde by asking it to report
> > diagnostics with smartctl at the same time the array was rebuilding
> > /dev/hdg. Even if something _was_ wrong with hde, it wouldn't have
> > helped me to find out then during the rebuild. Had the resync completed,
> > I'd have all my data now and one dead disk.
> 
> querying SMART shouldn't cause this to happen -- but i've seen it occur
> with a promise controller and maxtor disks.  i used to query the SMART
> data once a night just to have a log.  then i switched it to once every 5
> minutes so i could graph the drive temperature... and when i went to once
> every 5 minutes the system became unstable.  the kernel would randomly
> lose the ability to talk to a disk.  the problem would go away after a
> reboot.  i assume it was some sort of race condition.

1.  Were they maxtor 160GB 8MB cache drives?

2.  Is there any package that will take one drive in a raid1/5 array
offline, and run badblocks on it?
