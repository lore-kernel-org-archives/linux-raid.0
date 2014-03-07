From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: calculating optimal chunk size for Linux software-RAID
Date: Fri, 07 Mar 2014 17:58:39 -0600
Message-ID: <531A5D2F.3010002@hardwarefreak.com>
References: <CAJx5YvHVrWgcOCOh2q95RLcDcq5bkev0uqyStj=Op3DCjNhTGw@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJx5YvHVrWgcOCOh2q95RLcDcq5bkev0uqyStj=Op3DCjNhTGw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Martin T <m4rtntns@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 3/6/2014 8:06 PM, Martin T wrote:
> Am I correct that optimal chunk size is usually the size of the
> average file read/written to disk divided by number of block devices
> in RAID array storing the data? For example if the average file size
> is 1024KiB and I have four disks in RAID1, then I should choose the
> chunk size around 256KiB to get the optimal read performance? Or if I
> have two drives in RAID0, then I should choose the chunk size 512KiB
> instead? Or are there better methods/benchmarks to determine the
> optimal chunk size for software-RAID? 

You're asking the wrong question.  Storage architecture design always
begins with the workload.  The correct question is:

My workload (application mix) performs *most* IO in manner X, where X is

1.  large streaming write/read
2.  small file write/read
3.  metadata heavy

I have Y number of disk drives.  I plan to use XFS/EXT4/etc filesystem.
 What RAID level and chunk size are optimal for my workload, and how do
I properly tune my filesystem to my workload and storage stack?

> Last but not least, is there a
> good utility which could help one to measure the average I/O
> read/write size?

In flight IO size has no correlation to stripe and chunk size.  What you
need to know is how your application(s) write to the filesystem and how
your filesystem issues write IOs.  You should already know that the
former, and it's easy to determine the latter.

-- 
Stan
