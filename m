From: Frank van Maarseveen <frankvm@frankvm.com>
Subject: Re: Spares and partitioning huge disks
Date: Sat, 8 Jan 2005 15:52:28 +0100
Message-ID: <20050108145228.GB26475@janus>
References: <crmt7e$8d6$1@sea.gmane.org> <200501072157.j07Lvg906301@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200501072157.j07Lvg906301@www.watkins-home.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guy <bugzilla@watkins-home.com>
Cc: 'Mario Holbe' <Mario.Holbe@TU-Ilmenau.DE>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Jan 07, 2005 at 04:57:35PM -0500, Guy wrote:
> His plan is to split the disks into 6 partitions.
> Each of his six RAID5 arrays will only use 1 partition of each physical
> disk.
> If he were to lose a disk, all 6 RAID5 arrays would only see 1 failed disk.
> If he gets 2 read errors, on different disks, at the same time, he has a 1/6
> chance they would be in the same array (which would be bad).
> His plan is to combine the 6 arrays with LVM or a linear array.

Intriguing setup. Do you think this actually improves the reliability
with respect to disk failure compared to creating just one large RAID5
array?

For one second I thought it's a clever trick but gut feeling tells
me the odds of losing the entire array won't change (simplified --
because the increased complexity creates room for additional errors).

-- 
Frank
