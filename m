From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: First raid1 sector gets zeroed at first reboot
Date: Wed, 17 Aug 2011 18:32:05 +0100
Message-ID: <4E4BFB15.1090200@anonymous.org.uk>
References: <4E4AABF6.2070800@shiftmail.org> <4E4BC586.10109@anonymous.org.uk> <4E4BC96D.1020802@shiftmail.org> <4E4BD186.4070604@anonymous.org.uk> <4E4BF026.8030006@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E4BF026.8030006@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: Asdo <asdo@shiftmail.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 17/08/2011 17:45, Asdo wrote:
> On 08/17/11 16:34, John Robinson wrote:
[...]
>> The first sector of a md RAID with metadata 1.0 is in its data area,
>> so there's no way md is writing to this area itself, it's almost
>> certainly the filesystem that's writing it.
> This is an interesting observation then. ("no way" is a bit extreme
> though)

If it did, everybody's filesystems would be getting trashed, and I don't 
think this is happening.

> You are right in the sense that it might have been the
> filesystem that is doing something at the first remount, and not MD. I
> can't be sure it's MD anymore. Still, this is wrong, why should the
> filesystem wipe its own boot sector?
> It's ext3 btw. If no one pops up with an explanation here on linux-raid
> I will also ask there.
>
> I still stand that what I am doing is correct. I am using the partition
> boot sector properly
> http://en.wikipedia.org/wiki/Volume_boot_record

Not all filesystems or other things you might have in a partition 
necessarily support a volume boot record. LVM doesn't. XFS doesn't. md 
doesn't unless you use metadata 1.2. As it happens it can work with md 
if you use metadata 0.9 or 1.0 and a filesystem which does support a 
volume boot record.

ext2/3 supports a volume boot record. The first superblock starts 1K 
into the filesystem. If you are using a 1K block size, the superblock is 
in block 1, so mke2fs won't touch an existing volume boot record. If you 
are using the more likely 4K block size, the superblock is 1K into block 
0, and mke2fs will write zeros to the first 1K.

Once mke2fs has been run, however, I wouldn't expect ext2/3 to overwrite 
the volume boot record, given that the developers bothered to support 
one in the first place, but that's an ext2/3 question.

Cheers,

John.
