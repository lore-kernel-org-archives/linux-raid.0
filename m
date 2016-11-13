From: Bruce Merry <bmerry@gmail.com>
Subject: Re: What to do about Offline_Uncorrectable and Pending_Sector in RAID1
Date: Sun, 13 Nov 2016 22:51:18 +0200
Message-ID: <CAHy4j_7F=gN9=7mEH-TsdVJR0YFxBzJK98WeJfuwtANoDEy93w@mail.gmail.com>
References: <CAHy4j_7_nRMxOSW16VTAY7bzdW_VMap=Jeb2M0wMiNDoNXcijQ@mail.gmail.com>
 <942ab8be-cd5c-c6d1-d077-cd295b355c0c@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <942ab8be-cd5c-c6d1-d077-cd295b355c0c@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Anthony Youngman <antlists@youngman.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 13 November 2016 at 22:18, Anthony Youngman <antlists@youngman.org.uk> wrote:
> Quick first response ...
>
> On 13/11/16 18:46, Bruce Merry wrote:
>>
>> Hi
>>
>> I'm running software RAID1 across two drives in my home machine (LVM
>> on LUKS on RAID1). I've just installed smartmontools and run short
>> tests, and promptly received emails to tell me that one of the drives
>> has 4 offline uncorrectable sectors and 3 current pending sectors.
>> I've attached smartctl --xall output for sda (good) and sdb (bad).
>>
>> These drives are pretty old (over 5 years) so I'm going to replace
>> them as soon as I have time (and yes, I have backups), but in the
>> meantime I'd like advice on:
>>
> What drives are they? I'm guessing they're hunky-dory, but they don't fall
> foul of timeout mismatch, do they?
>
> https://raid.wiki.kernel.org/index.php/Timeout_Mismatch

smartctl reports "SCT Error Recovery Control command not supported".
Does that mean I should be worried? Is there any way to tell whether a
given drive I can buy online supports it?

>> 1. What exactly this means. My understanding is that some data has
>> been lost (or may have been lost) on the drive, but the drive still
>> has spare sectors to remap things once the failed sectors are written
>> to. Is that correct?
>
>
> It may also mean that the four sectors at least, have already been remapped
> ... I'll let the experts confirm. The three pending errors might be where a
> read has failed but there's not yet been a re-write - and you won't have
> noticed because the raid dealt with it.

I'm guessing nothing has been remapped yet, because the
Reallocated_Sector_Ct and Reallocator_Event_ct are both zero.

>> 3. Assuming my understanding is correct, and that the sector falls
>> within the RAID1 partition on the drive, is there some way I can
>> recover the sectors from the other drive in the RAID1? As a last
>> resort I imagine I could wipe the suspect drive and then rebuild it
>> from the good one, but I'm hoping there's something less risky I can
>> do.
>
>
> Do a scrub? You've got seven errors total, which some people will say "panic
> on the first error" and others will say "so what, the odd error every now
> and then is nothing to worry about". The point of a scrub is it will
> background-scan the entire array, and if it can't read anything, it will
> re-calculate and re-write it.

Yes, that sounds like what I need. Thanks to Google I found
/usr/share/mdadm/checkarray to trigger this. It still has a few hours
to go, but now the bad drive has pending sectors == 65535 (which is
suspiciously power-of-two and I assume means it's actually higher and
is being clamped), and /sys/block/md0/md/mismatch_cnt is currently at
1408. If scrubbing is supposed to rewrite on failed reads I would have
expected pending sectors to go down rather than up, so I'm not sure
what's happening.

Thanks
Bruce
-- 
Dr Bruce Merry
bmerry <@> gmail <.> com
http://www.brucemerry.org.za/
http://blog.brucemerry.org.za/
