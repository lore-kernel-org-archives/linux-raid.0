From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 12/17] imsm: create mdinfo list of disks in a container
 from supertype
Date: Thu, 04 Nov 2010 22:52:50 -0700
Message-ID: <4CD39BB2.7020505@intel.com>
References: <A9DE54D0CD747C4CB06DCE5B6FA2246F010BAF0FCF@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A9DE54D0CD747C4CB06DCE5B6FA2246F010BAF0FCF@irsmsx504.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Cc: Neil Brown <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>
List-Id: linux-raid.ids

On 10/29/2010 7:24 AM, Czarnowska, Anna wrote:
>  From 882ad1e86e09304ce244d063e64fa1cc65fcc799 Mon Sep 17 00:00:00 2001
> From: Anna Czarnowska<anna.czarnowska@intel.com>
> Date: Wed, 27 Oct 2010 12:00:28 +0200
> Subject: [PATCH 12/17] imsm: create mdinfo list of disks in a container from supertype
>
> If getinfo_super is called on a container supertype we only get information
> on first disk. As a parameter it uses reference to preallocated
> mdinfo structure. Amending getinfo_super to return full list of disks
> would require ammending all previous calls and subsequently freeing memory
> allocated for mdinfo list.
> Function container_content that returns a mdinfo list is written
> specifically for assembly, performing actions not needed to just fill
> mdinfo. It also does not include spares so is unsuitable.
> As an alternative a new function getinfo_super_disks is created
> to obtain information about all disks states in array.
> Existing function sysfs_free is used to free memory
> allocated by getinfo_super_disks.
>
> Signed-off-by: Anna Czarnowska<anna.czarnowska@intel.com>
> Signed-off-by: Marcin Labun<marcin.labun@intel.com>

Yes, this is needed, but is an example of something that can hopefully 
go away after Neil's rework of the data structures returned from a load 
operation.  We shouldn't need a custom routine to retrieve this list. 
It should be available directly from the supertype.
