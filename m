From: Phil Turmel <philip@turmel.org>
Subject: Re: Which physical device failed?
Date: Wed, 27 May 2015 14:38:47 -0400
Message-ID: <55660F37.8000402@turmel.org>
References: <5565B2BB.5090701@gmail.com>	<5565B41B.8040104@aei.mpg.de>	 <20150527172701.1090e525@natsu> <5565C3AA.7020809@turmel.org> <BLU436-SMTP2403ED333F23D8DB23296C398CB0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BLU436-SMTP2403ED333F23D8DB23296C398CB0@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: "Wilson, Jonathan" <piercing_male@hotmail.com>
Cc: Roman Mamedov <rm@romanrm.net>, Carsten Aulbert <Carsten.Aulbert@aei.mpg.de>, Michael Munger <michael.munger@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Jonathan,

On 05/27/2015 02:16 PM, Wilson, Jonathan wrote:
> On Wed, 2015-05-27 at 09:16 -0400, Phil Turmel wrote:
>> This is one of the reasons I wrote lsdrv [1], especially after I noticed
>> that the port sequence it reports is stable for the various ports on
>> every mobo  and sata expansion card I've handled.  Per controller, at least.
> 
> Interesting that you should say that as on my z97 board if I do a power
> off, power on, the drives do indeed stay numbered to the sata ports...
> however if I do a "restart" sometimes, very rarely, the drives are
> listed with different sdX designations. It may be a quirk of either the
> efi, linux, or the fact the drives are not, I believe, turned off during
> a restart which may impact on designation. I didn't investigate the whys
> as I just noticed that two drives had swapped in two arrays (sdb moved
> from a raid10 into the raid6 and that sdc moved from the raid6 into the
> raid10) which scared the heck out of me until I realised that it was
> just the sdX that had changed not the drives so for one minute I was
> expecting massive problems to ensue.

I didn't say the names are consistent--in fact, your experience is
entirely normal with modern kernel's device discovery.  The names come
out the same for many people by chance (timing, interrupts, whatever).
But a new kernel might have slight differences, and then the names change.

My comment was referring to the SCSI LUNs "N:P:Q:R" that appear under
each controller in lsdrv.  These correspond to the hostN/targetP:Q:R
folders in sysfs.  P:Q:R appears to reliably correspond to physical
ports. Sometimes with phantom ports, but reliably so.  Which is why
lsdrv shows them in order, even if empty.  For the controllers I've
played with so far, that is.  Consider labeling your cables with the
mobo or adapter's silkscreened port ID and the corresponding P:Q:R string.

Anyways, MD uses the superblock metadata to make sure array members are
properly assembled regardless what name they have at any moment.  LVM
does so as well.  The mdadm --detail report that shows kernel names
cannot be trusted across boots or between kernel versions.

If you are using /dev/sdX names in fstab or mdadm.conf, you may be
surprised by a boot failure at some point.

Phil
