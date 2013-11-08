From: "Dorau, Lukasz" <lukasz.dorau@intel.com>
Subject: RE: ISW fakeraid: fail to add back a disk previously removed
Date: Fri, 8 Nov 2013 14:33:24 +0000
Message-ID: <D9FFE20C522965449E182ACE73889AEB1A67FFF9@IRSMSX105.ger.corp.intel.com>
References: <CAC9WiBj5UO76MN3s0TgTLVKVAXJzY+eBxCMCYJWTp0JgdYogaQ@mail.gmail.com>
	<CAC9WiBiz+PTNQtv00RZUoBS30CaZwST+9W9K1SiPsVuze2MEcA@mail.gmail.com>
	<CAC9WiBjdLKmZ5koOr7R6yuYUiOYdVLDGjiRGssg8kK5RQ1fr0A@mail.gmail.com>
	<D9FFE20C522965449E182ACE73889AEB1A67F5CF@IRSMSX105.ger.corp.intel.com>
 <CAC9WiBjSh_OYb0k6zyWgeMdbkYzKxrpg9n2VD5RTgdOTNwcudg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAC9WiBjSh_OYb0k6zyWgeMdbkYzKxrpg9n2VD5RTgdOTNwcudg@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Francis Moreau <francis.moro@gmail.com>
Cc: NeilBrown <neilb@suse.de>, "Williams, Dan J" <dan.j.williams@intel.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Friday, November 08, 2013 2:46 PM Francis Moreau <francis.moro@gmail.com> wrote:
> > If you created a RAID array with mdadm, it would work correctly - recovery would
> > start.
> 
> Nope, I've got an identical behaviour if the array is created by mdadm (v3.3).
> 

I have checked it twice with Fedora 19 and mdadm v3.3 and it works.
What OS are you running?

> As you can see, I'm confused about ISW vs IMSM.
> 
> Are those 2 formats the same thing ?
> 

ISW is a name of Intel metadata used by dmraid and IMSM is a name of Intel metadata used by mdadm, but ISW in dmraid has not been supported and developed for a couple of years, so ISW might be called an old version of IMSM.

Lukasz

