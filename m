From: Dan Williams <djbw@fb.com>
Subject: Re: Recovery/Access of imsm raid via mdadm?
Date: Thu, 10 Jan 2013 17:42:54 -0800
Message-ID: <CAA9_cmfD6GS1Bdg2OKcyBxCRicHvO__wXSYzmSE40mGA=ace8Q@mail.gmail.com>
References: <CAKnNFz96pxExLDpoX1Yi+m0ASb-pV9eUVwZ7xmNQE9LnQHWT_g@mail.gmail.com>
	<50EEF5E4.8070509@intel.com>
	<CAKnNFz9arLw6NBr4y0E3T+tGc6E5F5CZdGtRjSjwZcSgyyLtgw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAKnNFz9arLw6NBr4y0E3T+tGc6E5F5CZdGtRjSjwZcSgyyLtgw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: chris <tknchris@gmail.com>
Cc: Dave Jiang <dave.jiang@intel.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Jan 10, 2013 at 12:19 PM, chris <tknchris@gmail.com> wrote:
> Hi Dave,
>
> Thanks for the tip, this has gotten me further
>
> # mdadm --assemble --scan
> # cat /proc/mdstat
> Personalities :
> md127 : inactive sdd[1](S) sdb[0](S)
>       4520 blocks super external:imsm
>
> So atleast now it has created an array of sorts but it only has 2 out
> of the 4 disks it should and also all disks appear to be marked as
> spares.
>
> Would I follow the same logic as typical mdadm recovery where I need
> to create the array again with the right layout and disks in right
> order and gain access to data without wiping it ?
>
> Any advice what direction to go in from here?
>

Backup the disks you have if possible.

Don't recreate the array with all 4 disks be sure to specify a missing
slot.  With mdadm-3.2.5 you do have support for creating imsm arrays
with 'missing' slots [1].  Then you can test some recreations to see
if you can find data.

At a minimum you know that sdb and sdd are in slot 2, 3, so the
question is finding a good candidate for slot 0, or 1.  It's a bit
concerning that the superblocks for those have been lost, or those
disks weren't moved over?  You can look for serial numbers in
/dev/disks/by-id.

--
Dan

[1]: http://marc.info/?l=linux-raid&m=131432484118038&w=2
