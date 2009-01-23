From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Filesystem on RAID5 missing or corrupted after reboot (bad
 superblock error)
Date: Fri, 23 Jan 2009 16:23:42 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0901231622490.1615@p34.internal.lan>
References: <497A226D.9030807@mike01.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <497A226D.9030807@mike01.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Berger <lists@mike01.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Fri, 23 Jan 2009, Mike Berger wrote:

> Hi,
>
> I had posted to this list a week ago asking for assistance in recovering
> a filesystem on my RAID5 array.  After having recovered what I could
> (from other sources, backups, etc) I decided to start fresh, and found I
> have even bigger problems.

Hi,

If you are using GPT partitions, the kernel will not recognize them
after stop/start or a reboot unless you have this option enabled in the
kernel:

CONFIG_EFI_PARTITION=y

Also, why use a GPT partition, do you have individual HDDs over 2TiB?
If not, just make a regular partition on each HDD with fdisk and make it type
'fd'?

Justin.

