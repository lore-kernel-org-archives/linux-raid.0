From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: restore 3disk raid5 after raidpartitions have been setup with
 xfs filesystem by accident
Date: Wed, 21 Sep 2016 22:56:15 +0200
Message-ID: <20160921205615.GC6949@metamorpher.de>
References: <CAKA=zHqbFv_RQvyR4o4HPS2UrP4xrRWLiy2nR+gudDguk+JLog@mail.gmail.com>
 <CAJCQCtR4NoCebcDLD-ovT+hZY=NKRtj1cP693wHQTbmiERDAXw@mail.gmail.com>
 <CAKA=zHpgVoNA5Y6MBmB4fnG85F-z=hj4FXEiUOggsWUn3tfWXg@mail.gmail.com>
 <20160921171511.GA6381@metamorpher.de>
 <CAKA=zHq7OgZ+oVAqn7zVmBM0gSQedNk2kZ3dkuBG7V89G-G3Rg@mail.gmail.com>
 <20160921180318.GA6633@metamorpher.de>
 <CAKA=zHoJu2vTXQa4yvbJDA2nmQwXLHyw2DfUJ+cVgTDr_gu2XQ@mail.gmail.com>
 <20160921190035.GA6949@metamorpher.de>
 <CAKA=zHryc+hqie_VZDsU4HGQP9Cw7Oo_J3S4mjJHyZbGX1K1PA@mail.gmail.com>
 <CAKA=zHoKE69Q01oEVOCpKWzp6gQ7zO8rvY=NzuD0YoqLJdgTTQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKA=zHoKE69Q01oEVOCpKWzp6gQ7zO8rvY=NzuD0YoqLJdgTTQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Simon Becks <beckssimon5@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Sep 21, 2016 at 10:41:32PM +0200, Simon Becks wrote:
> So the filesystem on the raid is/was XFS.  gave xfs_repair a shot but
> it segfaults:
> 
> i guess thats good, that it found at least the superblock?

Although I use XFS myself I'm not too familiar with its repair facilities.
If you're *sure* the RAID is set up correctly - in this case photorec 
should be able to find something larger than 512K*3 that is valid - 
and still have XFS repair issues maybe the XFS list can help there.

Regards
Andreas Klauer
