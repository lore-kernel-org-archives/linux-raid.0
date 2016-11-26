From: YK <theelectricengineer@gmail.com>
Subject: Re: Please help RAID1 complete fail no superblock
Date: Sat, 26 Nov 2016 19:45:56 +0200
Message-ID: <2d5f7ae7-16ed-47aa-4d74-7973ab8b6348@gmail.com>
References: <869594.583611132-sendEmail@optimum>
 <d1b93e98-5d6a-01e4-5272-e3cd61e9136d@turmel.org>
 <14eb4917-a0d2-5a5e-02bb-9b6be8f6626d@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <14eb4917-a0d2-5a5e-02bb-9b6be8f6626d@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "antlists@youngman.org.uk" <antlists@youngman.org.uk>, "george.rapp@gmail.com" <george.rapp@gmail.com>Wols Lists <antlists@youngman.org.uk>
List-Id: linux-raid.ids

On 11/23/2016 01:04 AM, YK wrote:
> On 11/23/2016 12:01 AM, Phil Turmel wrote:
>> Please provide the output of these two commands:
>>
>> dd if=/dev/sdb1 bs=4k count=4k |hexdump -C |head -n1000
>>
>> dd if=/dev/sdc bs=4k count=4k |hexdump -C |head -n1000
> Here is the output for sdb1
> ...
> 00000420  00 80 00 00 00 80 00 00  00 20 00 00 d8 ef ba 53 |......... 
> .....S|
> 00000430  e6 ef ba 53 01 00 ff ff  53 ef 01 00 01 00 00 00 
> |...S....S.......|
> 00000440  ef ee ba 53 00 00 00 00  00 00 00 00 01 00 00 00 
> |...S............|

On 11/23/2016 11:47 PM, YK wrote:
> On 11/23/2016 10:25 PM, Wols Lists wrote:
>> Basically, you need to run hexdump, and look for evidence of a damaged
>> superblock, and/or a filesystem superblock.
>> If you find them, the other experts will be able, hopefully, to tell you
>> how to get the array back
>
> I do see "53 ef" in the fifth line of the output for my sdb1 hexdump ! 
After a lot of reading, I'm getting to the conclusion that the hexdump 
for sdb1
shows my ext4 superblock in the correct location with the expected 
offset (line 430, 0x38).
Am I right?

I tried to mount the partition without offset, by executing:
mount /dev/sdb1 -o ro -t ext4 /mnt/recovery

But I still get this message:
mount: wrong fs type, bad option, bad superblock on /dev/sdb1

Is there something I can do to successfully mount my old partition?

Thank you all again,

Yaniv

