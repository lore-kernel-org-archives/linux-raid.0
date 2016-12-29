From: pg@lxra2.for.sabi.co.UK (Peter Grandi)
Subject: Re: Intel SSD or other brands
Date: Thu, 29 Dec 2016 17:33:17 +0000
Message-ID: <22629.18653.431222.163351@tree.ty.sabi.co.uk>
References: <0329d841-984b-fa25-0bf2-0aba4d55b6de@websitemanagers.com.au>
        <CAANLjFo4tP9Xdv8JX5waNOu_34zWDKsQqOru3fpt2wOAJuZYcQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAANLjFo4tP9Xdv8JX5waNOu_34zWDKsQqOru3fpt2wOAJuZYcQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> [ ... ] sync=1 really differentiates drives and you really
> find which drives are better. [ ... ]

It is not necessarily "better" in a strict sense: flash SSD
devices with supercapacitor-backed persistent caches can be much
faster on 'fsync' heavy workloads, but also cost a lot more
(probably mostly because of market segmentation). Of course
especially on a RAID5 set with lots of read-modify-write.

It is a different performance envelope, not necessarily a
"better" one. If one does not need small-write speed then
cheaper drivers are more appropriate.

However devices which don't have persistent caches and still
have high 'sync=1'/'direct=1' speed because they don't implement
'fsync' synchronously are definitely worse, in the sense of
having arguably no performance at all.

Some manufacturers think that using an SLC cache helps without a
persistent-ed RAM cache, but the persistent=-ed RAM seems a lot
better to me.
