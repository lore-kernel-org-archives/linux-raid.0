From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: RE: cluster RAID
Date: Mon, 26 May 2003 16:10:05 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16081.44989.20972.940840@notabene.cse.unsw.edu.au>
References: <16080.41341.194808.277607@notabene.cse.unsw.edu.au>
	<000d01c322b3$f6c853c0$3200a8c0@nimiak>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Kai-Min Sung on Sunday May 25
To: Kai-Min Sung <k@kaisung.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday May 25, k@kaisung.com wrote:
> Hi Neil,
> 	I should probably elaborate a little more on my envisioned
> setup. I'd like to setup a RAID array using shared disks, then run LVM
> on top of the RAID array to carve out logical volumes. The logical
> volumes would be used by one node at a time (no data sharing). For both
> nodes to access the same LVM metadata, they must both activate the RAID
> array. It seemed like someone had done something similar here:
> 
> http://marc.theaimsgroup.com/?l=linux-raid&m=98834623209225&w=2
> 
> Concerning the checksums, I was referring to the checksum output when I
> run mdadm --examine on a RAID disk. I thought that was a checksum of all
> the data blocks of the disk, but I guess not? So, basically the only
> time you can guarantee a RAID array is consistent is once it's been
> deactivated and the dirty flag cleared in the superblock?

It isn't clear what the auther of the refered mail is really doing,
but I stand by my position that this cannot work.

A raid array is not just a bunch of discs.  It is also a controller.
With Linux Soft raid, that controller is a computer running Linux.  
In the case of hardware raid, it might be an embeded system on a board
somewhere.  But there is still a single controller.

It probably would not be impossible to arrange a soft RAID system
where separate controller (Linux systems) could co-operate and manage
separate parts of the array, but it would be a lot of work.


The checksum is the checksum of the superblock, not the whole array.
Yes.  Yoo can only guarantee consustency if the dirty flag is clear.

NeilBrown
