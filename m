From: Dan Williams <djbw@fb.com>
Subject: Re: Recovery/Access of imsm raid via mdadm?
Date: Sun, 13 Jan 2013 21:05:16 +0000
Message-ID: <84A937D219C2B44EB8EA44831ACA1E4916D902C5@PRN-MBX02-3.TheFacebook.com>
References: <CAKnNFz_25zLMquBphPb8xx=rrG2BquXjLuc1-ke+1ztoVaUOgA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAKnNFz_25zLMquBphPb8xx=rrG2BquXjLuc1-ke+1ztoVaUOgA@mail.gmail.com>
Content-Language: en-US
Content-ID: <CACA5BD6CF31084BBC42A9DE87312EF6@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: chris <tknchris@gmail.com>, Neil Brown <neilb@suse.de>
Cc: Dave Jiang <dave.jiang@intel.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



On 1/13/13 11:00 AM, "chris" <tknchris@gmail.com> wrote:

>Neil/Dave,
>
>Is it not possible to create imsm container with missing disk?
>If not, Is there any way to recreate the array with all disks but
>prevent any kind of sync which may overwrite array data?

The example was in that link I sent:

mdadm --create /dev/md/imsm /dev/sd[bde] -e imsm
mdadm --create /dev/md/vol0 /dev/sde missing /dev/sdb /dev/sdd -n 4 -l 5

The first command marks all devices as spares.  The second creates the
degraded array.
 
You probably want at least sdb and sdd in there since they have a copy of
the metadata.

--
Dan

