From: "Sean Kormilo" <skormilo@nortelnetworks.com>
Subject: RE: cluster RAID
Date: 26 May 2003 08:25:25 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1053951924.3017.9.camel@pcary03q.ca.nortel.com>
References: <16080.41341.194808.277607@notabene.cse.unsw.edu.au>
	 <000d01c322b3$f6c853c0$3200a8c0@nimiak>
	 <16081.44989.20972.940840@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16081.44989.20972.940840@notabene.cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: Kai-Min Sung <k@kaisung.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Kai,

This sounds like a job for either OpenGFS or DRBD.
http://opengfs.sourceforge.net/
http://www.complang.tuwien.ac.at/reisner/drbd/

Sean.

> On Sunday May 25, k@kaisung.com wrote:
> > Hi Neil,
> > 	I should probably elaborate a little more on my envisioned
> > setup. I'd like to setup a RAID array using shared disks, then run LVM
> > on top of the RAID array to carve out logical volumes. The logical
> > volumes would be used by one node at a time (no data sharing). For both
> > nodes to access the same LVM metadata, they must both activate the RAID
> > array. It seemed like someone had done something similar here:
> > 
> > http://marc.theaimsgroup.com/?l=linux-raid&m=98834623209225&w=2
> > 
> > Concerning the checksums, I was referring to the checksum output when I
> > run mdadm --examine on a RAID disk. I thought that was a checksum of all
> > the data blocks of the disk, but I guess not? So, basically the only
> > time you can guarantee a RAID array is consistent is once it's been
> > deactivated and the dirty flag cleared in the superblock?
> 
> It isn't clear what the auther of the refered mail is really doing,
> but I stand by my position that this cannot work.
> 
> A raid array is not just a bunch of discs.  It is also a controller.
> With Linux Soft raid, that controller is a computer running Linux.  
> In the case of hardware raid, it might be an embeded system on a board
> somewhere.  But there is still a single controller.
> 
> It probably would not be impossible to arrange a soft RAID system
> where separate controller (Linux systems) could co-operate and manage
> separate parts of the array, but it would be a lot of work.
> 
> 
> The checksum is the checksum of the superblock, not the whole array.
> Yes.  Yoo can only guarantee consustency if the dirty flag is clear.
> 
> NeilBrown
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 

Sean C. Kormilo, STORM Software Architect, Nortel Networks
              email: skormilo@nortelnetworks.com
  

