From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [PATCH] IMSM: Correct --examine output for 4k disks
Date: Wed, 10 May 2017 11:18:18 -0400
Message-ID: <e27a148f-f0bf-8713-ceca-f37b4fb2fb88@gmail.com>
References: <1494331407-2049-1-git-send-email-mariusz.dabrowski@intel.com>
 <1aca3793-3786-00dc-910e-920a21a1108b@gmail.com>
 <5e8e5353-e42d-0ea0-1928-7d4608a884b8@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5e8e5353-e42d-0ea0-1928-7d4608a884b8@intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Mariusz Dabrowski <mariusz.dabrowski@intel.com>, linux-raid@vger.kernel.org
Cc: Maksymilian Kunt <maksymilian.kunt@intel.com>
List-Id: linux-raid.ids

On 05/10/2017 04:43 AM, Mariusz Dabrowski wrote:
> On 05/09/2017 06:04 PM, Jes Sorensen wrote:
>  > On 05/09/2017 08:03 AM, Mariusz Dabrowski wrote:
>  >> From: Maksymilian Kunt <maksymilian.kunt@intel.com>
>  >>
>  >> "Array Size" and "Per Dev Size" are incorrect for disks with sector 
> size
>  >> different than 512B.
>  >>
>  >> Calculate "Array Size" and "Per Dev Size" based on sector size. 
> Additionally
>  >> print "Sector Size".
>  >>
>  >> Signed-off-by: Maksymilian Kunt <maksymilian.kunt@intel.com>
>  >> Signed-off-by: Mariusz Dabrowski <mariusz.dabrowski@intel.com>
>  >> ---
>  >>   super-intel.c | 7 +++++--
>  >>   1 file changed, 5 insertions(+), 2 deletions(-)
>  >
>  > I am a little wary of this change as it changes the order of the 
> output. Does
>  > anyone have tools parsing this information which could break from this?
>  >
>  > Jes
>  >
> 
> Hi Jes,
> 
> some time ago we have added "RWH Policy" field to --examine output and 
> we haven't heard any complaints about that change.
> Also it is better to parse output from --export option which is 
> unchanged in this patch.

Hi Mariusz,

That is correct, however the policy stuff was added to the end of the 
output, it didn't change the existing part. I am a little mixed on this 
one, but I do agree --export should be the recommended use case for scripts.

Cheers,
Jes
