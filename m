From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: How to boost performance
Date: Thu, 17 Jun 2010 01:17:04 -0700
Message-ID: <AANLkTinlrOPupUaMzeh6YazTpXiRmbci__QK5QQrkqQp@mail.gmail.com>
References: <ea83c7a1ddca01e0a1535f130502a0f2.squirrel@www.dcsnow.com>
	<20100617100109.32a20ffa@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100617100109.32a20ffa@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <roman@rm.pp.ru>
Cc: aragonx@dcsnow.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jun 16, 2010 at 9:01 PM, Roman Mamedov <roman@rm.pp.ru> wrote:
> On Wed, 16 Jun 2010 18:23:36 -0400
> aragonx@dcsnow.com wrote:
>
>> Before I start spewing server information, my question is this. =A0I=
s there
>> anything I can tweak to improve my performance? =A0It seems that the=
 server
>> is CPU bound when I am transferring large amounts of data to or from=
 it.
>> Any suggestions will be considered. =A0Faster processor, switching t=
o RAID
>> 0, etc. =A0I'm hoping there is something I can do with the RAID soft=
ware
>> though. =A0Maybe a different chunk size or different algorithm?
>
> Increasing stripe cache size from the default of 256 should help imme=
nsely.
>
> echo 16384 > /sys/block/md0/md/stripe_cache_size
>
> Be warned that this consumes (^that amount * 4096 * number of disks) =
bytes of
> RAM. Some benchmarks:
>
> http://peterkieser.com/2009/11/29/raid-mdraid-stripe_cache_size-vs-wr=
ite-transfer/
>
> On a related note -- Neil, are there plans to implement a stripe cach=
e which
> would be shared between all RAID devices? I have two RAID5s in my sys=
tem, and
> when one has a lot of writes, the other is often idle (or vice versa)=
, so that
> array's stripe cache is just sitting there wasting memory. Would be n=
ice to
> be able to have a shared pool of RAM for stripe-caching all the array=
s and
> the active one(s) using it to the fullest.
>
> --
> With respect,
> Roman
>

Yet another idea; does your stripe (easily) fit within your CPU's
cache?  (This way you can process transactions at CPU speed, and spend
the rest of the wait time for the next stripe's delivery on other
threads that aren't blocked.  Actually I should benchmark this to see
if I'm correct...)

I second the idea of shared stripe caches.  However I suggest that
there also be an extra parameter via another file to determine
stripe-cache-id (initially 0 or something).

Also, the above formula for stripe-cache-size use, as well as what the
other sysfs files do, should be noted in the manpages or someplace the
manpage points to.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
