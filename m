From: David Greaves <david@dgreaves.com>
Subject: Re: Sleeping hard drives in an array?
Date: Thu, 01 May 2008 10:55:04 +0100
Message-ID: <48199378.5020903@dgreaves.com>
References: <29a863790804300802i358ab6d9t2be907b47176bd5b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <29a863790804300802i358ab6d9t2be907b47176bd5b@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Greg Cormier <gcormier@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Greg Cormier wrote:
> Is it possible to sleep hard drives in an array?
yes - to be clear you sleep the drives though, not the array.

> Can I sleep the drives in my RAID5 array while it's not being used?
> It's an XFS partition.
XFS is bad at this IIRC.
Certainly noatime is important to prevent cache accesses from updating the fs.

> 
> But I'm fairly sure they are not spinning down :( Is there some
> activity mdadm is doing in the background?

from Documentation/laptops/laptop-mode.txt:

If you want to find out which process caused the disk to spin up, you can
gather information by setting the flag /proc/sys/vm/block_dump. When this flag
is set, Linux reports all disk read and write operations that take place, and
all block dirtyings done to files. This makes it possible to debug why a disk
needs to spin up, and to increase battery life even more. The output of
block_dump is written to the kernel output, and it can be retrieved using
"dmesg". When you use block_dump and your kernel logging level also includes
kernel debugging messages, you probably want to turn off klogd, otherwise
the output of block_dump will be logged, causing disk activity that is not
normally there.

also google found
http://www.nslu2-linux.org/wiki/FAQ/HowtoIdentifyWhichProcessesAccessDisk

Before going too far, make sure the array is up but not mounted and ensure that
the drives will actually spin down.

David
