From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: ISW fakeraid: fail to add back a disk previously removed
Date: Fri, 8 Nov 2013 14:02:08 -0800
Message-ID: <CAPcyv4j-Pn-+0uAf+3A9JnnSxcjeQGyPjV_h=mWdhGkZuEM2yA@mail.gmail.com>
References: <CAC9WiBj5UO76MN3s0TgTLVKVAXJzY+eBxCMCYJWTp0JgdYogaQ@mail.gmail.com>
	<CAC9WiBiz+PTNQtv00RZUoBS30CaZwST+9W9K1SiPsVuze2MEcA@mail.gmail.com>
	<CAC9WiBjdLKmZ5koOr7R6yuYUiOYdVLDGjiRGssg8kK5RQ1fr0A@mail.gmail.com>
	<D9FFE20C522965449E182ACE73889AEB1A67F5CF@IRSMSX105.ger.corp.intel.com>
	<CAC9WiBjSh_OYb0k6zyWgeMdbkYzKxrpg9n2VD5RTgdOTNwcudg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAC9WiBjSh_OYb0k6zyWgeMdbkYzKxrpg9n2VD5RTgdOTNwcudg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Francis Moreau <francis.moro@gmail.com>
Cc: "Dorau, Lukasz" <lukasz.dorau@intel.com>, NeilBrown <neilb@suse.de>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Nov 8, 2013 at 5:45 AM, Francis Moreau <francis.moro@gmail.com> wrote:
> Hello Lukasz
>
> On Wed, Nov 6, 2013 at 3:08 PM, Dorau, Lukasz <lukasz.dorau@intel.com> wrote:
>
>  [...]
>
>>
>> If you created a RAID array with mdadm, it would work correctly - recovery would
>> start.
>
> Nope, I've got an identical behaviour if the array is created by mdadm (v3.3).

It should really work either way.  I gave it a shot with:

mdadm - v3.3-30-gf33a71f - 31st October 2013
mdadm - v3.2.5 - 18th May 2012

...and it seems ok with loop devices, so something more fundamental is wrong.

mdmon is in charge of finding new devices in the container and adding
them to the member arrays.  Can you confirm that mdmon is running when
the disk is failing to be added?

The IMSM format is sensitive to disk serial numbers, I'm curious if
your virtual disks are specifying unique serial numbers for your
devices?  In my above tests with loopback devices I am using
IMSM_DEVNAME_AS_SERIAL=1 for debug purposes you might try that as
well.

--
Dan
