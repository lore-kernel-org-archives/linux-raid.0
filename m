From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: [PATCH 2.6.0-test3] avoid raid1 resync abort
Date: Fri, 22 Aug 2003 16:59:56 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16197.49004.663149.827887@gargle.gargle.HOWL>
References: <3F43A0C4.E215B858@SteelEye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Paul Clements on Wednesday August 20
To: Paul Clements <Paul.Clements@SteelEye.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday August 20, Paul.Clements@SteelEye.com wrote:
> Neil,
> 
> I don't know if you've noticed this one yet, but it looks like we need
> to set the master_bio->bi_bdev field at the beginning of every resync
> request. We use this value later on in sync_request_write() to determine
> whether a write should take place on a particular device. Without the
> field being properly set, we will end up aborting the resync process.
> This happens because the master_bios are pulled from a pool, so we
> eventually end up getting a master_bio that already has our destination
> disk set in its bi_bdev field. This causes sync_request_write() to fail
> since it thinks there is nowhere to write the data to. 

Thanks.  Your analysis looks right.
However it raises a question:  why are we cloning a separate bio for
reading instead of jus using the "master bio" ???

I'll have a deeper look at raid1 in a few days and see what I can
find.

NeilBrown
