From: =?UTF-8?Q?Nuno_Magalh=C3=A3es?= <nunomagalhaes@eu.ipp.pt>
Subject: Re: RAID newbie, 1 vs 5, chunk sizes
Date: Sun, 15 Jun 2014 12:50:34 +0100
Message-ID: <CADqA9ubFPVG96u6T4RT2oJeaZ9rYSy6S9jp1At4vaKmjPVeJTA@mail.gmail.com>
References: <CADqA9ua4xuJM3J6mQY7jXrt-5f6Rsv3aFaxyiqL1e80t70R6Rg@mail.gmail.com>
 <539CC4F8.90905@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <539CC4F8.90905@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

Thanks for your reply. The more i search the more i realize this is
*very* subjective.

On Sat, Jun 14, 2014 at 10:56 PM, Stan Hoeppner <stan@hardwarefreak.com> wrote:
>
> If you're working predominantly with large media files you'll want a
> large chunk/stripe for data transfer efficiency from the platters with
> the fewest seeks.  If you have a mixed workload with small and large
> files, it's best to use a small chunk size, such as 32 or 64KB.

The workload will vary: i have some ~240 GiB of media (ISO files,
movies, photos, music - in increacing order of usage) that i intend to
share on the LAN via SMB/CIFS through a Xen VM. This would be the
biggest chunk of data. Then i have about 50 GiB of personal stuff,
mostly pdf, txt, docx and similar.
The remainder will be used for Xen VMs to work as servers (a web
front-end for that samba share,for instance) and a Windows VM or two,
MySQL databases (nothing big), etc.

In the end i guess it fits the mixed-workload scenario. With all the
subjectivity, can i change the chunk size once the array is created?
Will that "rechunk" existing data - is it feasable - or will it just
use the new value for new data?

> All of that stated, your filesystem setup, specifically write barrier
> support and journal mode, along with those slow disk spindles, will be a
> much more significant impediment to performance than your chunk size.

LVM2 seems to support barriers now, the main issue will be how XFS
behaves under Xen with barriers. I'd also use mostly ext4.

I'm inclined to giving RAID5 a try, i'll dig some more.

Cheers,
Nuno
