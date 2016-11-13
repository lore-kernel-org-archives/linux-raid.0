From: Anthony Youngman <antlists@youngman.org.uk>
Subject: Re: What to do about Offline_Uncorrectable and Pending_Sector in
 RAID1
Date: Sun, 13 Nov 2016 20:18:24 +0000
Message-ID: <942ab8be-cd5c-c6d1-d077-cd295b355c0c@youngman.org.uk>
References: <CAHy4j_7_nRMxOSW16VTAY7bzdW_VMap=Jeb2M0wMiNDoNXcijQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAHy4j_7_nRMxOSW16VTAY7bzdW_VMap=Jeb2M0wMiNDoNXcijQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bruce Merry <bmerry@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Quick first response ...

On 13/11/16 18:46, Bruce Merry wrote:
> Hi
>
> I'm running software RAID1 across two drives in my home machine (LVM
> on LUKS on RAID1). I've just installed smartmontools and run short
> tests, and promptly received emails to tell me that one of the drives
> has 4 offline uncorrectable sectors and 3 current pending sectors.
> I've attached smartctl --xall output for sda (good) and sdb (bad).
>
> These drives are pretty old (over 5 years) so I'm going to replace
> them as soon as I have time (and yes, I have backups), but in the
> meantime I'd like advice on:
>
What drives are they? I'm guessing they're hunky-dory, but they don't 
fall foul of timeout mismatch, do they?

https://raid.wiki.kernel.org/index.php/Timeout_Mismatch

> 1. What exactly this means. My understanding is that some data has
> been lost (or may have been lost) on the drive, but the drive still
> has spare sectors to remap things once the failed sectors are written
> to. Is that correct?

It may also mean that the four sectors at least, have already been 
remapped ... I'll let the experts confirm. The three pending errors 
might be where a read has failed but there's not yet been a re-write - 
and you won't have noticed because the raid dealt with it.
>
> 2. How can I tell which sectors are problematic? If it's in the swap
> partition I'm far less worried. I can see two LBAs for offline
> uncorrectable errors in the --xall output, but that still leaves
> another two at large.

I don't think you need to be worried at all. It's only a few sectors, 
there's no sign of any further trouble? and as it's raided, when the 
drive returns an error the raid code will sort it out for you.
>
> 3. Assuming my understanding is correct, and that the sector falls
> within the RAID1 partition on the drive, is there some way I can
> recover the sectors from the other drive in the RAID1? As a last
> resort I imagine I could wipe the suspect drive and then rebuild it
> from the good one, but I'm hoping there's something less risky I can
> do.

Do a scrub? You've got seven errors total, which some people will say 
"panic on the first error" and others will say "so what, the odd error 
every now and then is nothing to worry about". The point of a scrub is 
it will background-scan the entire array, and if it can't read anything, 
it will re-calculate and re-write it.

Just make sure you've not got that timeout problem, or a scrub will make 
matters a whole lot worse ...
>
> Thanks in advance
> Bruce
>
Cheers,
Wol
