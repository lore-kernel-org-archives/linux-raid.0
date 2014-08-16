From: mdraid.pkoch@dfgh.net (Peter Koch)
Subject: Re: RAID10-shrink does not work
Date: Sat, 16 Aug 2014 10:29:30 +0200
Message-ID: <201408160829.s7G8TU4J025910@portal.naev.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: 
References: 
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Neil,

> > Unfortunately shrinking the raid10-array back to 13 devices
> > does not work:
> > 
> > # mdadm --grow /dev/md5 --array-size 12696988928
> > # mdadm --grow /dev/md5 --raid-devices=13
> > mdadm: Cannot set array shape for /dev/md5
>
> Where did you get that array-size from?  It isn't a multiple
> of 512K.  Hence the chunksize setting reports an error.

mdadm told me to use this :-)

Here's what I did:

# mdadm --detail /dev/md5
..
     Array Size : 15627063296 (14903.13 GiB 16002.11 GB)
  Used Dev Size : 1953382912 (1862.89 GiB 2000.26 GB)
   Raid Devices : 16
..

Note: 15627063296 = 1953382912 * 16 / 2

Now if I reduce the number of devices to 13 mdadm complains
about the array-size and suggests a value to use:

# mdadm --grow /dev/md5 --raid-devices=13
mdadm: this change will reduce the size of the array.
       use --grow --array-size first to truncate array.
       e.g. mdadm --grow /dev/md5 --array-size 12696988928

mdadm calculates the new array-size from the componentsize
by multiplying it with 13 and dividing it by 2:
newarraysize = componentsize * 13 / copies

While the old array-size is a multiple of 512 the new is not.
So I truncated the array to the size of the underlying
filesystem (which is 12696988672K, a multiple of 512K)
and that worked.

Thanks again for your support

Peter
