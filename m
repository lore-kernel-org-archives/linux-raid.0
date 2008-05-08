From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: Booting off of RAID10 versus RAID1
Date: Thu, 08 May 2008 19:38:22 +0200
Message-ID: <48233A8E.4000400@wpkg.org>
References: <06c201c8b128$1c4bf045$5209f40a@exchange.rackspace.com> <1f0f1a960805081016k3aebfdecj3450f3edb1470a43@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1f0f1a960805081016k3aebfdecj3450f3edb1470a43@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Twigathy <twigathy@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Twigathy schrieb:
> My desktop NFS boots off my fileserver, with a local /boot partition
> on a 2GB CompactFlash card in an IDE -> CF adapter bought for pennies
> on fleabay. With a partition like /boot that doesn't get written to
> very often (Only on kernel updates and initrd changes) I don't see the
> write limitations as being too much of a problem. Not sure how well
> they would fare in a raid1 setup, but again they'd only be written to
> occasionally.

For my SAN servers, I usually have a system installed on a IDE-flash or a 
USB-stick; data is stored separately on hard disks.

This way, an operating system is independent of data - in case of any operating 
system failure, just replace a small flash module, and you have access to data 
again. Having an operating system together with data on any RAID makes recovery 
from failures much harder.

Of course, everything depends on your usage.


So far, I had only one problem with worn out flash: I placed RAID bitmap on 
flash, and some time later, I had I/O errors when trying to access the bitmap 
file. Probably Transcend IDE-flash disks don't do a very clever wear-levelling.

Other than that, I don't have any problems - although some of these systems run 
off flash for several years now (including /var/log/).

See also a recent "Compact Flash Question" discussion on lkml.


-- 
Tomasz Chmielewski
http://wpkg.org
