From: andy liebman <andyliebman@aol.com>
Subject: Re: Making bootable SATA RAID1 array in Mandriva 2006
Date: Mon, 14 Aug 2006 06:50:30 -0400
Message-ID: <44E05576.5050604@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks for the reply, Luca

> On Sun, Aug 13, 2006 at 07:51:42PM -0400, andy liebman wrote:
>>-- I copied the contents of /dev/sda1 (/ partition) and /dev/sda6 (/home 
>>partition) to /dev/sdb1 and /dev/sdb6 using rsync.
> this is not really important, but you should have used the raid devices
> as a target.

Sorry, I wrote this incorrectly. In my case, /dev/sdb1 = /dev/md1 and 
/dev/sdb6 = /dev/md2.  Remember, my md devices each have a drive missing 
at this point. I had the mdX devices started and mounted, and I rsynced 
from /dev/sda1 to /dev/md1, /dev/sda6 to /dev/md2.

> 
>>-- I edited fstab and lilo.conf on the the RAID1 "/" partition so that 
>>they would refer to /dev/md1
>>-- I ran chroot on the /dev/md1 partition
> did you mount /dev, /proc and /sys before chrooting?
> i.e
> mount --bind /dev /newroot/dev
> mount -t proc /proc /newroot/proc
> mount -t sysfs /sys /newroot/sys

Why do I have to do this? I haven't seen this in any "recipies". My 
Linux setup only has three partitions:   "/", swap, and "/home".

My experience with fixing bootloaders in the past is that I can boot up 
with a LIVE CD or rescue disk, chroot say into /dev/sda and run lilo 
right to fix the bootloader on /dev/sda. I do this when need to move my 
OS drive from an IDE to SATA or back again.

I'm not sure I understand what you're saying about mounting /dev, /proc 
and /sys.


Regards,
Andy Liebman
.

