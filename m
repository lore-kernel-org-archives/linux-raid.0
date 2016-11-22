From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Please help RAID1 complete fail no superblock
Date: Tue, 22 Nov 2016 15:05:02 +0000
Message-ID: <58345E9E.1080102@youngman.org.uk>
References: <175840.371844487-sendEmail@optimum>
 <CAF-KpgbDRbUZeKd+fL8qSGXa-2=QEZqVeAQsQk5U7YqJrcyL3A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAF-KpgbDRbUZeKd+fL8qSGXa-2=QEZqVeAQsQk5U7YqJrcyL3A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: George Rapp <george.rapp@gmail.com>, "theelectricengineer@gmail.com" <theelectricengineer@gmail.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 22/11/16 14:49, George Rapp wrote:
> On Tue, Nov 22, 2016 at 9:31 AM, theelectricengineer@gmail.com
> <theelectricengineer@gmail.com> wrote:
>> Hello good people of the linux-raid group,
>>
>> I really need your help with my RAID1 that has completely failed, on which I have photos of my beloved deceased grandparents.
>>
>> I had the RAID1 array for about 3 years, and I had replaced one of the drives when it failed about one year ago. All worked fine.
>>
>> A few weeks ago, I bought a new computer and wanted to move the array to the new computer.
>> I read several guides, and thought that all I had to do was turn both computers off, move the drives, and in the new computer execute: mdadm --assemble --scan
>> which I did.
>>
>> The output was: mdadm: /dev/sdb has no superblock - assembly aborted
>>
>> I panicked, moved the drives back, but the old RAID wouldn't start!
>> The old computer too says that one of the drives has no superblock
>> and, even worse, that the other is UNALLOCATED SPACE!!!
>>
>> I don't understand why the partition on the second drive disappeared, and I'm so worried.
>>
>> PLEASE, PLEASE help me...
>>
>> I read the wiki pages (raid wiki kernel), but I'm afraid to run any commands that might make things worse.
>>
>> I would be very happy if I could restore the data from either one of the drives,
>> and copy it to the new drives in my new computer (as I should have done before moving the drives).
>>
> 
> Yadiv -
> 
> One more piece of information that would be helpful is the partition
> tables for each drive:
> 
> # fdisk -l /dev/sdb /dev/sdc
> 

And search the archive for the following thread - "RAID10 with 2 drives
auto-assembled as RAID1". It's pretty recent.

You've got a mirror, which means both of your drives should have a valid
filesystem on them, so things look optimistic. It's just a case of
finding it - that thread should help you look. The experts will chime
in, but if you can find the string sequences they're looking for, it'll
help you recover the partition(s). What filesystem were you using?

Cheers,
Wol
