From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 2/2] IMSM: do not rebuild the array if a non-redundant
 sub-array with failed disks is present
Date: Wed, 08 Dec 2010 09:48:28 -0800
Message-ID: <4CFFC4EC.8090100@intel.com>
References: <905EDD02F158D948B186911EB64DB3D17676E3C3@irsmsx503.ger.corp.intel.com> <20101208133208.0f62b900@notabene.brown>  <905EDD02F158D948B186911EB64DB3D17676EB3F@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <905EDD02F158D948B186911EB64DB3D17676EB3F@irsmsx503.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Labun, Marcin" <Marcin.Labun@intel.com>, "Kwolek, Adam" <adam.kwolek@intel.com>
Cc: Neil Brown <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Czarnowska, Anna" <anna.czarnowska@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>
List-Id: linux-raid.ids


>> This seems to imply that there are only ever at most 2 volumes in a
>> container.  Is that really true?  The rest of the code seems to assume
>> that
>> there could be several.
>
>
> There are at most two sub-array in one array.

Empirically to date yes, but...

This is an arbitrary restriction imposed by the orom, it could be 
changed in future versions and it is not enforced when setting the 
IMSM_NO_PLATFORM variable.

When coding for "more than 1" it is not much more effort to code for 
"infinite".  This approach helped find bugs in the implementation/usage 
of reserve_space() that would not have triggered if the tests 
(tests/08imsm-overlap) were hardcoded for at most 2 arrays.

So the implementation should handle the case when imsm_orom.vpa > 2 or 
IMSM_NO_PLATFORM == 1.

--
Dan
