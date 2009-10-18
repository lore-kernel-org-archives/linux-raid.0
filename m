From: adfas asd <chimera_god@yahoo.com>
Subject: Re: best practice when using removable drives and USB enclosure?
Date: Sun, 18 Oct 2009 05:26:32 -0700 (PDT)
Message-ID: <178301.65932.qm@web38805.mail.mud.yahoo.com>
References: <2267211f0910171209u1ec7987dq67405f4b3bb780c0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2267211f0910171209u1ec7987dq67405f4b3bb780c0@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--- On Sat, 10/17/09, Tim Bostrom <tbostrom@gmail.com> wrote:
> >>You should be aware that using external disks
> through USB means that
> >>SMART tools can't monitor your disks for bad
> sectors and read errors,
> >>thus if any occur you won't know till you start
> getting I/O errors --
> >>it would be almost too late by then.
> 
> Yes, this is a major sticking point.  I am doing
> backups of this USB
> RAID1 array offline, but I'd like to get SMART
> status.  Long term I
> see this going into an eSATA enclosure.  Just need to
> find reasonable
> card supporting port multipliers and a good port
> multiplier.

If you use an advanced format like ZFS (ZFS-FUSE) or BTRFS you get checksumming, which should help.


      
