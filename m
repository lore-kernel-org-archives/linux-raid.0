From: Neil Brown <neilb@suse.de>
Subject: Re: RAID5 problem
Date: Mon, 5 Dec 2005 08:49:13 +1100
Message-ID: <17299.25689.258895.886749@cse.unsw.edu.au>
References: <200512042128.jB4LSwef010890@cichlid.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Andrew Burgess on Sunday December 4
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Burgess <aab@cichlid.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday December 4, aab@cichlid.com wrote:
> 
> PS to Neil. I thought I might submit a patch to you that added a little 
> more info the the above lines, the slot number and the raid device
> 
> So it would read:
> 
> mdadm: /dev/hdc3 appears to be part of a raid array:
>      /dev/md0 slot[1] level=5 devices=4 ctime=Fri May 30 14:25:47 2003
> 
> I find this to be information that I have to search for using 'mdadm -E' so it
> would be handy to see it all at once when having to force a broken array to
> assemble.
> 
> Also it would be handy to see the update time rather than the creation time
> (IMHO) so I can see how far apart the devices are (or maybe the event count
> would be better for this) and whether or not the device was marked 'clean'.
> 
> What do you think?

Sounds reasonable - just send that patch.

NeilBrown
