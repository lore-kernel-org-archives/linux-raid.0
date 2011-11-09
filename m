From: Phil Turmel <philip@turmel.org>
Subject: Re: Raid Problem - Unknown File System Type
Date: Wed, 09 Nov 2011 16:45:16 -0500
Message-ID: <4EBAF46C.2030001@turmel.org>
References: <4EBAA68B.6090906@rogers.com> <20111109163933.GA26630@cthulhu.home.robinhill.me.uk> <4EBAB47C.5070002@rogers.com> <4EBACC88.8070403@turmel.org> <4EBADB1E.1070700@rogers.com> <4EBADD07.5030109@turmel.org> <4EBAE90F.2030104@rogers.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4EBAE90F.2030104@rogers.com>
Sender: linux-raid-owner@vger.kernel.org
To: William Colls <william.colls@rogers.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

[added the list back.  Please use reply-to-all on kernel.org lists.]

On 11/09/2011 03:56 PM, William Colls wrote:
> On 11/09/2011 03:05 PM, Phil Turmel wrote:
[...]
>> Or there might have been a partition table or boot loader showing, or fragments thereof.
>>
>> I can't see them, of course.  (Hint.)
> 
> Files attached

OK. So that wasn't it.  GRUB is in the first sector, with a MBR partition table identifying a single 750G partition starting at sector 63.

So something else is wrong.  Maybe your kernel is different, and just doesn't have the module for the FS.  Or one of the BIOSes messes with the apparent disk capacity.  Or something else is interfering.

Please show:

cat /proc/filesystems
cat /proc/partitions
fdisk -l
lsdrv

... and repeat on the old system if at all possible.  Preferably with one of the disks plugged back into it.

a complete dmesg from the old system could also be useful.

You can get lsdrv from: http://github.com/pturmel/lsdrv

Phil
