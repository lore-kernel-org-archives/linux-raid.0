From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: What can be used instead of /dev/disk/by-path/* symlinks?
Date: Tue, 7 Jan 2014 14:39:46 -0800
Message-ID: <CAA9_cmdgS-zQdtN1Z6tk5Lb4a3uMSJBKKTdVtmZMvDNAsgoKSQ@mail.gmail.com>
References: <D9FFE20C522965449E182ACE73889AEB1A69A1E3@IRSMSX105.ger.corp.intel.com>
	<20131217204055.353e5970@notabene.brown>
	<D9FFE20C522965449E182ACE73889AEB1A69A280@IRSMSX105.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <D9FFE20C522965449E182ACE73889AEB1A69A280@IRSMSX105.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Dorau, Lukasz" <lukasz.dorau@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Baldysiak, Pawel" <pawel.baldysiak@intel.com>
List-Id: linux-raid.ids

On Tue, Dec 17, 2013 at 2:02 AM, Dorau, Lukasz <lukasz.dorau@intel.com> wrote:
> On Tuesday, December 17, 2013 10:41 AM Neil Brown (neilb@suse.de) wrote:
>> On Tue, 17 Dec 2013 09:10:44 +0000 "Dorau, Lukasz" <lukasz.dorau@intel.com>
>> wrote:
>>
> [...]
>> Personally, I really don't care.  Does anyone know what udev changed?  Maybe
>> we should ask udev developers to change it back.
>>
>> NeilBrown
>>
>
> udev developers wrote:
> http://cgit.freedesktop.org/systemd/systemd/tree/src/udev/udev-builtin-path_id.c#n378
>
>         /*
>          * We do not support the ATA transport class, it uses global counters
>          * to name the ata devices which numbers spread across multiple
>          * controllers.
>          *
>          * The real link numbers are not exported. Also, possible chains of ports
>          * behind port multipliers cannot be composed that way.
>          *
>          * Until all that is solved at the kernel level, there are no by-path/
>          * links for ATA devices.
>          */
>

Seems relatively straightforward to add a hardware port number
attribute to the ata_port.  I think the same could be done ata_link,
right?
