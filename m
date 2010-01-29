From: Neil Brown <neilb@suse.de>
Subject: Re: Zeroing multiple superblocks
Date: Fri, 29 Jan 2010 23:31:11 +1100
Message-ID: <20100129233111.5c9cc1d0@notabene>
References: <20100122200924.GA29183@psychosis.jim.sh>
	<20100125095221.GV21495@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100125095221.GV21495@skl-net.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: Jim Paris <jim@jtan.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 25 Jan 2010 10:52:21 +0100
Andre Noll <maan@systemlinux.org> wrote:

> On 15:09, Jim Paris wrote:
> 
> > I guess the only way to be fully safe with the current approach is to
> > do a zero-superblock over and over until it complains.
> 
> mdadm --zero-superblock tries to guess the location of the superblock.
> If more than one superblock is found, the one with the latest creation
> time is being zeroed. So yes, the method you describe works and I think
> it is the most reliable way to remove all superblocks of a device.
> 
> Maybe we could teach mdadm --zero-superblock to honor the --metadata=x
> option which would zero-out the region of the device where the
> version-x superblock is located.

Latest mdadm has this feature.
And if --metadata= isn't given, it repeatedly trying to find and zero a
superblock until no more superblocks can be found.

NeilBrown
