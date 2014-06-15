From: =?UTF-8?Q?Nuno_Magalh=C3=A3es?= <nunomagalhaes@eu.ipp.pt>
Subject: Re: RAID newbie, 1 vs 5, chunk sizes
Date: Sun, 15 Jun 2014 18:40:53 +0100
Message-ID: <CADqA9ubK0Jt81Qq+HkVfkVCjm5W5aZrKWZxCug0JmZnYdt3EuQ@mail.gmail.com>
References: <CADqA9ua4xuJM3J6mQY7jXrt-5f6Rsv3aFaxyiqL1e80t70R6Rg@mail.gmail.com>
 <539CC4F8.90905@hardwarefreak.com> <CADqA9ubFPVG96u6T4RT2oJeaZ9rYSy6S9jp1At4vaKmjPVeJTA@mail.gmail.com>
 <pmrj5x4rq3qbl6unnu7guho9.1402849407134@email.android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <pmrj5x4rq3qbl6unnu7guho9.1402849407134@email.android.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Craig Curtin <craigc@prosis.com.au>
List-Id: linux-raid.ids

On Sun, Jun 15, 2014 at 5:28 PM, Craig Curtin <craigc@prosis.com.au> wrote:
> You do not want to do raid 5 with any sort of VMs - search the archives from
> last week or two for one other persons experience -  start up and Shutdown
> will kill you -  also power loss if no ups  (and you have not mentioned
> having one)

I found [1] pertaining to a RAID6 array with very slow boot times.
However, the VMs in question were file-based VirtualBox VMs, whereas i
want to use LVM-based Xen VMs. I assume Xen will perform better, or
will it perform less badly if i go for RAID5?

I also saw RAID10,f2 mentioned [2] as being a good solution for
desktop systems, which is my case (the first days will be atypical as
i gradually copy stuff onto the array, but then it'll be mostly reads
as far as data goes, with read/writes for VMs). I hadn't looked into
this type before, how does it compare to RAID5 in terms of space? It
seems that, for 3x 1TB disks, both would provide 2TB of space +1TB of
parity (or mirrorred redundancy). Is this correct?

Regards,
Nuno

[1] http://marc.info/?l=linux-raid&m=140163840103389&w=2
[2] http://marc.info/?l=linux-raid&m=140153409328161&w=2
http://en.wikipedia.org/wiki/Linux_MD_RAID_10#Linux_MD_RAID_10
