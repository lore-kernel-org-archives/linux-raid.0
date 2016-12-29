From: Robert LeBlanc <robert@leblancnet.us>
Subject: Re: Intel SSD or other brands
Date: Thu, 29 Dec 2016 16:20:12 -0700
Message-ID: <CAANLjFrrJBKcpV=CyZ7oKAY6OOwLqR5Qtk4OB8ugJ+edyGPMyw@mail.gmail.com>
References: <0329d841-984b-fa25-0bf2-0aba4d55b6de@websitemanagers.com.au>
 <CAANLjFo4tP9Xdv8JX5waNOu_34zWDKsQqOru3fpt2wOAJuZYcQ@mail.gmail.com> <65bda7a8-f74f-be87-2490-f6c0b1c5c3f1@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <65bda7a8-f74f-be87-2490-f6c0b1c5c3f1@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Dec 29, 2016 at 4:04 PM, Adam Goryachev
<mailinglists@websitemanagers.com.au> wrote:
> On 30/12/16 03:56, Robert LeBlanc wrote:
>>
>> This is a similar workload as Ceph and you may find more information
>> from their mailing lists. When I was working with Ceph about a year
>> ago, we tested a bunch of SSDs and found that sync=1 really
>> differentiates drives and you really find which drives are better. In
>> our testing, we found that the 35xx, 36xx, and 37xx drives handled the
>> workloads the best. The 3x00 drives were close to EOL, so we focused
>> on the 3x10 drives. I don't have the data anymore, but the 3610 had
>> the best performance, the 3710 had the best data integrity in the case
>> of power failure, and the 3510 had the best price.
>
> So it seems that my "good/best" results were based on the 3510, which was
> the cheapest out of the options you tested. Any chance you could find the
> raw data again? Or do you recall the relative performance difference between
> these three drives?

This was done at another job and the data stayed when I left. The
performance between the three drives were pretty close, I think less
than 10%, but I can't remember exactly.

>> The 3510 had about
>> ~.1 drive writes per day, the 3610 had ~1 DWPD and the 3710 had ~3
>> DWPD.
>
> We seem to be around 0.03 DWPD, so I don't think any of these drives would
> be a problem for us. Lifetime seems much longer than the useful life, given
> capacity/etc.

We had really good wear on the 35xx drives, I think they are
understated, but I don't have the data to back that up.

>> Due to the fault tolerance of Ceph, we felt comfortable with the
>> 3610s.
>
> Equally, we have fault tolerance (RAID5) as well as DRBD onto the other node
> which also has RAID5. I also monitor the drive lifetime, I'm not sure what
> value I would consider urgent replacement, but probably around 20% remaining
> life....

You may never even get there at 0.03 DWPD.

>> In our testing, we exceeded the performance numbers listed for
>> the drives on their data sheets when running up to 8 jobs even with
>> sync=1 which no other manufacture did. For Ceph, we could put multiple
>> OSDs on a disk and take advantage of this performance gain. You may be
>> able to do something similar by partitioning your RAID 5 and putting
>> multiple DRBDs on it.
>
>
> We do this already... we use a single RAID5 which is split with LVM2 (20
> LV's), and each LV is then a DRBD device (so 20 DRBD's). This was one of the
> optimisations linbit advised us to do way back at the beginning.
>
> The problem I'm having is that a single DRBD will reach saturation because
> the underlying devices are saturated. So I'm trying to improve the
> underlying device performance, and expect to be able to "move" the
> bottleneck to DRBD or hopefully, the ethernet of the iSCSI interface.
>
> Regards,
> Adam

----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
