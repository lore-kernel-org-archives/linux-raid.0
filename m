From: Matthias Walther <matthias@walther.xyz>
Subject: Re: Unexpected mdadm behavior with old replugged disc
Date: Sat, 18 Nov 2017 16:06:15 +0100
Message-ID: <505a02a9-d0e3-1e4e-82da-1b2192d7c810@walther.xyz>
References: <239f7f18-00d3-254a-e460-24b40e9db5e1@walther.xyz>
 <5A104AA9.6000603@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5A104AA9.6000603@youngman.org.uk>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Am 18.11.2017 um 15:58 schrieb Wols Lists:
> On 18/11/17 14:35, Matthias Walther wrote:
>> Hello,
>>
>> I just signed up for this mailing list to discuss the following,
>> unexpected behavior:
>>
>> Situation: Raid6 with 6 discs. For some reasons, which are unimportant,
>> I had replaced a disc before, which was fully functional. This disc was
>> never changed or written to in between.
>>
>> Today I replugged this particular disc additionally as 7th disc to the
>> server (cold plug, server was switched off).
>>
>> Unexpectedly mdadm broke up my fully synced raid6 and now syncs back to
>> this old disc dropping one of the newer discs from the raid.
>>
>> This might be because it has its uuid still stored with higher rank than
>> the newer disc or because the old disc got a lower sdX slot. I don't
>> know that in detail.
>>
>> Anyway, I wouldn't expect mdadm to act like this. It might use the old,
>> now plugged in again disc as hot spare or ignore it at all. But it
>> shouldn't break a fully synced raid. I have reduced redundancy for about
>> 24 hours now - without any rational reason.
Hello,

thanks for your quick reply.
> Just a guess? "mdadm --assemble --incremental"?
What do you mean with this guess? I didn't do anything. All happened
automatically
>
> What I *suspect* happened is that, as the system booted, mdadm scanned
> the drives as they came available, and because this drive became
> available before some of the others, it got included in the array.
Probably.
>
> I can't, off the top of my head, think of any way to stop this
> happening, other than to prevent raid assembling during boot, or having
> an *accurate* mdadm.conf from which mdadm could realise this drive
> wasn't meant to be included.
>
> Did you update mdadm.conf after you removed this drive? Do you even have
> an mdadm.conf?
No, always relied on auto-configuration. So if I had had a correctly
updated mdadm.conf, this wouldn't have happened?
>
> The only good point here, is that if you had three such drives, mdadm
> would almost certainly have failed the array as it booted, and left you
> in an (easily) recoverable situation. I don't really see what else it
> could have done?
>
> Cheers,
> Wol

I have to reassembly it manually anyway now. The system crashed, changed
the order again and doesn't assemble automatically at the moment. I'll
have to search how to determine to use which discs.

Once reassembled, I'll create a mdadm.conf to prevent this in the future.

Regards,
Matthias
