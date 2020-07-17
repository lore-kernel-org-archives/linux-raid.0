From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: Re: [PATCH v4] md: improve io stats accounting
Date: Fri, 17 Jul 2020 12:44:24 +0200
Message-ID: <db93b8ae-25a1-5b50-7360-1f9c8e0661c3@intel.com>
References: <20200703091309.19955-1-artur.paszkiewicz@intel.com>
 <82ac5fe5-e61d-e031-6a64-60b6e1dd408d@cloud.ionos.com>
 <CAPhsuW4Xc19jJyxzOUcfoE+HrKH=bogC55=-dt04z6phn0Wu5Q@mail.gmail.com>
 <CAPhsuW6HjN0hZ8E998XBpg+WxP5uhZO0on-M-tQ45kpFO5XHqg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPhsuW6HjN0hZ8E998XBpg+WxP5uhZO0on-M-tQ45kpFO5XHqg@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <song@kernel.org>, Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 7/16/20 7:29 PM, Song Liu wrote:
> I just noticed another issue with this work on raid456, as iostat
> shows something
> like:
> 
> Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s
> avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
> nvme0n1        6306.50 18248.00  636.00 1280.00    45.11    76.19
> 129.65     3.03    1.23    0.67    1.51   0.76 145.50
> nvme1n1       11441.50 13234.00 1069.50  961.00    71.87    55.39
> 128.35     3.32    1.30    0.90    1.75   0.72 146.50
> nvme2n1        8280.50 16352.50  971.50 1231.00    65.53    68.65
> 124.77     3.20    1.17    0.69    1.54   0.64 142.00
> nvme3n1        6158.50 18199.50  567.00 1453.50    39.81    76.74
> 118.13     3.50    1.40    0.88    1.60   0.73 146.50
> md0               0.00     0.00 1436.00 1411.00    89.75    88.19
> 128.00    22.98    8.07    0.16   16.12   0.52 147.00
> 
> md0 here is a RAID-6 array with 4 devices. %util of > 100% is clearly
> wrong here.
> This only doesn't happen to RAID-0 or RAID-1 in my tests.
> 
> Artur, could you please take a look at this?

Hi Song,

I think it's not caused by this patch, because %util of the member
drives is affected as well. I reverted the patch and it's still
happening:

Device            r/s     rMB/s   rrqm/s  %rrqm r_await rareq-sz     w/s     wMB/s   wrqm/s  %wrqm w_await wareq-sz     d/s     dMB/s   drqm/s  %drqm d_await dareq-sz     f/s f_await  aqu-sz  %util
md0             20.00      2.50     0.00   0.00    0.00   128.00   21.00      2.62     0.00   0.00    0.00   128.00    0.00      0.00     0.00   0.00    0.00     0.00    0.00    0.00    0.00   0.00
nvme0n1         13.00      1.62   279.00  95.55    0.77   128.00    4.00      0.50   372.00  98.94 1289.00   128.00    0.00      0.00     0.00   0.00    0.00     0.00    0.00    0.00    5.17 146.70
nvme1n1         15.00      1.88   310.00  95.38    0.53   128.00   21.00      2.62   341.00  94.20 1180.29   128.00    0.00      0.00     0.00   0.00    0.00     0.00    0.00    0.00   24.80 146.90
nvme2n1         16.00      2.00   310.00  95.09    0.69   128.00   19.00      2.38   341.00  94.72  832.89   128.00    0.00      0.00     0.00   0.00    0.00     0.00    0.00    0.00   15.84 146.80
nvme3n1         18.00      2.25   403.00  95.72    0.72   128.00   16.00      2.00   248.00  93.94  765.69   128.00    0.00      0.00     0.00   0.00    0.00     0.00    0.00    0.00   12.26 114.30

I was only able to reproduce it on a VM, it doesn't occur on real
hardware (for me). What was your test configuration?

Thanks,
Artur
