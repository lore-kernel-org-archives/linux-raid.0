From: "Sean Kormilo" <skormilo@nortelnetworks.com>
Subject: Re: Expanding size of existing raid1 md device
Date: 24 Apr 2003 16:52:34 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1051217554.2852.81.camel@pcary03q.ca.nortel.com>
References: <Pine.LNX.4.33.0304241453110.8064-100000@router.windsormachine.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.33.0304241453110.8064-100000@router.windsormachine.com>
To: Mike Dresser <mdresser_l@windsormachine.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Mike,

Again, I probably wasn't clear enough in my first request...

I'd prefer to be able to do this without having to unmount or take down
any of the filesystems on the box (it is an NFS server). I cannot think
of a way to create a new set of arrays and switching to them without
unmounting the filesystems.

Sean.


> On 24 Apr 2003, Sean Kormilo wrote:
> 
> > I'd like to be able to upgrade the system to use 36GB disks, such that
> > the /dev/md1 partition expands to take up the rest of the additional
> > space provided by the 36GB disk.
> 
> Out of curiosity, and judging from the size of your disks, this is a scsi
> system.
> 
> Can you create a new set of arrays on the 36's, and just copy the data
> over from the 18's?
> 
> Mike
-- 

Sean C. Kormilo, STORM Software Architect, Nortel Networks
              email: skormilo@nortelnetworks.com
  

