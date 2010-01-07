From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: linux-raid raid5 delaying write
Date: Thu, 7 Jan 2010 10:44:09 -0700
Message-ID: <e9c3a7c21001070944iea98871tb2b42e942c14b87@mail.gmail.com>
References: <6c394cc31001070418w60785400v77e0e7a47b0732fc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6c394cc31001070418w60785400v77e0e7a47b0732fc@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: dong wu <dongwucs@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Jan 7, 2010 at 5:18 AM, dong wu <dongwucs@gmail.com> wrote:
> hello,
> In the source code,in order to collect multiple write requests,first
> add the requests to delayed_list,
> then use plug/unplug to wait.During the waiting time,if other requests
> arrive to full a stripe_head buffer,
> then compute parity and send write request to low level to deal.
> If not so, the requests will be set pre-read mark
> stripe_preread_active,then send pre-read request to low level.
> I want to know if up level send read request and later a write request
> arrive to write the same place of read request before,
> will the read request be canceled and return the data of write request?

No, it is up to the filesystem or whatever code is above the RAID to
enforce ordering.  In order to guarantee that a read returns the data
from a previous write you either need to wait for the write to
complete, or with recent kernels send a barrier request to flush the
write.

--
Dan
