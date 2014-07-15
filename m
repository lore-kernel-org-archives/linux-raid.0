From: Pete <psid@riverland.net.au>
Subject: Re: How to fix this superblock?
Date: Tue, 15 Jul 2014 21:28:53 +0930
Message-ID: <20140715212853.33cddb41.psid@riverland.net.au>
References: <20140616105927.828a6765.psid@riverland.net.au>
	<20140616114829.6e6b7fa6@notabene.brown>
	<20140616115436.dbf865af.psid@riverland.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140616115436.dbf865af.psid@riverland.net.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 16 Jun 2014 11:54:36 +0930
Pete <psid@riverland.net.au> wrote:
> On Mon, 16 Jun 2014 11:48:29 +1000
> NeilBrown <neilb@suse.de> wrote:
> > On Mon, 16 Jun 2014 10:59:27 +0930 Pete <psid@riverland.net.au> wrote:

> > > When I try to re-add the device that used to be part of the array, mdadm
> > > says it's not large enough:
> > > 
> > > # mdadm --add /dev/md1 /dev/sdb3
> > > mdadm: /dev/sdb3 not large enough to join array
> > > 
> > > The partition tables hadn't changed when this started. Since then I've
> > > re-partitioned sdb to make sdb3 a few GB bigger, but it's still not
> > > large enough.
> > > 
> > > Looking at the working device's superblock, there's a heap of "failed"
..
> > I suspect that upgrading to a newer mdadm would solve most of these problems.

I booted a debian7 live CD. parted wouldn't read the partition table on
sdb so I re-partitioned sdb. Then mdadm was able to --add sdb3. Rebooted
to the old ubuntu - all looking good now.

Thanks for your help.  Pete

