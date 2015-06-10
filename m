From: Neil Brown <neilb@suse.de>
Subject: Re: write performance of HW RAID VS MD RAID
Date: Thu, 11 Jun 2015 09:00:54 +1000
Message-ID: <20150611090054.18daac07@home.neil.brown.name>
References: <CAF1ivSa644NVVd5R=2g8rvbZ-FK5cgXy_U1XJjYwMf+TJdftCw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAF1ivSa644NVVd5R=2g8rvbZ-FK5cgXy_U1XJjYwMf+TJdftCw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ming Lin <mlin@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 10 Jun 2015 15:27:07 -0700
Ming Lin <mlin@kernel.org> wrote:

> Hi NeilBrown,
> 
> As you may already see, I run a lot of tests with 10 HDDs for the patchset
> "simplify block layer based on immutable biovecs"
> 
> Here is the summary.
> http://minggr.net/pub/20150608/fio_results/summary.log
> 
> MD RAID6 read performance is OK.
> But write performance is much lower than HW RAID6.
> 
> Is it a known issue?

It is not unexpected.
There are two likely reasons.
One is that HW RAID cards often have on-board NVRAM which is used as a
write-behind cache.  This allows better throughput by hiding latency and more
often gathering full-stripe writes.  HW RAID cards may also have accelerators
for the parity calculations, but that is not likely to make a big difference.
What sort of RAID6 controller do you have?

The other is that it is not easy for MD/RAID6 to schedule writes stripes
optimally.  It doesn't really know if more writes are coming, so it should
wait, or if it already has everything - so it should get to work straight away.
It is possible that it could reply to writes as soon as they are in the
(volatile) cache and only force things to storage when a REQ_FUA or REQ_FLUSH
arrives.  That might help ... or it might corrupt filesystems :-(

As long as the patches don't make things obviously worse, I'm happy.

Thanks,
NeilBrown
