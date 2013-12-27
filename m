From: pg@lxra2.for.sabi.co.UK (Peter Grandi)
Subject: Re: Low resync throughput
Date: Fri, 27 Dec 2013 12:22:02 +0000
Message-ID: <21181.28906.59447.146830@tree.ty.sabi.co.uk>
References: <52BD152C.5050301@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52BD152C.5050301@ubuntu.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> I have been experimenting with setting up a raid array on 3
> new drives that are each capable of about 180 MB/s throughput.

I guess that if this a rotating disk drive "capable" is intended
here in the marketing sense of "cannot exceed". :-)

> I have tried raid5 and raid10 in both offset and far layouts
> using both 64k and 512k chunk sizes, and the resync speed
> seems to always be significantly less than the throughput of a
> single drive, even after I write 500,000 to sync_speed_max.
> The fastest of the bunch was raid10 in far mode, at ~140 MB/s,
> and the rest were around 110 MB/s.

The output of 'iostats -dx 1' might be interesting. :-)

Also as to RAID5 you might want to look at 'man mdadm' the
paragraph beginning "When creating a RAID5 array".
