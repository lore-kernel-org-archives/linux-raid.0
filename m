From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: RE: Which (physical) disk is broken?
Date: Thu, 23 Dec 2004 10:10:51 +1100
Message-ID: <16841.65275.437988.190177@cse.unsw.edu.au>
References: <87ekhj6h88.fsf@pumba.bayour.com>
	<41C96563.11124.597BE49@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Michael on Wednesday December 22
Sender: linux-raid-owner@vger.kernel.org
To: michael@insulin-pumpers.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday December 22, michael@insulin-pumpers.org wrote:
> <snip>
> > Use a command like this to cause your disks to have activity, then look for
> > the blinking lights:
> > dd if=/dev/md/1 of=/dev/null bs=64k
> > 
> 
> Oh swell!.... I have one blinking light for ALL the disks on all 12 of 
> our raid systems. There has to be a better way.


There are really only two ways:

 1/ make lights blinks.
 2/ have labels on the front of each bay saying what SCSI (or
    whatever) ID the device has.

If your storage array does not have per-device lights, or per-device
labels, you should speak sternly to your hardware provider.

NeilBrown
