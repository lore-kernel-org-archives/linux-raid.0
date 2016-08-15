From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: read errors with md RAID5 array
Date: Mon, 15 Aug 2016 16:59:37 +0200
Message-ID: <20160815145937.dsjtzpjdnwfpmxyv@metamorpher.de>
References: <78aab29c-9b7b-ff8b-f9c7-fab286f16243@buttersideup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <78aab29c-9b7b-ff8b-f9c7-fab286f16243@buttersideup.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tim Small <tim@buttersideup.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Aug 15, 2016 at 02:12:23PM +0100, Tim Small wrote:
> I'm seeing some strange read errors whilst reading from an md RAID5
> array (3x 2TB SATA Drives, Intel AHCI controller).

mdadm --examine and --examine-badblocks for all disks/partitions?

> One of the underlying devices is reporting some "pending sectors"

smartctl -a for all disks?

Regards
Andreas Klauer
