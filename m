From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: RAID10 vs. LVM on RAID1
Date: Wed, 24 Aug 2005 10:05:34 +1000
Message-ID: <17163.47566.348423.869060@cse.unsw.edu.au>
References: <20050822213100.GA6165@anthropohedron.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Gregory Seidman on Monday August 22
Sender: linux-raid-owner@vger.kernel.org
To: gsslist+linuxraid@anthropohedron.net
Cc: Linux RAID list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Monday August 22, gsslist+linuxraid@anthropohedron.net wrote:
> Is there any advantage to RAID10 over creating an LVM volume group across
> the same number of RAID1 pairs? LVM does striping, after all. Am I
> overlooking something?

There are certainly some situations where 'raid10' and 'LVM over
raid1' provide essentially the same service, so you probably choose
whichever you are familiar with.
There are also situations where one or the other provides better
service. 

Advantages of LVM over raid1:
 -  If you want to use LVM for general logical volume management
    (growing volumes seamlessly), then it probably makes sense to use
    LVM over raid1.
 -  The various raid1 pairs can be different sizes.

Advantages of RAID10:
 - single integrated system - only one tool to use.
 - One hot spare can service the whole array (though the spare-group
   function of mdadm can support this in the other case too).
 - A raid10 can consist of an odd number of drives (if you have a
   cabinet with, say, 8 slots, you can have 1 hot spare, and 7 drives 
   in a raid10.  You cannot do that with LVM (or raid0) over raid1).
 - raid10 has a layout ('far') which theoretically can provide
   sequential read throughput that scales by number of drives, rather
   than number of raid1 pairs.  I say 'theoretically' because I think
   there are still issues with the read-balancing code that make this
   hard to get in practice (though increasing the read-ahead seems to
   help). 

So, choose the setup which best meets your needs.

NeilBrown
