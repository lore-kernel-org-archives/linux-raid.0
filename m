From: Mike Hartman <mike@hartmanipulation.com>
Subject: Re: New RAID causing system lockups
Date: Tue, 21 Sep 2010 07:28:39 -0400
Message-ID: <AANLkTikZ_gpTyef1aCxQ=GcFp_ZBS=B3_Peff7duooe4@mail.gmail.com>
References: <AANLkTimTvPupaPuFbfpcCGC=0Ys9fQWihAgaADsrowqq@mail.gmail.com>
	<20100912064308.46d96742@notabene>
	<AANLkTikWY1QE_2HBADkVV1u1OSCktVT=ShQrCdNWBF8n@mail.gmail.com>
	<AANLkTimzmoyq_KHA1Q3JgEJSj2iuwYwiHRNR=_ZuLQCZ@mail.gmail.com>
	<AANLkTiknrUVCToYg8NM0dUX9kXVE_kTAwtuAqo09X-qj@mail.gmail.com>
	<20100914095111.6e3045c7@notabene>
	<AANLkTin=jy=xJTtN5mQ6U=rYw3p+_4-nmkhO7zqR0KLP@mail.gmail.com>
	<AANLkTimyEr9LnS2BOR+rXhwfU0rCE-MmYcjttaTyqAWT@mail.gmail.com>
	<20100914113516.63c883c4@notabene>
	<AANLkTimeeecqZX1Bn23=_41sBYO+P8h_b5Z6Gf_ACuA1@mail.gmail.com>
	<AANLkTi=uO6a1e_eGKcg6T2rD_ZpqNg_-X1u6qq=zA5J6@mail.gmail.com>
	<20100914134837.2e740a3e@notabene>
	<AANLkTimXabL-TyjqJ81syrx-Oxn50qexbA8q9p22sxJt@mail.gmail.com>
	<AANLkTinYaE07MzZ7LSPY18jtrsSdvj5sf7rnDqGEQP=z@mail.gmail.com>
	<20100921122644.517fcab0@notabene>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100921122644.517fcab0@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Sep 20, 2010 at 10:26 PM, Neil Brown <neilb@suse.de> wrote:
> On Wed, 15 Sep 2010 17:49:44 -0400
> Mike Hartman <mike@hartmanipulation.com> wrote:
>
>> >> Hmmm..
>> >> =A0Can you try mounting with
>> >> =A0 =A0-o barrier=3D0
>> >>
>> >> just to see if my theory is at all correct?
>> >>
>> >> Thanks,
>> >> NeilBrown
>> >>
>> >
>>
>> Progress report:
>>
>> I made the barrier change shortly after sending my last message (abo=
ut
>> 40 hours ago). With that in place, I was able to finish emptying one
>> of the non-assimilated drives onto the array, after which I added th=
at
>> drive as a hot spare and started the process to grow the array onto =
it
>> - the same procedure I've been applying since I created the RAID the
>> other week. No problems so far, and the reshape is at 46%.
>>
>> It's hard to be positive that the barrier deactivation is responsibl=
e
>> yet though - while the last few lockups have only been 1-16 hours
>> apart, I believe the first two had at least 2 or 3 days between them=
=2E
>> I'll keep the array busy to enhance the chances of a lockup though -
>> each one so far has been during a reshape or a large batch of writin=
g
>> to the array's partition. If I make it another couple days (meaning
>> time for this reshape to complete, another drive to be emptied onto
>> the array, and another reshape at least started) I'll be pretty
>> confident the problem has been identified.
>
> Thanks for the update.
>
>>
>> Assuming the barrier is the culprit (and I'm pretty sure you're righ=
t)
>> what are the consequences of just leaving it off? I gather the idea =
of
>> the barrier is to prevent journal corruption in the event of a power
>> failure or other sudden shutdown, which seems pretty important, but =
it
>> also doesn't seem like it was enabled by default in ext3/4 until 200=
8,
>> which makes it seem less critical.
>
> Correct. =A0Without the barriers the chance of corruption during powe=
rfail is
> higher. =A0I don't really know how much higher, it depends a lot on t=
he
> filesystem design and the particular implementation. =A0I think ext4 =
tends to
> be fairly safe - after all some devices don't support barriers and it=
 has to
> do best-effort on those too.
>
>>
>> Even if the ultimate solution for me is to just leave it disabled I'=
m
>> happy to keep trying patches if you want to get it properly fixed in
>> md. We may have to come up with an alternate way to work the array
>> hard enough to trigger the lockups though - my last 1.5TB drive is
>> what's being merged in now. After that completes I only have one mor=
e
>> pair of 750GBs (that will have to be shoehorned in using RAID0 again=
).
>> I do have a single 750GB left over, so I'll probably find a mate for
>> it and get it added to. After that we're maxed out on hardware for a
>> while.
>>
>> Mike
>
> I'll stare at the code a bit more and see if anything jumps out at me=
=2E
>
> Thanks,
> NeilBrown
>
>

I've just finished my last grow-and-copy with no problems. The only
drive that's not part of the array now is the leftover 750GB, which is
now empty. I haven't experienced any further lockups so your barrier
diagnosis seems to be spot on. I'm planning to just leave that option
turned off, but as I said, I'm happy to test any patches you come up
with. Thanks for all your help.

Mike
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
