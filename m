From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [PATCH] Grow: set component size prior to array size
Date: Tue, 6 Jun 2017 12:00:05 -0400
Message-ID: <c8b771ec-1209-d86a-ac67-29e38959d197@gmail.com>
References: <7964b1f5-5092-238b-403e-ed4fba584746@gmail.com>
 <1496671784-1612-1-git-send-email-tomasz.majchrzak@intel.com>
 <611d0b8e-f42f-48de-c881-bd55339d434c@gmail.com>
 <20170606144732.GA1070@proton.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170606144732.GA1070@proton.igk.intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 06/06/2017 10:47 AM, Tomasz Majchrzak wrote:
> On Mon, Jun 05, 2017 at 11:06:48AM -0400, Jes Sorensen wrote:
>> On 06/05/2017 10:09 AM, Tomasz Majchrzak wrote:
>>> It is a partial revert of commit 758b327cf5a7 ("Grow: Remove unnecessary
>>> optimization"). For native metadata component size is set in kernel for
>>> entire disk space. As external metadata supports multiple arrays within
>>> one disk, the component size is set to array size. If component size is
>>> not updated prior to array size update, the grow operation fails.
>>>
>>> Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
>>> ---
>>>   Grow.c | 2 ++
>>>   1 file changed, 2 insertions(+)
>>
>> Applied!
>>
>> Thanks,
>> Jes
>>
> 
> Would you mind pushing it to the repository? I'd like to have it ported into
> certain Linux distribution.

Only because it's you :)

Done!

Jes

