From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Confused about UUID mounting and mirrors
Date: Sun, 22 Jun 2008 16:05:36 -0400
Message-ID: <485EB090.9070006@tmr.com>
References: <4856A8C6.3030609@kmaclub.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4856A8C6.3030609@kmaclub.com>
Sender: linux-raid-owner@vger.kernel.org
To: "michael@kmaclub.com" <michael@kmaclub.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

michael@kmaclub.com wrote:
> Hello,
>
> I am making the transition from hardware raid to software raid and 
> things have gone pretty well.
>
> I am trying to mount everything by UUID to account for devices moving 
> around, etc.
>
> I have moved all mounts in /etc/fstab to uuid except /boot which is a 
> mirror sitting on /dev/md0.
>
> Since it is a mirror, blkid returns the same uuid for /dev/md0, 
> /dev/sda1, and /dev/sdb1.
>
> This confuses mount at boot time.
>
> How to I get it to correctly find md0 and not the components of the 
> mirror?

After reading the whole thread, I'm not sure anyone has explained what's 
happening. Te reason for using a UUID is to get a mount to work even 
when the path to data changes dues to physical device renaming. However, 
it's perfectly safe to mount bd devices by device name, providing that 
the UUID is used in the mdadm.conf file to assure that the right 
physical components are using in the md device.

There may also be come confusion due to two kinfs of UUID, the one for 
the filesystem, which you know is replicated on all mirrors, and the one 
on the md array, which is used to assemble to array. So if you use the 
array UUID in tour mdadm.conf file, the name of the array will remain 
constant, and you can safely use that for mounting.

As you have been told, the tools are supposed to be smart enough to use 
the filesystem on the md array and not on the components when a 
filesystem UUID is in the fstab. But you have found the hard way that 
this is not always going to work correctly, due to factors I haven't 
identified yet, other than "every once in a while this ***'s up!"

I'm not making a recommendation, just trying to clarify what's happening 
and why.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


