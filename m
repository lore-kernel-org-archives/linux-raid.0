From: Jes Sorensen <jes@trained-monkey.org>
Subject: Re: [PATCH v2] Use more secure HTTPS URLs
Date: Fri, 12 Jun 2020 10:47:27 -0400
Message-ID: <8dbfb508-618a-0e4f-b18c-db2b0212d169@trained-monkey.org>
References: <20200528145224.19062-1-pmenzel@molgen.mpg.de>
 <8b02033d-7570-e654-dc18-a96f0a71d00c@trained-monkey.org>
 <31fb5c7a-90c9-1810-1087-9dfa32c2f7f3@molgen.mpg.de>
 <SA0PR11MB454273621EA4A4876B1D3503FF820@SA0PR11MB4542.namprd11.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <SA0PR11MB454273621EA4A4876B1D3503FF820@SA0PR11MB4542.namprd11.prod.outlook.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "Tkaczyk, Mariusz" <mariusz.tkaczyk@intel.com>, Paul Menzel <pmenzel@molgen.mpg.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Baldysiak, Pawel" <pawel.baldysiak@intel.com>, "Tanska, Kinga" <kinga.tanska@intel.com>
List-Id: linux-raid.ids

Hi Mariusz,

Thanks for the pointer. Lets update the man page to point to this, it's
better than nothing.

Cheers,
Jes

On 6/9/20 5:15 AM, Tkaczyk, Mariusz wrote:
> Hi,
> I'm recommending this link:
> https://www.intel.com/content/www/us/en/support/products/122484/memory-and-storage/ssd-software/intel-virtual-raid-on-cpu-intel-vroc.html
> 
> Currently we don't have any online superblock description, redirecting to the VROC support page is the best we can do.
> Previous link is permanently dead.
> 
> Thanks,
> Mariusz
> 
> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org <linux-raid-owner@vger.kernel.org> On Behalf Of Paul Menzel
> Sent: Friday, June 5, 2020 8:23 PM
> To: Jes Sorensen <jes@trained-monkey.org>; Tkaczyk, Mariusz <mariusz.tkaczyk@intel.com>
> Cc: linux-raid@vger.kernel.org; Baldysiak, Pawel <pawel.baldysiak@intel.com>; Tanska, Kinga <kinga.tanska@intel.com>
> Subject: Re: [PATCH v2] Use more secure HTTPS URLs
> 
> Dear Jes,
> 
> 
> Am 05.06.20 um 17:17 schrieb Jes Sorensen:
>> On 5/28/20 10:52 AM, Paul Menzel wrote:
>>> All URLs in the source are available over HTTPS, so convert all URLs 
>>> to HTTPS with the command below.
>>>
>>>      git grep -l 'http://' | xargs sed -i 's,http://,https://,g'
>>>
>>> Revert the changes to announcement files `ANNOUNCE-*` as requested by 
>>> the maintainer.
>>>
>>> Cc: linux-raid@vger.kernel.org
>>> Signed-off-by: Paul Menzel <pmenzel@molgen.mpg.de>
>>> ---
>>>   external-reshape-design.txt      | 2 +-
>>>   mdadm.8.in                       | 6 +++---
>>>   mdadm.spec                       | 4 ++--
>>>   raid6check.8                     | 2 +-
>>>   restripe.c                       | 2 +-
>>>   udev-md-raid-safe-timeouts.rules | 2 +-
>>>   6 files changed, 9 insertions(+), 9 deletions(-)
>>>
>>> diff --git a/external-reshape-design.txt 
>>> b/external-reshape-design.txt index 10c57cc..e4cf4e1 100644
>>> --- a/external-reshape-design.txt
>>> +++ b/external-reshape-design.txt
>>> @@ -277,4 +277,4 @@ sync_action
>>>   
>>>   ...
>>>   
>>> -[1]: Linux kernel design patterns - part 3, Neil Brown 
>>> http://lwn.net/Articles/336262/
>>> +[1]: Linux kernel design patterns - part 3, Neil Brown 
>>> +https://lwn.net/Articles/336262/
>>> diff --git a/mdadm.8.in b/mdadm.8.in
>>> index 9e7cb96..7f32762 100644
>>> --- a/mdadm.8.in
>>> +++ b/mdadm.8.in
>>> @@ -367,7 +367,7 @@ Use the Intel(R) Matrix Storage Manager metadata format.  This creates a
>>>   which is managed in a similar manner to DDF, and is supported by an
>>>   option-rom on some platforms:
>>>   .IP
>>> -.B http://www.intel.com/design/chipsets/matrixstorage_sb.htm
>>> +.B https://www.intel.com/design/chipsets/matrixstorage_sb.htm
>>
>> Sorry for being a pain, but this link isn't actually valid.
> 
> Sorry, for not mentioning that in the commit message. Indeed the original page is gone, but the plain HTTP URL gets redirected to HTTPS, so it doesn’t change the behavior from before.
> 
> ```
> $ curl -I http://www.intel.com/design/chipsets/matrixstorage_sb.htm
> HTTP/1.1 301 Moved Permanently
> Server: AkamaiGHost
> Content-Length: 0
> Location: https://www.intel.com/design/chipsets/matrixstorage_sb.htm
> Date: Fri, 05 Jun 2020 18:20:43 GMT
> Connection: keep-alive
> Set-Cookie: detected_bandwidth=LOW; path=/; domain=.intel.com; secure; HttpOnly
> Set-Cookie: src_countrycode=DE; path=/; domain=.intel.com; secure; HttpOnly
> Access-Control-Allow-Origin: *
> X-Content-Type-Options: nosniff
> 
> ```
> 
> So, maybe take this patch, and the outdated URL can be fixed in a follow-up once it’s known.
> 
>> Does someone from Intel know what to point at?
> 
> That’d be great.
> 
> 
> Kind regards,
> 
> Paul
> 
