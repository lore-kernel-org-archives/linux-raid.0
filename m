From: Alexander 'Leo' Bergolth <leo@strike.wu.ac.at>
Subject: Re: Align lvm or dm-crypt to stripe or chunk size?
Date: Tue, 05 Feb 2013 17:25:41 +0100
Message-ID: <51113285.20709@strike.wu.ac.at>
References: <50F7C5F4.8080501@strike.wu.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50F7C5F4.8080501@strike.wu.ac.at>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 01/17/2013 10:35 AM, Alexander 'Leo' Bergolth wrote:
> If using some kind of container like lvm or dm-crypt that has a
> data-offset inside my md device...
> Do I need to align the data offset to the stripe size (chunk-size*number
> of data-bearing disks) or just to the chunk size?
> 
> If aligning to the chunk size is sufficient, could anyone give an
> explanation? Doesn't this break filesystem alignment inside the
> container? (I.e. the --stripe-width option)

I've done some benchmarks using a raid-6 md-device (5 disks, 64k
chunksize) with lvm (different data-offsets) and ext4 on top.

The ext4 filesystem is always aligned to the array
(stride=16,stripe-width=48) but the data offset of the lvm physical
volume is either the default of 2048 sectors (which isn't a multiple of
the stripe size of 3*64k) or 384 sectors (3 data bearing disks * 64k
chunks).

The results are available at
http://leo.kloburg.at/tmp/raid-dataoffsets/

It looks like it doesn't make any difference if the data offset is a
multiple of the stripe size or just of the chunk size.

But why doesn't a wrong data-offset break the --stripe-width hint given
to mkfs.ext4???

I'd really appreciate if someone could shed some light on that.

Thanks,
--leo

P.S.: The benchmarks were done with bonnie++, details can be found in
bench.sh at the above URL.

-- 
e-mail   ::: Leo.Bergolth (at) wu.ac.at
fax      ::: +43-1-31336-906050
location ::: IT-Services | Vienna University of Economics | Austria

