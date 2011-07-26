From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [md PATCH 17/34] md/raid5: unite handle_stripe_dirtying5 and handle_stripe_dirtying6
Date: Mon, 25 Jul 2011 19:41:03 -0700
Message-ID: <c2880169-d5be-4dc5-aaad-e0fd4f9823d1@email.android.com>
References: <20110721022537.6728.90204.stgit@notabene.brown> <20110721023226.6728.28082.stgit@notabene.brown> <87tyaepto6.fsf@gmail.com> <20110726115238.63fec583@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110726115238.63fec583@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>, Namhyung Kim <namhyung@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown <neilb@suse.de> wrote:

>On Fri, 22 Jul 2011 18:10:33 +0900 Namhyung Kim <namhyung@gmail.com>
>wrote:
>
>> NeilBrown <neilb@suse.de> writes:
>> 
>> > RAID6 is only allowed to choose 'reconstruct-write' while RAID5 is
>> > also allow 'read-modify-write'
>> > Apart from this difference, handle_stripe_dirtying[56] are nearly
>> > identical.  So resolve these differences and create just one
>function.
>> >
>> > Signed-off-by: NeilBrown <neilb@suse.de>
>> 
>> Reviewed-by: Namhyung Kim <namhyung@gmail.com>
>> 
>> BTW, here is a question:
>>   Why RAID6 doesn't allow the read-modify-write? I don't think it is
>>   not possible, so what prevents doing that? performance? complexity?
>>   or it's not possible? Why? :)
>
>
>The primary reason in my mind is that when Peter Anvin wrote this code
>he
>didn't implement read-modify-write and I have never seen a need to
>consider
>changing that.
>
>You would need a largish array - at least 7 devices - before RWM could
>possibly be a win, but some people do have arrays larger than that.
>
>The computation to "subtract" from the Q-syndrome might be a bit
>complex - I
>don't know.
>
>Peter: maybe you have a reason that I haven't mentioned?
>
>Thanks,
>NeilBrown

When I measured it it wasn't a win on my system, and it created a lot of extra complexity.  It probably would be a win with SSSE3 and lots of drives.
-- 
Sent from my mobile phone. Please excuse my brevity and lack of formatting.
