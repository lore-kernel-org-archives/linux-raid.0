From: Ross Vandegrift <ross@willow.seitz.com>
Subject: Re: Expanding size of existing raid1 md device
Date: Thu, 24 Apr 2003 17:02:19 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030424210219.GA5255@willow.seitz.com>
References: <Pine.LNX.4.33.0304241453110.8064-100000@router.windsormachine.com> <1051217554.2852.81.camel@pcary03q.ca.nortel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1051217554.2852.81.camel@pcary03q.ca.nortel.com>
To: Sean Kormilo <skormilo@nortelnetworks.com>
Cc: Mike Dresser <mdresser_l@windsormachine.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Apr 24, 2003 at 04:52:34PM -0400, Sean Kormilo wrote:
> I'd prefer to be able to do this without having to unmount or take down
> any of the filesystems on the box (it is an NFS server). I cannot think
> of a way to create a new set of arrays and switching to them without
> unmounting the filesystems.

I don't think there's a way to do this.  Not only would you have to
change to the new volume without unmounting the filesystems (seems
impossible), you'd be changing the filesystem out from under the NFS
server.  I'm willing to bet that won't go over well at all...


-- 
Ross Vandegrift
ross@willow.seitz.com

A Pope has a Water Cannon.                               It is a Water Cannon.
He fires Holy-Water from it.                        It is a Holy-Water Cannon.
He Blesses it.                                 It is a Holy Holy-Water Cannon.
He Blesses the Hell out of it.          It is a Wholly Holy Holy-Water Cannon.
He has it pierced.                It is a Holey Wholly Holy Holy-Water Cannon.
He makes it official.       It is a Canon Holey Wholly Holy Holy-Water Cannon.
Batman and Robin arrive.                                       He shoots them.
