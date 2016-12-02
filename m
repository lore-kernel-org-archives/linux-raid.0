From: Shaohua Li <shli@kernel.org>
Subject: Re: clustered MD - beyond RAID1
Date: Fri, 2 Dec 2016 12:02:20 -0800
Message-ID: <20161202200220.z3aoy7ulehwgpcss@kernel.org>
References: <CAB9NSeV2A+BZzUbzj516e24CL05k6zF6tgZ+vpNptSO30ipyug@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAB9NSeV2A+BZzUbzj516e24CL05k6zF6tgZ+vpNptSO30ipyug@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Robert Woodworth <robertjwoodworth@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Dec 02, 2016 at 11:12:52AM -0700, Robert Woodworth wrote:
> Excuse me for being late to the party on this subject, but is the idea of
> clustered RAID5/6 alive or dead?
> 
> I have a need for such a feature. I'm in development on SAS JBODs with
> large drive counts, 60 and 90 drives per JBOD. We would like to support
> multi-host connectivity in an active/active fashion with MD RAID60.  This
> clustered MD RAID can and should be a nice alternative to HW RAID solutions
> like LSI/Avago "Syncro" MegaRAID.
> 
> I currently have the hardware and time to help develop and test the
> clustered RAID5/6.
> I just finished up building a test cluster of 2 nodes with the cluster-md
> RAID1.  Worked fine with gfs2 on top.
> 
> 
> My current real job is firmware on these SAS JBODS. I have many years of
> Linux experience and have developed (years ago) some kernel modules for a
> custom FPGA based PCIe cards.

It makes a lot of sense to me and no reason we don't support it, and especially
you have real usage of it. If anybody wants to implement it, I'm very glad to
help/review patches.

Thanks,
Shaohua
