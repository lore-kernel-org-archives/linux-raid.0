From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: [PATCH] Fix oddity where mdadm did not recognise a relative path
Date: Sun, 29 Jan 2017 18:24:15 +0000
Message-ID: <588E334F.9070203@youngman.org.uk>
References: <587E6B56.8090704@youngman.org.uk> <wrfjzii9iwpq.fsf@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <wrfjzii9iwpq.fsf@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 29/01/17 17:48, jes.sorensen@gmail.com wrote:
> Wols Lists <antlists@youngman.org.uk> writes:
>> From 4ce784307a9004124392ce48432960d7ca94d0bf Mon Sep 17 00:00:00 2001
>> From: Wol <anthony@youngman.org.uk>
>> Date: Tue, 17 Jan 2017 17:47:05 +0000
>> Subject: [PATCH] Fix oddity where mdadm did not recognise a relative path
>>
>> mdadm assumed that a pathname started with a "/", while an array
>> name didn't. This alters the logic so that if the first character
>> is not a "/" it tries to open an array, and if that fails it drops
>> through to the pathname code rather than terminating immediately
>> with an error.
>>
>> Signed-off-by: Wol <anthony@youngman.org.uk>
>> ---
>>  mdadm.c | 12 ++++++------
>>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> Applied, thanks!
> 
> Sorry I have been swamped the last couple of weeks finishing up my old
> job and starting the new one. Will be bogged down a lot the next couple
> of weeks, so please be patient.
> 
Neil said you were changing jobs - that's fine. I just didn't want it to
get missed, and as there was no initial response I was trying to do as
gentle a "what's up" as I could.

That's fine. If it's in, then great :-) and I can wait for it to be
released whenever.

Cheers,
Wol
