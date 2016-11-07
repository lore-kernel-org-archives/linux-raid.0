From: Phil Turmel <philip@turmel.org>
Subject: Re: RAID10 with 2 drives auto-assembled as RAID1
Date: Mon, 7 Nov 2016 08:49:16 -0500
Message-ID: <c2c0659b-9dd6-1f5f-9309-8a47ea3400f4@turmel.org>
References: <0487f9a4-c04a-8a4d-78ad-0191995d4be9@luketic.de>
 <57ce55da-fadc-db02-289e-db44bf6fb7d7@turmel.org>
 <fdfd254f-bdcf-80a7-2265-893c8ee781fc@luketic.de>
 <e23d3b3a-c357-bd74-6bc5-f2e04255c96d@turmel.org>
 <904643ba-b712-0c8a-249d-a78e7fc68876@luketic.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <904643ba-b712-0c8a-249d-a78e7fc68876@luketic.de>
Sender: linux-raid-owner@vger.kernel.org
To: Darko Luketic <darko@luketic.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Good morning,

On 11/07/2016 08:36 AM, Darko Luketic wrote:
> On 11/05/2016 11:54 PM, Phil Turmel wrote:
>>  Assuming you had an ext2/3/4 filesystem in the array, try this
>> one-liner:
>>
>> for x in /dev/sd[ef]1; do echo -e "\nDevice $x"; dd if=$x bs=1M
>> count=16k |hexdump -C |egrep '^[0-9a-f]+30  .+  53 ef'; done

> There are many lines of output.
> Meanwhile I went the commercial route. Managed so save all important
> stuff but the software (rdata product version 6 for Windows) didn't do
> it properly.
> I'll have to start a new restore.
> I also used a free product for gnu/linux called R-Linux which is able to
> find most dirs and files but hangs at 1.03TB and is unable to find the
> most important .thunderbird dir .
> Also tried sleuthkit with autopsy2 without success.

Ok.

> For now I can cope with the 128GB ssd as a temporary solution, but life
> must go on and in the long run I need more space and to use the drives.
> 
> What was I searching for with this chain of commands?

Magic number for an ext2/3/4 filesystem at a suitable offset within a
sector.

> Device /dev/sde1
> 07f00430  b5 9b 1c 58 7a 02 ff ff  53 ef 01 00 01 00 00 00
> |...Xz...S.......|

This is a candidate, with a last write timestamp of Fri, 04 Nov 2016
14:31:17 GMT.


> 0ff00030  c4 36 78 52 00 00 ff ff  53 ef 00 00 01 00 00 00
> |.6xR....S.......|

And another candidate with a last write @ Tue, 05 Nov 2013 00:07:32 GMT.

> 1ff00030  c4 36 78 52 00 00 ff ff  53 ef 00 00 01 00 00 00
> |.6xR....S.......|

And this one appears to be a backup superblock for the 2013 filesystem.
The spacing between these two make me wonder if they are both backups
for a superblock that's been overwritten.

I'd suggest sharing these emails with the Ext4 mailing list to see if
you can get some more specific recovery help.  I'd say the odds are fair
to good.

Phil
