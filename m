From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: Re: [PATCH] badblocks: fix wrong return value when badblocks are
 disabled
Date: Wed, 6 Apr 2016 11:13:25 +0200
Message-ID: <5704D335.605@intel.com>
References: <1459861174-9238-1-git-send-email-artur.paszkiewicz@intel.com>
 <1459877821.4741.4.camel@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1459877821.4741.4.camel@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Verma, Vishal L" <vishal.l.verma@intel.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
List-Id: linux-raid.ids

On 04/05/2016 07:37 PM, Verma, Vishal L wrote:
> On Tue, 2016-04-05 at 14:59 +0200, Artur Paszkiewicz wrote:
>> The return value of md_set_badblocks() was inverted when the code was
>> taken out of md, but the case when badblocks are disabled was left
>> unchanged. This causes silent ignoring of I/O errors and other
>> unpredictable behavior on md arrays that do not support badblocks (any
>> array not using v1.x metadata).
>>
>> Fixes: 9e0e252a048b ("badblocks: Add core badblock management code")
>> Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
>> ---
>>  block/badblocks.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> Good find, thanks!
> 
> Acked-by: Vishal Verma <vishal.l.verma@intel.com>
> 
> Should this also be tagged for stable?

Yes, I think it should be, since it affects 4.5.

Artur


