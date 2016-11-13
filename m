From: Phil Turmel <philip@turmel.org>
Subject: Re: What to do about Offline_Uncorrectable and Pending_Sector in
 RAID1
Date: Sun, 13 Nov 2016 18:03:58 -0500
Message-ID: <bdd9358d-2141-eb4f-e765-52177b1ec852@turmel.org>
References: <CAHy4j_7_nRMxOSW16VTAY7bzdW_VMap=Jeb2M0wMiNDoNXcijQ@mail.gmail.com>
 <942ab8be-cd5c-c6d1-d077-cd295b355c0c@youngman.org.uk>
 <CAHy4j_7F=gN9=7mEH-TsdVJR0YFxBzJK98WeJfuwtANoDEy93w@mail.gmail.com>
 <5828D5DA.1070406@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5828D5DA.1070406@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Bruce Merry <bmerry@gmail.com>
Cc: Wols Lists <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Bruce,

On 11/13/2016 04:06 PM, Wols Lists wrote:
> On 13/11/16 20:51, Bruce Merry wrote:
>> On 13 November 2016 at 22:18, Anthony Youngman <antlists@youngman.org.uk> wrote:
>>> Quick first response ...

>>> https://raid.wiki.kernel.org/index.php/Timeout_Mismatch
>>
>> smartctl reports "SCT Error Recovery Control command not supported".
>> Does that mean I should be worried? Is there any way to tell whether a
>> given drive I can buy online supports it?

You should be worried.  It is vital for proper MD raid operation that
drive timeouts be shorter than the kernel timeout for that device.  If
you can't make the drive timeout short, you *must* make the kernel
timeout long.

> You need drives that explicitly support raid. WD Reds, Seagate NAS, some
> Toshibas - my 2TB laptop drive does ... Try and find a friend with a
> drive you like, and check it out, or ask on this list :-)

Manufacturers' data sheets for system builders usually contain enough
information to determine if ERC is supported.  Nowadays, the "NAS"
families work out of the box.  And enterprise drives, too, of course.

>>>> 1. What exactly this means. My understanding is that some data has
>>>> been lost (or may have been lost) on the drive, but the drive still
>>>> has spare sectors to remap things once the failed sectors are written
>>>> to. Is that correct?

Generally, yes.

>>> Do a scrub? You've got seven errors total, which some people will say "panic
>>> on the first error" and others will say "so what, the odd error every now
>>> and then is nothing to worry about". The point of a scrub is it will
>>> background-scan the entire array, and if it can't read anything, it will
>>> re-calculate and re-write it.
>>
>> Yes, that sounds like what I need. Thanks to Google I found
>> /usr/share/mdadm/checkarray to trigger this. It still has a few hours
>> to go, but now the bad drive has pending sectors == 65535 (which is
>> suspiciously power-of-two and I assume means it's actually higher and
>> is being clamped), and /sys/block/md0/md/mismatch_cnt is currently at
>> 1408. If scrubbing is supposed to rewrite on failed reads I would have
>> expected pending sectors to go down rather than up, so I'm not sure
>> what's happening.
>>
> Ummm....
> 
> Sounds like that drive could need replacing. I'd get a new drive and do
> that as soon as possible - use the --replace option of mdadm - don't
> fail the old drive and add the new. Dunno where you're based, but 5mins
> on the internet ordering a new drive is probably time well spent.

You have two other possibilities:

1) Swap volumes in the raid.  These are known to drop unneeded writes
when the data isn't needed, even if it made it to one of the mirrors.
That makes harmless mismatches.

2) Trim.  Well-behaved drive firmware guarantees zeros for trimmed
sectors, but many drives return random data instead.  Zing, mismatches.
It's often unhelpful with encrypted volumes, as even well-behaved
firmware can't deliver zeroed sectors *inside* the encryption.

I wouldn't panic just yet.  The check scrub should (with mitigated
timeouts) fix all of your pending sectors.  Then look at your actual
relocations to determine if you really do have a problem.

Phil
