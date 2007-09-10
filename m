From: "J. David Beutel" <jdb@getsu.com>
Subject: Re: reducing the number of disks a RAID1 expects
Date: Sun, 09 Sep 2007 21:31:54 -1000
Message-ID: <46E4F2EA.3020901@getsu.com>
References: <46E49991.9000000@getsu.com> <46E4AC1A.3010509@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <46E4AC1A.3010509@sauce.co.nz>
Sender: linux-raid-owner@vger.kernel.org
To: Richard Scobie <richard@sauce.co.nz>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Richard Scobie wrote:
> Have a look at the "Grow Mode" section of the mdadm man page.

Thanks!  I overlooked that, although I did look at the man page before 
posting.

> It looks as though you should just need to use the same command you 
> used to grow it to 3 drives, except specify only 2 this time.

I think I hot-added it.  Anyway, --grow looks like what I need, but I'm 
having some difficulty with it.  The man page says, "Change the size or 
shape of an active array."  But I got:

[root@samue ~]# mdadm --grow /dev/md5 -n2
mdadm: Cannot set device size/shape for /dev/md5: Device or resource busy
[root@samue ~]# umount /dev/md5
[root@samue ~]# mdadm --grow /dev/md5 -n2
mdadm: Cannot set device size/shape for /dev/md5: Device or resource busy

So I tried stopping it, but got:

[root@samue ~]# mdadm --stop /dev/md5
[root@samue ~]# mdadm --grow /dev/md5 -n2
mdadm: Cannot get array information for /dev/md5: No such device
[root@samue ~]# mdadm --query /dev/md5 --scan
/dev/md5: is an md device which is not active
/dev/md5: is too small to be an md component.
[root@samue ~]# mdadm --grow /dev/md5 --scan -n2
mdadm: option s not valid in grow mode

Am I trying the right thing, but running into some limitation of my 
version of mdadm or the kernel?  Or am I overlooking something 
fundamental yet again?  md5 looked like this in /proc/mdstat before I 
stopped it:

md5 : active raid1 hdc8[2] hdg8[1]
      58604992 blocks [3/2] [_UU]

For -n the man page says, "This  number can only be changed using --grow 
for RAID1 arrays, and only on kernels which provide necessary support."

Grow mode says, "Various types of growth may be added during 2.6  
development, possibly  including  restructuring  a  raid5 array to have 
more active devices. Currently the only support available is to change 
the "size" attribute for  arrays  with  redundancy,  and  the raid-disks 
attribute of RAID1 arrays.  ...  When  reducing the number of devices in 
a RAID1 array, the slots which are to be removed from the array must 
already be vacant.  That is, the devices that which were in those slots 
must be failed and removed."

I don't know how I overlooked all that the first time, but I can't see 
what I'm overlooking now.

mdadm - v1.6.0 - 4 June 2004
Linux 2.6.12-1.1381_FC3 #1 Fri Oct 21 03:46:55 EDT 2005 i686 athlon i386 
GNU/Linux

Cheers,
11011011
