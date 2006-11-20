From: Neil Brown <neilb@suse.de>
Subject: Re: safely removing RAID information?
Date: Mon, 20 Nov 2006 21:34:18 +1100
Message-ID: <17761.33962.217654.415664@cse.unsw.edu.au>
References: <20061109101909.GA10711@scavenger.homeip.net>
	<20061120100226.GA32016@scavenger.homeip.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Benjamin Schieder on Monday November 20
Sender: linux-raid-owner@vger.kernel.org
To: Benjamin Schieder <blindcoder@scavenger.homeip.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday November 20, blindcoder@scavenger.homeip.net wrote:
> > 
> > Now, /dev/hda1 (and hda[35678]) are parts of active RAID arrays.
> > /dev/hda (whole disk) was part of an array I set up for testing/playing
> > around with mdadm. I then created the partitions and set up RAIDs for them.
> > 
> > Is it safe to issue the following command now:
> > 
> > root@ceres:~# mdadm --zero-superblock /dev/hda

Yes.

> > 
> > or will that nuke my setup along with my precious data?

No

NeilBrown
