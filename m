From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: mdadm: Patch to restrict --size when shrinking unless forced
Date: Tue, 10 Oct 2017 21:54:25 +0100
Message-ID: <59DD3381.8050303@youngman.org.uk>
References: <22997.8664.67459.119616@quad.stoffel.home>
 <87a81637lq.fsf@notabene.neil.brown.name>
 <23002.37193.492253.120639@quad.stoffel.home>
 <87shetz207.fsf@notabene.neil.brown.name>
 <23002.53075.413063.6948@quad.stoffel.home>
 <87h8v9yn91.fsf@notabene.neil.brown.name>
 <c476e0a8-ff57-e38d-f3d7-0c59242cc0b9@turmel.org>
 <7b231d36-1434-0de0-2f7a-195a4f649d35@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7b231d36-1434-0de0-2f7a-195a4f649d35@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <jes.sorensen@gmail.com>, Phil Turmel <philip@turmel.org>, NeilBrown <neilb@suse.com>, John Stoffel <john@stoffel.org>
Cc: Eli Ben-Shoshan <eli@benshoshan.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/10/17 21:09, Jes Sorensen wrote:
>> Both operations would share the current code, just apply a different
>> sanity check before proceeding.
> 
> "grow" in mdadmlish translates to reshape/resize in English. Starting to
> introduce new keywords for this really makes no sense and just cause
> confusion, so I am not going to support that.

But saying "grow" when the result is a shrink also causes confusion.
Would you accept changing "grow" to "resize"?

But personally I think adding a new keyword is sensible. Firstly, in
normal use no-one is ever going to want to shrink an array, so this is
rarely going to be used.

And secondly, if you use "grow" to grow an array, it's a "safe"
operation (unless something goes wrong). If you use "grow" to *shrink*
an array, as Eli found out, it's very dangerous.

I think abusing the English language is far more dangerous than adding a
new keyword. No disrespect to them, but you forget your average sysadmin
is, well, average. Handing them a loaded foot-gun with no safety-catch
is *not* a good idea. (And even a good sysadmin will spend little time
with mdadm. Even if they know this now, there's a good chance they'll
forget before they need it again, and it becomes a land-mine waiting to
go off ...)

One only has to look at the "hung grow" thread to see what the lack of
safety-catches can do - if anybody wants another little project, might
it be an idea to make a load of operations (like resize for example)
block on a degraded array?

Cheers,
Wol
