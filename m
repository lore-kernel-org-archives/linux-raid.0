From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [PATCH 0/4] Assorted mdadm patches.
Date: Wed, 16 Aug 2017 06:31:52 -0400
Message-ID: <8ff33ba2-35ce-805f-4c8c-5fb3b4615573@gmail.com>
References: <150182450644.25561.9683614144764209335.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <150182450644.25561.9683614144764209335.stgit@noble>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 08/04/2017 01:30 AM, NeilBrown wrote:
> One real bugfix - that a customer might have hit.
> Another real bugfix, which proves no-one is using that feature.
> And a couple of minor consistency improvements.
> 
> Can you guess which is which :-?

Clearly patch 1 is the customer reported bug :)

I applied all of them. I am not wildly in love with patch 4, I kinda 
would like to switch to using standard error codes, but mixing them is 
inconsistent, so lets at least be consistent for now.

All applied!

Thanks,
Jes
