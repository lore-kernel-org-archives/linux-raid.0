From: Neil Brown <neilb@suse.de>
Subject: Re: How to determine drive order in RAID-1
Date: Tue, 16 Oct 2007 10:23:41 +1000
Message-ID: <18196.1165.638769.133714@notabene.brown>
References: <4713FB47.1010507@charter.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jeffrey B. Layton on Monday October 15
Sender: linux-raid-owner@vger.kernel.org
To: laytonjb@charter.net
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday October 15, laytonjb@charter.net wrote:
> Good evening,
> 
> I hate to be a noob, but my system is dying (I think it's a bad
> motherboard) so I wanted to get this email out before the system
> died again.
> 
> I've got 2 different RAID-1 devices (md0 and md1). md0 uses
> the on-board IDE controller and md1 has two SATA drives
> each is attached to a Promise SATA300 TX2 controller
> (one drive to one controller). Is there anyway to determine
> which drive is the first drive in the md device and which is
> the second.

There is no "first" or "second".  There are just two drives.

> 
> The reason I want to determine this is that I will be moving
> the drives to a new system. Or does it matter in which order
> they are moved? (the OS drive is moving over as well).

No, it does not matter.

NeilBrown
