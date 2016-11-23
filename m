From: YK <theelectricengineer@gmail.com>
Subject: Re: Please help RAID1 complete fail no superblock
Date: Wed, 23 Nov 2016 23:47:18 +0200
Message-ID: <89999c94-27ac-f222-1fdd-0c0ce8a2af68@gmail.com>
References: <175840.371844487-sendEmail@optimum>
 <CAF-KpgbDRbUZeKd+fL8qSGXa-2=QEZqVeAQsQk5U7YqJrcyL3A@mail.gmail.com>
 <58345E9E.1080102@youngman.org.uk>
 <CAOLyU3WMJc+En=DbOW-n2uAXe7b1Gvo6jGCr0zLv5LumrxKJNQ@mail.gmail.com>
 <5835FB44.2080102@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5835FB44.2080102@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: George Rapp <george.rapp@gmail.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, Phil Turmel <philip@turmel.org>
List-Id: linux-raid.ids

On 11/23/2016 10:25 PM, Wols Lists wrote:
> Basically, you need to run hexdump, and look for evidence of a damaged
> superblock, and/or a filesystem superblock.
>
> That thread should tell you what strings to look for to locate any superblocks, which are
> probably on a 4K boundary.

Thank you for the explanation.
How do I tell the difference between a filesystem superblock and a 
damanged one in the hexdump output?

I found in stackexchange instructions to look for "magic number 0x53EF",
which I then realized was searched by the egrep command in the other 
thread you mentioned.

> If you find them, the other experts will be able, hopefully, to tell you
> how to get the array back

I do see "53 ef" in the fifth line of the output for my sdb1 hexdump !
I'll greatly appreciate it if someone could instruct me in how to mount 
my sdb1 partition.

I see in some guide online, that one could mount a lost partition with a 
command like:
mount /dev/sdd -o ro,offset=2097152 /mnt/test/

How did they calculate that offset number?
And is there anything else I should do to recover the partition before 
or after mount?

I have a new HDD to which I could copy all the data, if I manage to 
mount the partition.
So, I could create a new array on the old drives, and then copy the data 
back.

