From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: mdadm create size problem
Date: Tue, 24 May 2005 09:43:20 +1000
Message-ID: <17042.27288.218077.374407@cse.unsw.edu.au>
References: <4277825A.1070405@cc.kuleuven.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Herta Van den Eynde on Tuesday May 3
Sender: linux-raid-owner@vger.kernel.org
To: Herta Van den Eynde <herta.vandeneynde@cc.kuleuven.be>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday May 3, herta.vandeneynde@cc.kuleuven.be wrote:
(sorry for the delay in looking at this).

> Red Hat AS 2.1 mdadm 1.11
> I have two devices that used to be part of a now corrupt RAID10 
> configuration.  When I try to reuse them to create a RAID1, it only uses 
> about 1 third of the diskspace available.
> # fdisk -l /dev/sdg
> 
> Disk /dev/sdg: 255 heads, 63 sectors, 8924 cylinders
> Units = cylinders of 16065 * 512 bytes
...
> mdadm: size set to 139904K
> Continue creating array? n

Yep, there is a bug in 1.11.0.
In Create.c, line 209,
		else {
			ldsize = dsize;
			dsize <<= 9;
		}
should be
		else {
			ldsize = dsize;
			ldsize <<= 9;
		}

It only affects systems where ioctl(BLKGETSIZE64) doesn't exist or
fails.

> 
> If I try to add the --size option, even a size that is 139904K or less, 
> it tells me the size is invalid:
> 
> # mdadm --create --verbose /dev/md5 --level=1 --raid-devices=2 /dev/sdg 
> /dev/sdn --size=139904K
> mdadm: invalid size: 139904K

size should be a simple integer, no suffix, and it wouldn't let you
create an array using more space than it thinks exists anyway.


I guess it is time for a 1.12 ??

NeilBrown
