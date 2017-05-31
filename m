From: Roman Mamedov <rm@romanrm.net>
Subject: Re: RAID10 performance with 20 drives
Date: Wed, 31 May 2017 19:14:41 +0500
Message-ID: <20170531191441.40240b7f@natsu>
References: <CAGqmV7p4_r+ca+Wq_UXcY4RDa7WwE2nWkgXF+Sn3ChwLEmkurQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGqmV7p4_r+ca+Wq_UXcY4RDa7WwE2nWkgXF+Sn3ChwLEmkurQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: CoolCold <coolthecold@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, 31 May 2017 19:20:10 +0700
CoolCold <coolthecold@gmail.com> wrote:

> Creation (disable write intent bitmap, with bitmap all is much worse):
> mdadm --create -c 64 -b none -n 20 -l 10 /dev/md1 /dev/sde /dev/sdf
> /dev/sdg /dev/sdh /dev/sdi /dev/sdj /dev/sdk /dev/sdl /dev/sdm
> /dev/sdn /dev/sdo /dev/sdp /dev/sdq /dev/sdr /dev/sds /dev/sdt
> /dev/sdu /dev/sdv /dev/sdw /dev/sdx
>
> kernel:
> [root@spare-a17484327407661 rovchinnikov]# cat /proc/version
> Linux version 3.10.0-327.el7.x86_64 (builder@kbuilder.dev.centos.org)
> (gcc version 4.8.3 20140911 (Red Hat 4.8.3-9) (GCC) ) #1 SMP Thu Nov
> 19 22:10:57 UTC 2015
> 
> So, the question is - why cpu usage is so high and I suppose is a limit here?

Definitely try a newer kernel, 4.4 at the very least; if no changes then 4.11.

Also I would suggest to try out larger chunk sizes, such as 512 and 1024 KB.

If you plan to use this long-term in production, also read up on the various
RAID10 data layouts and their benefits and downsides (man md, search for
"layout"; and search the Internet for benchmarks of all three).

-- 
With respect,
Roman
