From: Ross Vandegrift <ross@willow.seitz.com>
Subject: Re: Creating failed-mode RAID1 with mdadm
Date: Tue, 30 Apr 2002 15:03:15 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020430190315.GA680@willow.seitz.com>
References: <20020430184832.GA381@willow.seitz.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020430184832.GA381@willow.seitz.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> # mdadm --create /dev/md0 --level 1 --raid-disks=2 /dev/hde1 /dev/hdg1
> 
> I get:
> 
> mdadm: Cannot open /dev/hdg1: No such device or address
> mdadm: create aborted

Hmmm, funny - as it turns out, mdadm actually created the array and
started it with /dev/hdg1 failed.  It just said it didn't.

Ross Vandegrift
ross@willow.seitz.com
