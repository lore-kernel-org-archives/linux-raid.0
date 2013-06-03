From: Dan Williams <dan.j.williams@gmail.com>
Subject: Re: RAID-10 keeps aborting
Date: Sun, 2 Jun 2013 22:47:22 -0700
Message-ID: <CAA9_cmddLfReYeAhgwh5=j6ELMBNx5Oq7Gg8K+fo0PneaEfrVA@mail.gmail.com>
References: <51AC1440.7020505@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51AC1440.7020505@zytor.com>
Sender: linux-raid-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, Jun 2, 2013 at 8:57 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Hello,
>
> I have a brand new server with a RAID-10 array.  The drives are a SAS
> JBOD (mptsas) which I'm driving using Linux mdraid raid10.
>
> Unfortunately, although the server did burn-in fine, once put in
> production I have so far had multiple cases (about once every 24 hours)
> of the raid10 failing, with a mirror pair dropping out in very short
> succession:
>
> Jun  2 20:23:05 terminus kernel: [83595.614689] md/raid10:md4: Disk
> failure on sdb6, disabling device.
> Jun  2 20:23:05 terminus kernel: [83595.614689] md/raid10:md4: Operation
> continuing on 3 devices.
> Jun  2 20:23:05 terminus kernel: [83595.703106] md/raid10:md4: Disk
> failure on sdc6, disabling device.
> Jun  2 20:23:05 terminus kernel: [83595.703106] md/raid10:md4: Operation
> continuing on 2 devices.
> Jun  2 20:23:05 terminus kernel: [83595.789234] md4: WRITE SAME failed.
> Manually zeroing.
>
> Unfortunately, those two devices that just dropped out are of course the
> mirrors of each other, causing filesystem corruption and shutdown in
> very short order.
>
> There are no other kernel messages from the same time, and given the
> timing (less than 90 ms apart) it would appear that this is a timeout of
> some kind and not an actual disk failure.

Looks like the underlying devices just may not support write_same...
if the device lies about support we don't find about it until the
first attempt fails and md drops the devices.

> Are there any tunables I can tweak, or do I have a $4000 paperweight?

One hack to prove this may be to explicitly disable write_same before
the array is assembled:

for i in /sys/class/scsi_disk/*/max_write_same_blocks; do echo 0 > $i; done

If this works then maybe md needs to be tolerant of write_same
failures since the block layer will simply retry with zeroes.

--
Dan
