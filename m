From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Creating failed-mode RAID1 with mdadm
Date: Fri, 3 May 2002 15:49:41 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15570.9461.715820.460557@notabene.cse.unsw.edu.au>
References: <20020430184832.GA381@willow.seitz.com>
	<20020430190315.GA680@willow.seitz.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Ross Vandegrift on Tuesday April 30
To: Ross Vandegrift <ross@willow.seitz.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday April 30, ross@willow.seitz.com wrote:
> > # mdadm --create /dev/md0 --level 1 --raid-disks=2 /dev/hde1 /dev/hdg1
> > 
> > I get:
> > 
> > mdadm: Cannot open /dev/hdg1: No such device or address
> > mdadm: create aborted
> 
> Hmmm, funny - as it turns out, mdadm actually created the array and
> started it with /dev/hdg1 failed.  It just said it didn't.

That surprises me?   Are you in a position to try it again and see?
If so, what version of mdadm?

NeilBrown
