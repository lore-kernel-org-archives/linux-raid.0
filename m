From: Francis Moreau <francis.moro@gmail.com>
Subject: Re: ISW fakeraid: fail to add back a disk previously removed
Date: Fri, 8 Nov 2013 14:45:51 +0100
Message-ID: <CAC9WiBjSh_OYb0k6zyWgeMdbkYzKxrpg9n2VD5RTgdOTNwcudg@mail.gmail.com>
References: <CAC9WiBj5UO76MN3s0TgTLVKVAXJzY+eBxCMCYJWTp0JgdYogaQ@mail.gmail.com>
	<CAC9WiBiz+PTNQtv00RZUoBS30CaZwST+9W9K1SiPsVuze2MEcA@mail.gmail.com>
	<CAC9WiBjdLKmZ5koOr7R6yuYUiOYdVLDGjiRGssg8kK5RQ1fr0A@mail.gmail.com>
	<D9FFE20C522965449E182ACE73889AEB1A67F5CF@IRSMSX105.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <D9FFE20C522965449E182ACE73889AEB1A67F5CF@IRSMSX105.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Dorau, Lukasz" <lukasz.dorau@intel.com>
Cc: NeilBrown <neilb@suse.de>, "Williams, Dan J" <dan.j.williams@intel.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello Lukasz

On Wed, Nov 6, 2013 at 3:08 PM, Dorau, Lukasz <lukasz.dorau@intel.com> wrote:

 [...]

>
> If you created a RAID array with mdadm, it would work correctly - recovery would
> start.

Nope, I've got an identical behaviour if the array is created by mdadm (v3.3).

> The IMSM metadata is not supported in dmraid anymore and mdadm does not have to
> work correctly with array created and started with dmraid.
>

I initially created the array with dmraid because it claims to support
ISW format whereas mdadm supports IMSM. I wanted to be sure that ISW
format was also supported by mdadm if the 2 formats were different.

As you can see, I'm confused about ISW vs IMSM.

Are those 2 formats the same thing ?

Thanks.
-- 
Francis
