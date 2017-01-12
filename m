From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] [LSF/MM ATTEND] md raid general
 discussion
Date: Thu, 12 Jan 2017 17:09:23 +0200
Message-ID: <17625a3f-5598-d83d-44a1-316ccc917ad5@grimberg.me>
References: <79796ea4-2631-c762-b8a1-50bcdcbc602e@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <79796ea4-2631-c762-b8a1-50bcdcbc602e@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>, lsf-pc@lists.linux-foundation.org
Cc: linux-block@vger.kernel.org, songliubraving@fb.com, pawel.baldysiak@intel.com, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, NeilBrown <neilb@suse.com>, "open list:SOFTWARE RAID (Multiple Disks) SUPPORT" <linux-raid@vger.kernel.org>, artur.paszkiewicz@intel.com, Hannes Reinecke <hare@suse.de>, Guoqing Jiang <gqjiang@suse.com>, Jes.Sorensen@redhat.com, mariusz.dabrowski@intel.com, Shaohua Li <shli@kernel.org>
List-Id: linux-raid.ids

Hey Coly,

> Also I receive reports from users that raid1 performance is desired when
> it is built on NVMe SSDs as a cache (maybe bcache or dm-cache). I am
> working on some raid1 performance improvement (e.g. new raid1 I/O
> barrier and lockless raid1 I/O submit), and have some more ideas to discuss.

Do you have some performance measurements to share?

Mike used null devices to simulate very fast devices which
led to nice performance enhancements in dm-multipath code.
