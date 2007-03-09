From: Neil Brown <neilb@suse.de>
Subject: Re: Changing partition types safe? raidtools to mdadm migration
Date: Fri, 9 Mar 2007 18:02:24 +1100
Message-ID: <17905.1664.655065.164818@notabene.brown>
References: <40b437200703082239s3d54df30n3b0f542f03770ad7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Simon Matthews on Thursday March 8
Sender: linux-raid-owner@vger.kernel.org
To: Simon Matthews <simon.d.matthews@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday March 8, simon.d.matthews@gmail.com wrote:
> I have a working RAID1 set. This is in a Gentoo system and I
> configured the RAID set using raidtools. I see that Raidtools are now
> deprecated in favor of mdadm.
> 
> I installed mdadm, but it does not recognize my raid set. I tried the
> following command (note that my RAID set is active while I do this):
> $   mdadm /dev/md0 --query --detail

Try
  mdadm --detail /dev/md0

If that doesn't work, what about
  cat /proc/mdadm

> 
> This results in no output.  I believe this is because I forgot to
> change the partition types on the partitions that make up the RAID set
> (/dev/sda1 and /dev/sdb1) to type fd (they are the default type 82).

It has nothing to do with partition types.

> 
> Can I safely change the partition types to fd on the partions that
> make up my RAID set?

It is perfectly safe to change partition type.

NeilBrown
