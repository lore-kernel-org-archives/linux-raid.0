From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 00/53] External Metadata Reshape
Date: Mon, 29 Nov 2010 15:07:30 +1100
Message-ID: <20101129150730.65085e26@notabene.brown>
References: <20101126075407.5221.62582.stgit@gklab-170-024.igk.intel.com>
	<20101129143224.0619ed5f@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101129143224.0619ed5f@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

On Mon, 29 Nov 2010 14:32:24 +1100 Neil Brown <neilb@suse.de> wrote:

> 6/ mdmon assigns spares as appropriate and tells the kernel which slot to use
>    for each.  This requires a kernel change.  The slot number will be stored
>    in saved_raid_disk.  ping_monitor doesn't complete until the spares have
>    been assigned.

Actually, this doesn't require a kernel change.  We've had this functionality
since 2.6.26 - commit  6c2fce2ef6b4821c21b5c42c7207cb9cf8c87eda

If you add a spare to an array while sync_action is frozen, and then set
   /sys/block/mdXX/md/dev-YYY/slot
to some number, it will move that device to fill that slot.
Then when you start a reshape (or whatever) it will leave the device in that
slot and 'do the right thing'.

So the "Verify slots in meta against slot numbers set by md" shouldn't be
needed.  mdmon can explicitly request a slot number, and md will honour that.

Or have you tried that and found it doesn't work for some reason???

NeilBrown

