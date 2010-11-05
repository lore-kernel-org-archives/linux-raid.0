From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 09/17] Monitor: avoid skipping checks on external arays
Date: Fri, 05 Nov 2010 09:17:17 -0700
Message-ID: <4CD42E0D.7020700@intel.com>
References: <A9DE54D0CD747C4CB06DCE5B6FA2246F010BAF0FC9@irsmsx504.ger.corp.intel.com> <4CD39A5F.2050703@intel.com> <A9DE54D0CD747C4CB06DCE5B6FA2246F010BC6D48D@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A9DE54D0CD747C4CB06DCE5B6FA2246F010BC6D48D@irsmsx504.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Cc: Neil Brown <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>
List-Id: linux-raid.ids

On 11/05/2010 07:56 AM, Czarnowska, Anna wrote:
> Metadata_version is needed for:
> 	Deciding if metadata type is container-based - more than just the utime check depends on it
> 	Getting parent container number from subarrays - for linking subarrays with containers
> 	Obtaining superswitch - to avoid calling guess_super when we already know the kind of metadata
>
> Introducing utime_valid flag would just duplicate part of information included in metadata_version.
> Regards
> Anna

Ah, ok reading this patch in isolation does not convey these future 
usages.  We could put this text in the changelog.

