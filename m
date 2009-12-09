From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [mdadm PATCH v3] Fix required to enable RAID arrays on SAS disks.
Date: Wed, 09 Dec 2009 10:37:17 -0700
Message-ID: <4B1FE04D.1040900@intel.com>
References: <20091209171552.29567.94832.stgit@awojcik-linux> <20091209172757.GA21495@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091209172757.GA21495@skl-net.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: "Wojcik, Artur" <artur.wojcik@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "neilb@suse.de" <neilb@suse.de>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

Andre Noll wrote:
> On 18:15, Artur Wojcik wrote:
>> The patch increases the capacity of buffers used to store
>> sysfs path names. Originally the buffers were too small to
>> hold the canonical representation of sysfs path (in case
>> of a SAS device, especially a device installed behind an
>> expander).
>>
>> Signed-off-by: Artur Wojcik <artur.wojcik@intel.com>
> 
> Looks good. Feel free to add my acked-by/reviewed-by.

Thanks for the review.  I'll queue this up for my next pull request.

--
Dan
