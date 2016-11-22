From: George Rapp <george.rapp@gmail.com>
Subject: Re: Please help RAID1 complete fail no superblock
Date: Tue, 22 Nov 2016 09:49:27 -0500
Message-ID: <CAF-KpgbDRbUZeKd+fL8qSGXa-2=QEZqVeAQsQk5U7YqJrcyL3A@mail.gmail.com>
References: <175840.371844487-sendEmail@optimum>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <175840.371844487-sendEmail@optimum>
Sender: linux-raid-owner@vger.kernel.org
To: "theelectricengineer@gmail.com" <theelectricengineer@gmail.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Nov 22, 2016 at 9:31 AM, theelectricengineer@gmail.com
<theelectricengineer@gmail.com> wrote:
> Hello good people of the linux-raid group,
>
> I really need your help with my RAID1 that has completely failed, on which I have photos of my beloved deceased grandparents.
>
> I had the RAID1 array for about 3 years, and I had replaced one of the drives when it failed about one year ago. All worked fine.
>
> A few weeks ago, I bought a new computer and wanted to move the array to the new computer.
> I read several guides, and thought that all I had to do was turn both computers off, move the drives, and in the new computer execute: mdadm --assemble --scan
> which I did.
>
> The output was: mdadm: /dev/sdb has no superblock - assembly aborted
>
> I panicked, moved the drives back, but the old RAID wouldn't start!
> The old computer too says that one of the drives has no superblock
> and, even worse, that the other is UNALLOCATED SPACE!!!
>
> I don't understand why the partition on the second drive disappeared, and I'm so worried.
>
> PLEASE, PLEASE help me...
>
> I read the wiki pages (raid wiki kernel), but I'm afraid to run any commands that might make things worse.
>
> I would be very happy if I could restore the data from either one of the drives,
> and copy it to the new drives in my new computer (as I should have done before moving the drives).
>

Yadiv -

One more piece of information that would be helpful is the partition
tables for each drive:

# fdisk -l /dev/sdb /dev/sdc

-- 
George Rapp  (Pataskala, OH) Home: george.rapp -- at -- gmail.com
LinkedIn profile: https://www.linkedin.com/in/georgerapp
Phone: +1 740 936 RAPP (740 936 7277)
