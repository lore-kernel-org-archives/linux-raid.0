From: David Greaves <david@dgreaves.com>
Subject: Re: Raid array is not automatically detected.
Date: Mon, 16 Jul 2007 16:21:41 +0100
Message-ID: <469B8D05.1080003@dgreaves.com>
References: <4697E231.3070906@hp.com> <4698D4FC.2060100@tmr.com> <Pine.LNX.4.64.0707140952440.31528@p34.internal.lan> <469B7E75.3030907@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <469B7E75.3030907@hp.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bryan Christ <bryan.christ@hp.com>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, Bill Davidsen <davidsen@tmr.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Bryan Christ wrote:
> I do have the type set to 0xfd.  Others have said that auto-assemble 
> only works on RAID 0 and 1, but just as Justin mentioned, I too have 
> another box with RAID5 that gets auto assembled by the kernel (also no 
> initrd).  I expected the same behavior when I built this array--again 
> using mdadm instead of raidtools.

Any md arrays with partition type 0xfd using a 0.9 superblock should be 
auto-assembled by a standard kernel.

If you want to boot from them you must ensure the kernel image is on a partition 
that the bootloader can read - ie RAID 0. This is nothing to do with auto-assembly.

So some questions:
* are the partitions 0xfd ? yes.
* is the kernel standard?
* are the superblocks version 0.9? (mdadm --examine /dev/component)

David

