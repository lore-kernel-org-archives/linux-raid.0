From: Neil Brown <neilb@suse.de>
Subject: Re: raid1 mysteriously switching to read-only
Date: Sat, 10 Dec 2005 19:02:33 +1100
Message-ID: <17306.35737.880103.939683@cse.unsw.edu.au>
References: <20051128102824.14498.patches@notabene>
	<1051127234104.14937@suse.de>
	<ee0ae26a0512092241v3ee5e445r@mail.gmail.com>
	<17306.31969.240202.416327@cse.unsw.edu.au>
	<ee0ae26a0512092350k43b6dc8l@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Yanggun on Saturday December 10
Sender: linux-raid-owner@vger.kernel.org
To: Yanggun <yang.geum.seok@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday December 10, yang.geum.seok@gmail.com wrote:
> I am sorry because there is no information very.
> 
> I currently ext3 file system.
> 
> I composed RAID-1(/dev/md0)  disk array by order such as lower part.
> 
> mkfs.ext3 -j /dev/sda1
> mkfs.ext3 -j /dev/sda1
> mdadm -Cv /dev/md0 --level=1 --raid-devices=2 /dev/sda1 /dev/sdb1

This is not the way raid1 works.
The raid1 array /dev/md0 will be slightly smaller than either sda1 or
sdb1.  So the filesystem will 'think' it is the size of sda1, will
eventually discover it is smaller, and will fail.
You should:
  mdadm -Cv /dev/md0 --level=1 --raid-devices=2 /dev/sda1 /dev/sdb1
  mkfs.ext3 -j /dev/md0
  mount /dev/md0 /data/disk1

and THEN use the filesystem.
NeilBrown
