From: Ming Lin <mlin@kernel.org>
Subject: Re: write performance of HW RAID VS MD RAID
Date: Wed, 10 Jun 2015 16:59:10 -0700
Message-ID: <CAF1ivSYYmc6O5=cRFtSCwq=s6sPZaoK9i-nm0qkeq0Y-Hfi_ZA@mail.gmail.com>
References: <CAF1ivSa644NVVd5R=2g8rvbZ-FK5cgXy_U1XJjYwMf+TJdftCw@mail.gmail.com>
	<20150611090054.18daac07@home.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150611090054.18daac07@home.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jun 10, 2015 at 4:00 PM, Neil Brown <neilb@suse.de> wrote:
> On Wed, 10 Jun 2015 15:27:07 -0700
> Ming Lin <mlin@kernel.org> wrote:
>
>> Hi NeilBrown,
>>
>> As you may already see, I run a lot of tests with 10 HDDs for the patchset
>> "simplify block layer based on immutable biovecs"
>>
>> Here is the summary.
>> http://minggr.net/pub/20150608/fio_results/summary.log
>>
>> MD RAID6 read performance is OK.
>> But write performance is much lower than HW RAID6.
>>
>> Is it a known issue?
>
> It is not unexpected.
> There are two likely reasons.
> One is that HW RAID cards often have on-board NVRAM which is used as a
> write-behind cache.  This allows better throughput by hiding latency and more
> often gathering full-stripe writes.  HW RAID cards may also have accelerators
> for the parity calculations, but that is not likely to make a big difference.
> What sort of RAID6 controller do you have?

PERC H730 Mini
