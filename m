From: Mike Dresser <mdresser_l@windsormachine.com>
Subject: Re: Expanding size of existing raid1 md device
Date: Thu, 24 Apr 2003 14:54:56 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.33.0304241453110.8064-100000@router.windsormachine.com>
References: <1051210082.2852.65.camel@pcary03q.ca.nortel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1051210082.2852.65.camel@pcary03q.ca.nortel.com>
To: Sean Kormilo <skormilo@nortelnetworks.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 24 Apr 2003, Sean Kormilo wrote:

> I'd like to be able to upgrade the system to use 36GB disks, such that
> the /dev/md1 partition expands to take up the rest of the additional
> space provided by the 36GB disk.

Out of curiosity, and judging from the size of your disks, this is a scsi
system.

Can you create a new set of arrays on the 36's, and just copy the data
over from the 18's?

Mike

