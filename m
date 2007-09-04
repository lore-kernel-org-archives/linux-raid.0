From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: MDADM restart at system boot time
Date: Wed, 05 Sep 2007 10:52:27 +1200
Message-ID: <46DDE1AB.6010507@sauce.co.nz>
References: <8f2c1194b4839dee2ea49eedfeaf783a@7digital.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8f2c1194b4839dee2ea49eedfeaf783a@7digital.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Paul wrote:
> Hi,
>  
> I hope someone can help.
>  
> I have manually installed mdadm and now have a working array. I installed mdadm from the tarball, then did 'make install'
>  
> My problem is after system reboot the array will not start as the daemon is not running, I guess.
>  
> In order to access my files I have to re-create the array, which it complains about and then re-mount the disks, via the usual 'mount /dev/md0 /data', I know this 'mount' can be done via fstab, but I need the first part to work first.
>  
> I have the following info in my mdadm.conf file:
> 
> DEVICE /dev/hdb1 /dev/hdc1
> ARRAY /dev/md0 level=raid1 num-devices=2 UUID=0f0e3d1f:52580ad4:2ef6a2e7:f760e130
>         devices=/dev/hdb1,/dev/hdc1

Apologies, I was slightly incorrect on the last part.

Replace the "DEVICE" entry with:

DEVICE partitions

and add

auto=part

in place of the "devices=/dev/hdb1,/dev/hdc1" section at
the end of your ARRAY entry.


Regards,

Richard


