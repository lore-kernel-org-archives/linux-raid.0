From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: create failed raid5 disk with mdadm
Date: Sat, 29 May 2004 08:38:28 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16567.48996.202819.382152@cse.unsw.edu.au>
References: <Pine.LNX.4.44.0405281445550.25012-100000@signals10.bu.edu>
	<1087.153.90.196.102.1085772526.squirrel@web1.cs.montana.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Lucas Albers on Friday May 28
To: admin@cs.montana.edu
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday May 28, admin@cs.montana.edu wrote:
> I am trying to determine the syntax to create a raid5 volume with a single
> failed disk.
> I am converting the root parition of an existing system to raid5.
> I need to exclude one disk from the software raid setup.
> Then copy the data over.
> Then add in the excluded disk.
> 
> The synax to perform this operation on a raid 1 volume is:
> mdadm --create /dev/md1 --level=1 --raid-disks=2 missing /dev/hdg1
> 
> The same syntax to create a raid volume, does not appear to work:
> mdadm -v --create /dev/md2 --level=5 --raid-disks=4 -R  missing /dev/hdf2
> /dev/hdg2 /dev/hdh2

That certainly should work, and I just tried it and it did.

Could you describe the way in which it failed to work for you?  

NeilBrown

> 
> 
> Is their perhaps another way to perform the operation?
> 
> I can't find any additional documentation items on configure it.
> 
> 
> I am the author of the debian root software raid doc at:
> 
> (Howto Convert system to software raid using mdadm.)
> http://rootraiddoc.alioth.debian.org.
> 
> -- 
> Luke Computer Science System Administrator
> Security Administrator,College of Engineering
> Montana State University-Bozeman,Montana
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
