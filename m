From: Scott McDermott <vaxerdec@frontiernet.net>
Subject: Re: Expanding size of existing raid1 md device
Date: Thu, 24 Apr 2003 17:25:42 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030424172542.B17124@newbox.localdomain>
References: <Pine.LNX.4.33.0304241453110.8064-100000@router.windsormachine.com> <1051217554.2852.81.camel@pcary03q.ca.nortel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1051217554.2852.81.camel@pcary03q.ca.nortel.com>; from skormilo@nortelnetworks.com on Thu, Apr 24, 2003 at 04:52:34PM -0400
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Sean Kormilo on Thu 24/04 16:52 -0400:
> I'd prefer to be able to do this without having to unmount
> or take down any of the filesystems on the box (it is an
> NFS server).

As long as your clients have hard-mounted your NFS server,
they will just block until the server comes back up and
nothing untoward will happen.  As long as you keep all your
inode and device numbers the same (eg, don't make a new FS,
grow the one you have in place), there should be no
problems.  This will work fine if you just take the system
down, grow the array to whatever you like (same major/minor
nums, which are part of NFS cookie I think), then grow the
filesystem with resize2fs, and bring the server back up.
