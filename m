From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: RAID creation resync behaviors
Date: Tue, 9 May 2017 16:49:20 -0400
Message-ID: <76407cb7-437b-142e-e74b-ddd56f3f4ddb@gmail.com>
References: <20170503202748.7r243wj5h4polt6y@kernel.org>
 <87inlhpgzu.fsf@notabene.neil.brown.name>
 <20170504020452.kcmjgxnk7zsx7kdx@kernel.org>
 <1fca5ff4-358a-e0cf-d1a4-fc33ecdcbd62@gmail.com>
 <87o9v1n56m.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87o9v1n56m.fsf@notabene.neil.brown.name>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

On 05/09/2017 04:30 PM, NeilBrown wrote:
> On Tue, May 09 2017, Jes Sorensen wrote:
> 
>> On 05/03/2017 10:04 PM, Shaohua Li wrote:
>>> On Thu, May 04, 2017 at 11:07:01AM +1000, Neil Brown wrote:
>>>> On Wed, May 03 2017, Shaohua Li wrote:
>>> This doesn't work well. read returns 0 for trimmed data space in some SSDs, but
>>> not all. If not, we will have trouble.
>>
>> /sys/block/<device>/queue/discard_zeroes_data
>>
>> We could use this as an indicator for what to do.
>>
> According to
> 
> Documentation/ABI/testing/sysfs-block
> 
> Description:
>                  Will always return 0.  Don't rely on any specific behavior
>                  for discards, and don't read this file.
> 
> See also
>   Commit: 48920ff2a5a9 ("block: remove the discard_zeroes_data flag")

Crap!

Back to the drawing board :(

Jes

