From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: [PATCH] imsm: Forbid spanning between multiple controllers.
Date: Wed, 16 Jan 2013 08:49:22 +0000
Message-ID: <50F66992.7090400@anonymous.org.uk>
References: <20121109144636.2215.91684.stgit@localhost.localdomain> <50EF3961.5050306@ubuntu.com> <8565BDA60DEA9E4C91B1047AD1958FBE1DEC8F5B@IRSMSX104.ger.corp.intel.com> <50F419F2.9050809@ubuntu.com> <679865E03F4C71419D9847EA3AACB16316215258@IRSMSX102.ger.corp.intel.com> <50F56E52.1090302@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50F56E52.1090302@ubuntu.com>
Sender: linux-raid-owner@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>
Cc: "Patelczyk, Maciej" <maciej.patelczyk@intel.com>, "Tomczak, Marcin" <marcin.tomczak@intel.com>, "neilb@suse.de" <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Dorau, Lukasz" <lukasz.dorau@intel.com>
List-Id: linux-raid.ids

On 15/01/2013 14:57, Phillip Susi wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> On 1/15/2013 5:31 AM, Patelczyk, Maciej wrote:
>> Hi Phillip,
>>
>> Mdadm does not care about the controller unless you created IMSM
>> based RAID. Basically you can create that type of RAID *only* on
>> Intel based platforms with OROM enabled. It's Intel solution, we
>> support it and we maintain it. It's very specific type of metadata.
[...]
>
> Warnings about potentially troublesome situations are good, but
> outright refusal is not.  Yes, I realize it would be a problem for
> Windows due to the poor way the driver has to be implemented ( why
> can't the OROM see other disks on other controllers? ), but sometimes
> you don't care about that.  For instance, if you are setting up the
> array on one machine where you can not connect all of the drives to
> the same controller ( and do not care about booting from the array on
> this machine ), but you are planning on moving them to a machine where
> they will be.  This is just one example of many situations where you
> need to be able to say "I know what I'm doing, go ahead anyway".

Isn't there, or wasn't there, an environment variable for mdadm called 
something like IMSM_PLATFORM_IGNORE for precisely this scenario? Is that 
what this patch series disabled?

Cheers,

John.

