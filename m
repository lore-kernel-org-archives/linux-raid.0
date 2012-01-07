From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Install grub2 to /dev/md126 fails
Date: Sat, 07 Jan 2012 15:39:06 +0000
Message-ID: <4F08671A.6090403@anonymous.org.uk>
References: <123493149.466191.1325863934205.JavaMail.root@sz0019a.westchester.pa.mail.comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <123493149.466191.1325863934205.JavaMail.root@sz0019a.westchester.pa.mail.comcast.net>
Sender: linux-raid-owner@vger.kernel.org
To: jlcenter@comcast.net
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 06/01/2012 15:32, jlcenter@comcast.net wrote:
> Hi,
>
> I'm going to try again to build the raid1 array, but I was wondering
> if the GPT partitions should be created first on the physical disks,
> then create&  assemble the array?  Or, if the array should be
> created&  assembled, then partition the array?  I'm raiding the whole
> disk(s), not partitions.  Reading the wiki, I get the impression the
> first way is preferable, but most of the descriptions I've read
> on-line suggest doing the latter.   Also, for mdadm with GPT
> partitions, is there any preferred order to the partitions, i.e.,
> does the bios boot partition have to be the first partition on the
> array?

If my understanding is correct, you want an IMSM array that can be 
booted by a uEFI BIOS? In which case, I think you need an array over the 
whole disks (which might give you a /dev/md127 for a container, and 
/dev/md126 for the data), GPT partition table over that, first partition 
a GPT boot partition (so you will be installing GRUB2 to /dev/md126p1 - 
this is NOT a filesystem partition), and then whatever you want after 
that, e.g. to keep it simple a /dev/md126p2 for swap and /dev/md126p3 
for your filesystem.

If you don't have a uEFI BIOS, it gets more complicated; you will need a 
hybrid MBR with a traditional boot sector and at least the GPT boot 
partition exposed :-(

Caveat: I've read a lot but I haven't actually done this, so I may be 
talking rubbish...

Cheers,

John.

