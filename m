From: "Jeff Gray" <jeffgray@hotmail.com>
Subject: RAID 1 strategy
Date: Mon, 01 Mar 2004 22:29:45 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Law11-F90gS86aRZlz800019605@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi everyone. From reading this mailing list's archives I've seen a number of 
individuals
implement Linux software RAID 1 arrays on pairs of several partitions. I 
would like to
know if it's feasible to create one single RAID 1 array which spans the 
entire size of
the drives but have smaller partitions within the array for /, swap and a 
big LVM
container for /var, /tmp, /usr and /home. Currently I'm considering having 
separate
RAID1 arrays for /, swap and a huge array for the LVM section. I've seen 
this
configuration being mentioned before but I think it would be simpler to have 
one
big RAID1 array container instead.

Are there any advantages to having separate arrays instead of one big one? 
Obviously
the smaller ones would sync faster but what about actual performance once 
the OS
has booted? Thank you all in advance.

Kind Regards,
Jeff Gray.

_________________________________________________________________
FREE pop-up blocking with the new MSN Toolbar – get it now! 
http://clk.atdmt.com/AVE/go/onm00200415ave/direct/01/

