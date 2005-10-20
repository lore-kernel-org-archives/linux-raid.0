From: Gregory Seidman <gsslist+linuxraid@anthropohedron.net>
Subject: Re: Best way to achieve large, expandable, cheap storage?
Date: Thu, 20 Oct 2005 07:19:50 -0400
Message-ID: <20051020111943.GA9757@anthropohedron.net>
References: <dhje16$tmq$1@sea.gmane.org> <433F63BB.3020008@nighthawkrad.net> <7f55de720510030933k26608cfsda63326a8438e35d@mail.gmail.com> <43420091.9060601@nighthawkrad.net> <43577022.5010306@robinbowes.com>
Reply-To: gsslist+linuxraid@anthropohedron.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <43577022.5010306@robinbowes.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Oct 20, 2005 at 11:23:30AM +0100, Robin Bowes wrote:
} Christopher Smith said the following on 04/10/2005 05:09:
} >Yep, that's pretty much bang on.  The only thing you've missed is using 
} >pvmove to physically move the data off the soon-to-be-decomissioned 
} >PVs(/RAID arrays).
} >
} >Be warned, for those who haven't used it before, pvmove is _very_ slow.
} 
} I've just been re-reading this thread.
} 
} I'd like to just check if I understand how this will work.
} 
} Assume the following setup (hypothetical).
} 
} VG:
} big_vg - contains /dev/md1, /dev/md2; 240GB
} 
} PV:
} /dev/md1 - 4 x 40GB drives (RAID5 - 120GB total)
} /dev/md2 - 4 x 40GB drives (RAID5 - 120GB total)

You should at least read the following before using RAID5. You can agree or
disagree, but you should take the arguments into account:

http://www.miracleas.com/BAARF/RAID5_versus_RAID10.txt

} LV:
} big_lv - in big_vg - 240GB
} 
} Filesystems:
} /home - xfs filesystem in big_lv - 240GB
} 
} Suppose I then add a new PV:
} /dev/md3 - 4 x 300GB drives (RAID5 - 900GB total)

You use pvcreate and vgextend to do so, incidentally.

} I want to replace /dev/md1 with /dev/md3
} 
} I use pvmove something like this:
} 
} # pvmove /dev/md1 /dev/md3
} 
} When this finishes, big_vg will contain /dev/md2 + /dev/md3 (1020GB 
} total). /dev/md1 will be unused.

/dev/md1 will still be a part of big_vg, but it won't have any data from
any LVs on it. You will need to use vgreduce to remove /dev/md1 from the
VG:

# vgreduce big_vg /dev/md1

} big_lv will still be using just 240GB of big_vg.
} 
} I then use lvextend to increase the size of big_lv
} 
} big_lv will now use all 1020GB of big_vg.
} 
} However, the /home filesystem will still just use 240GB of big_lv
} 
} I can then use xfs_growfs to expand the /home filesystem to use all 
} 1020GB of big_lv.

All correct.

} Have I missed anything?

Just the vgreduce step (and removing the physical drives that make up
/dev/md1).

} R.
--Greg

