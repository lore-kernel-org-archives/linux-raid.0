From: William Colls <william.colls@rogers.com>
Subject: Re: Raid Problem - Unknown File System Type
Date: Thu, 10 Nov 2011 10:23:44 -0500
Message-ID: <4EBBEC80.9040709@rogers.com>
References: <4EBAA68B.6090906@rogers.com> <20111109163933.GA26630@cthulhu.home.robinhill.me.uk> <4EBAB47C.5070002@rogers.com> <4EBACC88.8070403@turmel.org> <4EBADB1E.1070700@rogers.com> <4EBADD07.5030109@turmel.org> <4EBAE90F.2030104@rogers.com> <4EBAF46C.2030001@turmel.org> <4EBB46A5.8080305@rogers.com> <4EBB4B95.6040309@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4EBB4B95.6040309@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 11/09/2011 10:57 PM, Phil Turmel wrote:

[....]

>>> lsdrv
>>
>> **Warning** The following utility(ies) failed to execute:
>>    sginfo
>>    pvs
>>    lvs
>> Some information may be missing.
>
> Missing pvs and lvs means LVM is not installed.  Do you recall if the array was mounted directly?

the array was mounted as follows

mount -t ext3 /dev/md0p1 /opt/share

LVM was not installed on the old system, nor is it installed on the new 
machine

> [....]

> Please show a hexdump of the first 8k of /dev/md0p1.  That should give us a signature to hunt down.

00000000  fa b8 00 10 8e d0 bc 00  b0 b8 00 00 8e d8 8e c0 
|................|
00000010  fb be 00 7c bf 00 06 b9  00 02 f3 a4 ea 21 06 00 
|...|.........!..|
00000020  00 be be 07 38 04 75 0b  83 c6 10 81 fe fe 07 75 
|....8.u........u|
00000030  f3 eb 16 b4 02 b0 01 bb  00 7c b2 80 8a 74 01 8b 
|.........|...t..|
00000040  4c 02 cd 13 ea 00 7c 00  00 eb fe 00 00 00 00 00 
|L.....|.........|
00000050  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00 
|................|
*
000001b0  00 00 00 00 00 00 00 00  17 29 06 00 00 00 00 01 
|.........)......|
000001c0  01 00 83 fe ff ff 3f 00  00 00 01 14 54 57 00 00 
|......?.....TW..|
000001d0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00 
|................|
*
000001f0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 55 aa 
|..............U.|
00000200  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00 
|................|
*
00002000


> In the meantime, consider installing some FS support packages:
>
> xfsprogs
> reiserfsprogs
> jfsutils
> btrfs-tools
> udftools
> lvm2
>
>
> Phil
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
I know you believe that you understand what you think I said, but I am 
not sure that you realize that what you heard was not what I ment.
