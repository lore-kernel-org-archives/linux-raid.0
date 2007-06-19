From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [linux-lvm] 2.6.22-rc5 XFS fails after hibernate/resume
Date: Tue, 19 Jun 2007 13:21:06 +0200
Message-ID: <200706191321.07278.rjw@sisk.pl>
References: <46744065.6060605@dgreaves.com> <4676D97E.4000403@dgreaves.com> <4677A0C7.4000306@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4677A0C7.4000306@dgreaves.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: David Chinner <dgc@sgi.com>, Tejun Heo <htejun@gmail.com>, David Robinson <zxvdr.au@gmail.com>, LVM general discussion and development <linux-lvm@redhat.com>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, linux-pm <linux-pm@lists.osdl.org>, LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tuesday, 19 June 2007 11:24, David Greaves wrote:
> David Greaves wrote:
> > I'm going to have to do some more testing...
> done
> 
> 
> > David Chinner wrote:
> >> On Mon, Jun 18, 2007 at 08:49:34AM +0100, David Greaves wrote:
> >>> David Greaves wrote:
> >>> So doing:
> >>> xfs_freeze -f /scratch
> >>> sync
> >>> echo platform > /sys/power/disk
> >>> echo disk > /sys/power/state
> >>> # resume
> >>> xfs_freeze -u /scratch
> >>>
> >>> Works (for now - more usage testing tonight)
> >>
> >> Verrry interesting.
> > Good :)
> Now, not so good :)
> 
> 
> >> What you were seeing was an XFS shutdown occurring because the free space
> >> btree was corrupted. IOWs, the process of suspend/resume has resulted
> >> in either bad data being written to disk, the correct data not being
> >> written to disk or the cached block being corrupted in memory.
> > That's the kind of thing I was suspecting, yes.
> > 
> >> If you run xfs_check on the filesystem after it has shut down after a 
> >> resume,
> >> can you tell us if it reports on-disk corruption? Note: do not run 
> >> xfs_repair
> >> to check this - it does not check the free space btrees; instead it 
> >> simply
> >> rebuilds them from scratch. If xfs_check reports an error, then run 
> >> xfs_repair
> >> to fix it up.
> > OK, I can try this tonight...
> 
> 
> This is on 2.6.22-rc5

Is the Tejun's patch

http://www.sisk.pl/kernel/hibernation_and_suspend/2.6.22-rc5/patches/30-block-always-requeue-nonfs-requests-at-the-front.patch

applied on top of that?

Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
