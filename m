From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: [PATCH] md: make suspend range wait timed out
Date: Sat, 17 Jun 2017 02:06:23 +0800
Message-ID: <40a41d94-b930-e402-9ce4-4d4f47873e64@fnarfbargle.com>
References: <d95473d287e196a86a83390cb9c136913643bd61.1497037210.git.shli@fb.com>
 <877f0c7gvr.fsf@notabene.neil.brown.name>
 <20170616155204.myffyxp5tuoctcoo@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170616155204.myffyxp5tuoctcoo@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org, Shaohua Li <shli@fb.com>, Mikulas Patocka <mpatocka@redhat.com>
List-Id: linux-raid.ids

On 16/06/17 23:52, Shaohua Li wrote:
> On Fri, Jun 16, 2017 at 01:26:00PM +1000, Neil Brown wrote:
>> If an md device is left suspended, then the current code will block IO
>> indefinitely.  This patch will at a 20minute times to every single
>> request, which will mean IO proceeds, but extremely slowly.  I don't see
>> that as a useful improvement.
>
> It returns error, so application will not dispatch more IO. But I agree a
> timeout to clear the suspend looks a better policy.

If you insist on doing this, make the default timeout configurable and 
set it to wait forever by default. That way there is no change in 
current behaviour.

There are a number of times I've tickled those values to suspend things 
while doing something sinister to the array. I'd be mighty upset if I 
got called away and came back to find the kernel had resumed underneath 
me because it thinks it knows best.

Regards,
Brad
-- 
Dolphins are so intelligent that within a few weeks they can
train Americans to stand at the edge of the pool and throw them
fish.
