From: Mariusz Dabrowski <mariusz.dabrowski@intel.com>
Subject: Re: [PATCH] IMSM: Correct --examine output for 4k disks
Date: Wed, 10 May 2017 10:43:14 +0200
Message-ID: <5e8e5353-e42d-0ea0-1928-7d4608a884b8@intel.com>
References: <1494331407-2049-1-git-send-email-mariusz.dabrowski@intel.com>
 <1aca3793-3786-00dc-910e-920a21a1108b@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1aca3793-3786-00dc-910e-920a21a1108b@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <jes.sorensen@gmail.com>, linux-raid@vger.kernel.org
Cc: Maksymilian Kunt <maksymilian.kunt@intel.com>
List-Id: linux-raid.ids

On 05/09/2017 06:04 PM, Jes Sorensen wrote:
 > On 05/09/2017 08:03 AM, Mariusz Dabrowski wrote:
 >> From: Maksymilian Kunt <maksymilian.kunt@intel.com>
 >>
 >> "Array Size" and "Per Dev Size" are incorrect for disks with sector size
 >> different than 512B.
 >>
 >> Calculate "Array Size" and "Per Dev Size" based on sector size. Additionally
 >> print "Sector Size".
 >>
 >> Signed-off-by: Maksymilian Kunt <maksymilian.kunt@intel.com>
 >> Signed-off-by: Mariusz Dabrowski <mariusz.dabrowski@intel.com>
 >> ---
 >>   super-intel.c | 7 +++++--
 >>   1 file changed, 5 insertions(+), 2 deletions(-)
 >
 > I am a little wary of this change as it changes the order of the output. Does
 > anyone have tools parsing this information which could break from this?
 >
 > Jes
 >

Hi Jes,

some time ago we have added "RWH Policy" field to --examine output and we 
haven't heard any complaints about that change.
Also it is better to parse output from --export option which is unchanged in 
this patch.

Thanks,
Mariusz



