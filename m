From: "Simon Matthews" <simon.d.matthews@gmail.com>
Subject: Re: Changing partition types safe? raidtools to mdadm migration
Date: Thu, 8 Mar 2007 23:20:02 -0800
Message-ID: <40b437200703082320t8daee7bp3ae3883b978e9cc9@mail.gmail.com>
References: <40b437200703082239s3d54df30n3b0f542f03770ad7@mail.gmail.com>
	 <17905.1664.655065.164818@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17905.1664.655065.164818@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil,


On 3/8/07, Neil Brown <neilb@suse.de> wrote:
> On Thursday March 8, simon.d.matthews@gmail.com wrote:
> > I have a working RAID1 set. This is in a Gentoo system and I
> > configured the RAID set using raidtools. I see that Raidtools are now
> > deprecated in favor of mdadm.
> >
> > I installed mdadm, but it does not recognize my raid set. I tried the
> > following command (note that my RAID set is active while I do this):
> > $   mdadm /dev/md0 --query --detail
>
> Try
>   mdadm --detail /dev/md0

Looks good:

# mdadm --detail /dev/md0
/dev/md0:
        Version : 00.90.03
  Creation Time : Sat Oct 15 16:20:52 2005
     Raid Level : raid1
     Array Size : 198153664 (188.97 GiB 202.91 GB)
  Used Dev Size : 198153664 (188.97 GiB 202.91 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Thu Mar  8 23:15:38 2007
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

           UUID : de2ca4d0:7a3f6d57:d6751dc4:a51265e3
         Events : 0.12491522

    Number   Major   Minor   RaidDevice State
       0       8       18        0      active sync   /dev/sdb2



>
> If that doesn't work, what about
>   cat /proc/mdadm
>
> >
> > This results in no output.  I believe this is because I forgot to
> > change the partition types on the partitions that make up the RAID set
> > (/dev/sda1 and /dev/sdb1) to type fd (they are the default type 82).
>
> It has nothing to do with partition types.
>
> >
> > Can I safely change the partition types to fd on the partions that
> > make up my RAID set?
>
> It is perfectly safe to change partition type.

So I should be safe in just removing the raidtools package and
installing mdadm?

Regards,
Simon
