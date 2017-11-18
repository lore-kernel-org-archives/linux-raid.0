From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Unexpected mdadm behavior with old replugged disc
Date: Sat, 18 Nov 2017 14:58:49 +0000
Message-ID: <5A104AA9.6000603@youngman.org.uk>
References: <239f7f18-00d3-254a-e460-24b40e9db5e1@walther.xyz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <239f7f18-00d3-254a-e460-24b40e9db5e1@walther.xyz>
Sender: linux-raid-owner@vger.kernel.org
To: Matthias Walther <matthias@walther.xyz>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 18/11/17 14:35, Matthias Walther wrote:
> Hello,
> 
> I just signed up for this mailing list to discuss the following,
> unexpected behavior:
> 
> Situation: Raid6 with 6 discs. For some reasons, which are unimportant,
> I had replaced a disc before, which was fully functional. This disc was
> never changed or written to in between.
> 
> Today I replugged this particular disc additionally as 7th disc to the
> server (cold plug, server was switched off).
> 
> Unexpectedly mdadm broke up my fully synced raid6 and now syncs back to
> this old disc dropping one of the newer discs from the raid.
> 
> This might be because it has its uuid still stored with higher rank than
> the newer disc or because the old disc got a lower sdX slot. I don't
> know that in detail.
> 
> Anyway, I wouldn't expect mdadm to act like this. It might use the old,
> now plugged in again disc as hot spare or ignore it at all. But it
> shouldn't break a fully synced raid. I have reduced redundancy for about
> 24 hours now - without any rational reason.

Just a guess? "mdadm --assemble --incremental"?

What I *suspect* happened is that, as the system booted, mdadm scanned
the drives as they came available, and because this drive became
available before some of the others, it got included in the array.

I can't, off the top of my head, think of any way to stop this
happening, other than to prevent raid assembling during boot, or having
an *accurate* mdadm.conf from which mdadm could realise this drive
wasn't meant to be included.

Did you update mdadm.conf after you removed this drive? Do you even have
an mdadm.conf?

The only good point here, is that if you had three such drives, mdadm
would almost certainly have failed the array as it booted, and left you
in an (easily) recoverable situation. I don't really see what else it
could have done?

Cheers,
Wol
