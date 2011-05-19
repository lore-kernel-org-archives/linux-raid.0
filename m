From: Gordon Henderson <gordon@drogon.net>
Subject: Re: Best way to create RAID-6 for swap partition - existing one
 failed
Date: Thu, 19 May 2011 10:04:38 +0100 (BST)
Message-ID: <alpine.DEB.2.00.1105190934110.20582@unicorn.drogon.net>
References: <595104.28955.qm@web65106.mail.ac2.yahoo.com> <4DD41713.5070407@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DD41713.5070407@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 18 May 2011, Stan Hoeppner wrote:

> There is little performance difference between swap files and swap
> partitions with modern kernels.  The kernel will map the disk location
> of the swap file and perform direct disk access, bypassing the
> filesystem and buffer cache.

While this is true, sometimes it's handy to know why we did things a 
certian way... so ....

In the olden days (when *everything* was expensive, so you optimised it 
all!), we'd partition disks for many reasons, and one of them was 
efficiency and speed, so you'd look to having the swap partition in an 
area of the disk that was physically close to other areas you were using - 
of-course this would vary depending on the applications being run - but a 
typical layout might have root, then swap then /usr, or root, /usr, swap 
then /home (or /var) the idea being to minimise head movement.

So a typical (but maybe now old style) multi-user environment, people 
would be running programs from /usr, storing data in /home, so if the swap 
were physically in-between those areas, there was a good chance of 
minimising disk head movement, and thus making it go faster...

Partitions also helped to minimise data loss in the days when a head-crash 
was a real possibility, and it kept fsck times down, or at least 
managable..

I think we've lost a possibly quite a bit of efficiency with all the 
dynamic re-mapping of disk sectors and logical addressing rather than 
knowing exactly where on a disk a sector is (in cylinder, head, sector 
notation), but that's progress for you, and flash/ssd's are going to 
eliminate all that really old nonsense totally!

Of-course, in these enlightened days, no-one believes a word of it ...


I have a server with 5 disks in a RAID-6 configuration with swap on a 
RAID-6 partition. Mostly because RAID10 was in it's infancy when I 
installed it some 4+ years ago. It's due for retirement now though...

Gordon
