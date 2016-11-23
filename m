From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Please help RAID1 complete fail no superblock
Date: Wed, 23 Nov 2016 20:25:40 +0000
Message-ID: <5835FB44.2080102@youngman.org.uk>
References: <175840.371844487-sendEmail@optimum>
 <CAF-KpgbDRbUZeKd+fL8qSGXa-2=QEZqVeAQsQk5U7YqJrcyL3A@mail.gmail.com>
 <58345E9E.1080102@youngman.org.uk>
 <CAOLyU3WMJc+En=DbOW-n2uAXe7b1Gvo6jGCr0zLv5LumrxKJNQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAOLyU3WMJc+En=DbOW-n2uAXe7b1Gvo6jGCr0zLv5LumrxKJNQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: y k <theelectricengineer@gmail.com>
Cc: George Rapp <george.rapp@gmail.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 22/11/16 16:15, y k wrote:
> Thank you for the quick response,
> 
> Attached are the outputs of fdisk -l for both drives.
> 
> I read all the correspondence in the archived email thread "RAID10 with
> 2 drives
> auto-assembled as RAID1",
> but I don't understand what I should do.
> 
> Could you please guide me?
> I'm afraid to execute any unfamiliar commands that might lower my
> chances of saving my data.

Basically, you need to run hexdump, and look for evidence of a damaged
superblock, and/or a filesystem superblock.

Hexdump will only read a disk, not do anything to it. That thread should
tell you what strings to look for to locate any superblocks, which are
probably on a 4K boundary.

If you find them, the other experts will be able, hopefully, to tell you
how to get the array back. What should happen is mdadm looks at the disk
for the partition table, then looks at the partitions for an array
superblock, then passes the array to linux to be mounted. Obviously,
something in that chain has been broken, and unfortunately you now have
to do that manually. Hexdump is your tool to examine the disk and look
for the information that linux should have found for you automatically.

In the next few days, I'm planning to add a page to the wiki explaining
how to use hexdump and find this information.
> 
> Thank you so much!
> 
> Yaniv
> 
> On Tue, Nov 22, 2016 at 5:05 PM, Wols Lists <antlists@youngman.org.uk
> <mailto:antlists@youngman.org.uk>> wrote:
> 
>     On 22/11/16 14:49, George Rapp wrote:
>     > On Tue, Nov 22, 2016 at 9:31 AM, theelectricengineer@gmail.com <mailto:theelectricengineer@gmail.com>
>     > <theelectricengineer@gmail.com
>     <mailto:theelectricengineer@gmail.com>> wrote:
>     >> Hello good people of the linux-raid group,
>     >>
>     >> I really need your help with my RAID1 that has completely failed, on which I have photos of my beloved deceased grandparents.
>     >>
>     >> I had the RAID1 array for about 3 years, and I had replaced one of the drives when it failed about one year ago. All worked fine.
>     >>
>     >> A few weeks ago, I bought a new computer and wanted to move the array to the new computer.
>     >> I read several guides, and thought that all I had to do was turn both computers off, move the drives, and in the new computer execute: mdadm --assemble --scan
>     >> which I did.
>     >>
>     >> The output was: mdadm: /dev/sdb has no superblock - assembly aborted
>     >>
>     >> I panicked, moved the drives back, but the old RAID wouldn't start!
>     >> The old computer too says that one of the drives has no superblock
>     >> and, even worse, that the other is UNALLOCATED SPACE!!!
>     >>
>     >> I don't understand why the partition on the second drive disappeared, and I'm so worried.
>     >>
>     >> PLEASE, PLEASE help me...
>     >>
>     >> I read the wiki pages (raid wiki kernel), but I'm afraid to run any commands that might make things worse.
>     >>
>     >> I would be very happy if I could restore the data from either one of the drives,
>     >> and copy it to the new drives in my new computer (as I should have done before moving the drives).
>     >>
>     >
>     > Yadiv -
>     >
>     > One more piece of information that would be helpful is the partition
>     > tables for each drive:
>     >
>     > # fdisk -l /dev/sdb /dev/sdc
>     >
> 
>     And search the archive for the following thread - "RAID10 with 2 drives
>     auto-assembled as RAID1". It's pretty recent.
> 
>     You've got a mirror, which means both of your drives should have a valid
>     filesystem on them, so things look optimistic. It's just a case of
>     finding it - that thread should help you look. The experts will chime
>     in, but if you can find the string sequences they're looking for, it'll
>     help you recover the partition(s). What filesystem were you using?
> 
>     Cheers,
>     Wol
> 
> 

