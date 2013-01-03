From: "Alex Leach" <beamesleach@gmail.com>
Subject: Re: RAID5 member disks shrunk
Date: Thu, 03 Jan 2013 18:05:58 -0000
Message-ID: <op.wqckj8gn8s54ea@metabuntu>
References: <op.wqcditj08s54ea@metabuntu> <20130103214236.3fe60580@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130103214236.3fe60580@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, 03 Jan 2013 15:42:36 -0000, Roman Mamedov <rm@romanrm.ru> wrote:

> If that is indeed the case, you can control it with "hdparm -N" (see its  
> man page).
>

Just checked out the man page, and ran "hdparm -N" on all RAID member
devices. They all report that HPA is disabled.
e.g.
      $ sudo hdparm -N /dev/sdc

/dev/sdc:
    max sectors   = 586072368/586072368, HPA is disabled

This number of sectors does seem like it would fit all the partitions from
the previous array. However, the Size reported by mdadm seems to be
smaller than what hdparm reports, judging from the error messages below.

On Thu, 03 Jan 2013 15:33:55 -0000, Alex Leach <beamesleach@gmail.com>
wrote:

>      $ sudo mdadm --create --verbose /dev/md/RAID5 --raid-devices=3  
> --level=5 --chunk=64 --layout=la --size=293033600  
> --uuid='789c5fd2b57d7def:89f68d3c' -e imsm /dev/sda /dev/sdg /dev/sdb
> mdadm: /dev/sdb not enough space (586066062 < 586067200)
> mdadm: /dev/sdb is smaller than given size. 0K < 293033600K + metadata
> mdadm: /dev/sdc not enough space (586066062 < 586067200)
> mdadm: /dev/sdc is not suitable for this array.
> mdadm: create aborted
>


Cheers,
Alex
