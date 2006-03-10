From: Neil Brown <neilb@suse.de>
Subject: Re: when --add after a fail?
Date: Fri, 10 Mar 2006 21:37:33 +1100
Message-ID: <17425.22253.896718.826151@cse.unsw.edu.au>
References: <20060301091857.GA8817@casa.e-den.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Sandro Dentella on Wednesday March 1
Sender: linux-raid-owner@vger.kernel.org
To: Sandro Dentella <sandro@e-den.it>
Cc: Linux Raid List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wednesday March 1, sandro@e-den.it wrote:
> Hi all,
> 
>    i've been using raid1 sisnce quite a loto of time. Sporadiccaly an array
>    fails a disk and in many situations I can just pull the device into the
>    array with
> 
>       mdadm /dev/mdN --add failded_device

If a drive fails, you should try to understand *why* it failed before
simply adding it back to the array.  If it was a transient read error,
then it is fairly safe to add it back, though more recent kernels will
not kick a drive in this situation.
If it was a write error, then the reconstruction will fail.
If it was a cabling or hardware error, then you really need to get it
fixed.


> 
>    I've never really understood what is the magic that resurrexes it. I
>    thought something related to relocation of bad blocks, but I'm  not at
>    all aware of what happens "there"...

md will simply copy all the data from the 'good' drive to the 'bad'
drive.  If this work, life continues happily.  If not....


> 
>    Is that a correct trial to do?
> 
>    Now I have a device that throuws an error:
> 
> srv-ornago:/tmp# mdadm /dev/md2 --add /dev/hdc6 
> mdadm: hot add failed for /dev/hdc6: Invalid argument
> 
> the kernel complains:
> Mar  1 09:34:29 srv-ornago kernel: md: could not bd_claim hdc6.
> Mar  1 09:34:29 srv-ornago kernel: md: error, md_import_device()
> returned -16

This is telling you that the device (hdc6) is in use by something
else.
Is it mentioned in 'cat /proc/mdstat' ? It some partition on it
mounted?

NeilBrown
