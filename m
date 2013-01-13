From: chris <tknchris@gmail.com>
Subject: Re: Recovery/Access of imsm raid via mdadm?
Date: Sun, 13 Jan 2013 14:00:30 -0500
Message-ID: <CAKnNFz_25zLMquBphPb8xx=rrG2BquXjLuc1-ke+1ztoVaUOgA@mail.gmail.com>
References: <CAKnNFz96pxExLDpoX1Yi+m0ASb-pV9eUVwZ7xmNQE9LnQHWT_g@mail.gmail.com>
	<50EEF5E4.8070509@intel.com>
	<CAKnNFz9arLw6NBr4y0E3T+tGc6E5F5CZdGtRjSjwZcSgyyLtgw@mail.gmail.com>
	<CAA9_cmfD6GS1Bdg2OKcyBxCRicHvO__wXSYzmSE40mGA=ace8Q@mail.gmail.com>
	<CAKnNFz8sZta4Y0eoP1BN8yhdSasqAAx4W+cQs6woVmEdvyqP4A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAKnNFz8sZta4Y0eoP1BN8yhdSasqAAx4W+cQs6woVmEdvyqP4A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Dan Williams <djbw@fb.com>, Dave Jiang <dave.jiang@intel.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil/Dave,

Is it not possible to create imsm container with missing disk?
If not, Is there any way to recreate the array with all disks but
prevent any kind of sync which may overwrite array data?

Any other ideas where to go from here?

thanks
chris

On Fri, Jan 11, 2013 at 12:53 PM, chris <tknchris@gmail.com> wrote:
> Ok so I looked through the examine data and it appears the order of
> the disks was:
>
> sde 0 - Z1E1AKPH
> sdc 1 - Z24091Q5
> sdb 2 - Z1E1RPA9
> sdd 3 - Z1E19E4K
>
> So I was going to try the first possible combination and assemble with
> sde/sdc/sdb/missing, this is what I tried:
>
> # export IMSM_NO_PLATFORM=1
> # mdadm --create --verbose /dev/md/imsm /dev/sde /dev/sdc /dev/sdd
> missing --raid-devices 4 --metadata=imsm
> mdadm: /dev/sde appears to be part of a raid array:
>     level=raid0 devices=0 ctime=Thu Jan  1 00:00:00 1970
> mdadm: metadata will over-write last partition on /dev/sde.
> mdadm: /dev/sdc appears to be part of a raid array:
>     level=raid0 devices=0 ctime=Thu Jan  1 00:00:00 1970
> mdadm: metadata will over-write last partition on /dev/sdc.
> mdadm: /dev/sdd appears to be part of a raid array:
>     level=container devices=0 ctime=Thu Jan  1 00:00:00 1970
> mdadm: metadata will over-write last partition on /dev/sdd.
> mdadm: size set to 1953511431K
> Continue creating array? y
> mdadm: This level does not support missing devices
>
> The example commands I found for creating imsm array were like this:
> mdadm --create --verbose /dev/md/imsm /dev/sde /dev/sdc /dev/sdd
> missing --raid-devices 4 --metadata=imsm
> mdadm --create --verbose /dev/md/Volume0 /dev/md/imsm --raid-devices 4 --level 5
>
> Should I be defining level=5 when creating /dev/md/imsm also? Or
> should I only do it for imsm container and omit it from creating
> /dev/md/Volume0?
>
> thanks for everything so far I feel like I'm pretty close, once I can
> get the arrays up with missing and dont have to worry about
> overwriting anything then I'm sure I can work out the right
> combination of disks and hopefully the disks with no imsm metadata
> arent so damaged I cant recover
>
> chris
>
> On Thu, Jan 10, 2013 at 8:42 PM, Dan Williams <djbw@fb.com> wrote:
>>
>>>
