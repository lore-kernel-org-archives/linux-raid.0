From: Guoqing Jiang <gqjiang@suse.com>
Subject: Re: [LSF/MM TOPIC] [LSF/MM ATTEND] md raid general discussion
Date: Mon, 16 Jan 2017 11:33:05 +0800
Message-ID: <587C3EF1.3020401@suse.com>
References: <79796ea4-2631-c762-b8a1-50bcdcbc602e@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <79796ea4-2631-c762-b8a1-50bcdcbc602e@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>, lsf-pc@lists.linux-foundation.org
Cc: "open list:SOFTWARE RAID (Multiple Disks) SUPPORT" <linux-raid@vger.kernel.org>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, Shaohua Li <shli@kernel.org>, NeilBrown <neilb@suse.com>, songliubraving@fb.com, pawel.baldysiak@intel.com, mariusz.dabrowski@intel.com, artur.paszkiewicz@intel.com, Jes.Sorensen@redhat.com, Hannes Reinecke <hare@suse.de>
List-Id: linux-raid.ids



On 01/10/2017 12:38 AM, Coly Li wrote:
> Hi Folks,
>
> I'd like to propose a general md raid discussion, it is quite necessary
> for most of active md raid developers sit together to discuss current
> challenge of Linux software raid and development trends.
>
> In the last years, we have many development activities in md raid, e.g.
> raid5 cache, raid1 clustering, partial parity log, fast fail
> upstreaming, and some effort for raid1 & raid0 performance improvement.
>
> I see there are some kind of functionality overlap between r5cache
> (raid5 cache) and PPL (partial parity log), currently I have no idea
> where we will go for these two development activities.
> Also I receive reports from users that raid1 performance is desired when
> it is built on NVMe SSDs as a cache (maybe bcache or dm-cache). I am
> working on some raid1 performance improvement (e.g. new raid1 I/O
> barrier and lockless raid1 I/O submit), and have some more ideas to discuss.
>
> Therefore, if md raid developers may have a chance to sit together,
> discuss how to efficiently collaborate in next year, it will be much
> more productive then communicating on mailing list.

I would like to attend raid discussion, besides above topics I think we
can talk about improve the test suite of mdadm to make it more robust
(I can share related test suite which is used for clustered raid).

And I could share  the status of clustered raid about what we have done
and what we can do in the future. Finally, I'd like to know/discuss about
the roadmap of RAID.

Thanks a lot!
Guoqing
