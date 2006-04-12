From: Shai <shaibn@gmail.com>
Subject: Re: mdadm + raid1 of 2 disks and now need to add more
Date: Wed, 12 Apr 2006 09:18:46 +0200
Message-ID: <e3edb0fa0604120018y3e305d05td532034e546ab816@mail.gmail.com>
References: <e3edb0fa0604110741h355f4eft3f3d42a825cb4233@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e3edb0fa0604110741h355f4eft3f3d42a825cb4233@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I now have the md0 raid1 with 2 disks and 1 spare:
       0      22       65        0      active sync   /dev/hdd1
       1      22       66        1      active sync   /dev/hdd2

       2      22       67        2      spare   /dev/hdd3

# /usr/local/sbin/mdadm -G -n 3 /dev/md0
mdadm: Cannot set raid-devices for /dev/md0: File exists

i'm using kernel 2.4.26

# /usr/local/sbin/mdadm -V
mdadm - v2.4.1 -  4 April 2006

On 4/11/06, Shai <shaibn@gmail.com> wrote:
> Hi,
>
> I have two SCSI disks on raid1.
> Since I have lots of reads from that raid, I want to add two more
> disks to this raid so that read will be faster.
>
> How should I add the new disks?
