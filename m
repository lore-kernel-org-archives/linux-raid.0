From: Phil Turmel <philip@turmel.org>
Subject: Re: Please help RAID1 complete fail no superblock
Date: Sat, 26 Nov 2016 14:58:40 -0500
Message-ID: <ba69c6e8-de9c-8585-3d7e-f0fd916b1696@turmel.org>
References: <869594.583611132-sendEmail@optimum>
 <d1b93e98-5d6a-01e4-5272-e3cd61e9136d@turmel.org>
 <14eb4917-a0d2-5a5e-02bb-9b6be8f6626d@gmail.com>
 <2d5f7ae7-16ed-47aa-4d74-7973ab8b6348@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2d5f7ae7-16ed-47aa-4d74-7973ab8b6348@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: YK <theelectricengineer@gmail.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "antlists@youngman.org.uk" <antlists@youngman.org.uk>, "george.rapp@gmail.com" <george.rapp@gmail.com>
List-Id: linux-raid.ids

Sorry Yaniv, caught up in the holiday weekend here )-:

On 11/26/2016 12:45 PM, YK wrote:
> On 11/23/2016 01:04 AM, YK wrote:
>> On 11/23/2016 12:01 AM, Phil Turmel wrote:
>>> Please provide the output of these two commands:
>>>
>>> dd if=/dev/sdb1 bs=4k count=4k |hexdump -C |head -n1000
>>>
>>> dd if=/dev/sdc bs=4k count=4k |hexdump -C |head -n1000
>> Here is the output for sdb1
>> ...
>> 00000420  00 80 00 00 00 80 00 00  00 20 00 00 d8 ef ba 53 |.........
>> .....S|
>> 00000430  e6 ef ba 53 01 00 ff ff  53 ef 01 00 01 00 00 00
>> |...S....S.......|
>> 00000440  ef ee ba 53 00 00 00 00  00 00 00 00 01 00 00 00
>> |...S............|
> 
> On 11/23/2016 11:47 PM, YK wrote:
>> On 11/23/2016 10:25 PM, Wols Lists wrote:
>>> Basically, you need to run hexdump, and look for evidence of a damaged
>>> superblock, and/or a filesystem superblock.
>>> If you find them, the other experts will be able, hopefully, to tell you
>>> how to get the array back
>>
>> I do see "53 ef" in the fifth line of the output for my sdb1 hexdump ! 
> After a lot of reading, I'm getting to the conclusion that the hexdump
> for sdb1
> shows my ext4 superblock in the correct location with the expected
> offset (line 430, 0x38).
> Am I right?

Yes.  sdb1 should be directly mountable.

> I tried to mount the partition without offset, by executing:
> mount /dev/sdb1 -o ro -t ext4 /mnt/recovery
> 
> But I still get this message:
> mount: wrong fs type, bad option, bad superblock on /dev/sdb1
> 
> Is there something I can do to successfully mount my old partition?

so, something stomped on the beginning of your filesystem superblock.
Fortunately, ext2/3/4 keeps backup copies that should let you fix your
filesystem, then mount it.  The manpage for e2fsck shows the '-b' option
that uses a backup superblock, and describes the methods for figuring
out where your backup superblocks are located.

Phil
