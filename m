From: Neil Schemenauer <nas@python.ca>
Subject: Re: RAID 5 performance problems
Date: Thu, 3 Apr 2003 11:13:12 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030403191311.GA9406@glacier.arctrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ross Vandegrift <ross@willow.seitz.com> wrote:
> Absolutely correct - you should *never* run IDE RAID on a channel that
> has both a master and slave.  When one disk on an IDE channel has an
> error, the whole channel is reset - this makes both disks
> inaccessible,
> and RAID5 now has two failed disks => you data is gone!  *ALWAYS* use
> separate IDE channels.

I think it's okay to use both channels if you use RAID0+1 (also
known as RAID10), just be sure to mirror across channels.  As a
bonus, RAID0+1 is significantly faster than RAID5.

  Neil
