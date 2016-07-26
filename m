From: "David C. Rankin" <drankinatty@suddenlinkmail.com>
Subject: Re: GPT corruption on Primary Header, backup OK, fixing primary nuked
 array -- help?
Date: Tue, 26 Jul 2016 17:47:05 -0500
Message-ID: <5797E869.8080403@suddenlinkmail.com>
References: <5796B46B.6060905@suddenlinkmail.com>
 <413b1150-ca38-1907-ea5d-b68ad2f75710@websitemanagers.com.au>
 <5796F4E0.9070206@suddenlinkmail.com> <57971D3C.8040602@suddenlinkmail.com>
 <ff6872cd-98eb-aad2-a71a-7af52050ff30@websitemanagers.com.au>
 <5797C415.8010206@suddenlinkmail.com>
 <CAJCQCtSkE+-C5U9OEm0-zazLW2KHCMUqduDTA=UHsMxmf4DVrQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJCQCtSkE+-C5U9OEm0-zazLW2KHCMUqduDTA=UHsMxmf4DVrQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 07/26/2016 03:47 PM, Chris Murphy wrote:
>> So basically I just need to fix the partition table on sdc,
> No just remove the GPT signatures, "45 46 49 20 50 41 52 54" and the
> PMBR signature "55 aa" from the two drives.
> 
> Restoring the primary GPT on sdd overwrote part of the mdadm metadata.
> I'm not sure if --readd alone will fix that, or if one of the
> --update= options is necessary as well, and if so which one.

OK,

  Here is where I need a bit more help. Would I use 'dd' to write the zeros at
some offset?, or was your mention of wipefs earlier intended as the approach to
take (e.g., "wipefs -b -t or -o to remove the GPT signatures, while avoiding the
mdadm and file system signatures.")


  The real question for me is what is the effect of having /dev/sdc1 and
/dev/sdd1 as unused partitions on the drive while I'm using the whole drive. Is
that something that can bite me later? Right now I understand I have a couple of
options:

Option 1:  attempt a re-add of /dev/sdd to the md4 array currently running in
degraded mode.

 Do I need to delete sdd1 now while the disk is not being used before attempting
a re-add sdd to the md4 array? Does it matter? Then if that can be successfully
readded/synced, do I care about the fact that sdc has sdc1 on it and should I
then --fail --remove sdc, fix the GPT header, delete sdc1 and then readd sdc to
the md4 array? (or just leave as and ignore the GPT header issue reported by gdisk?)

Option 2:  shrink the filesystem on sdc so it will fit in sdc1 and move the
filesystem to the sdc1 partition before re-adding. (this I don't understand as
well -- how to move the shrunken filesystem from sdc to sdc1?) If I understand,
moving to sdc1 doesn't buy me anything and isn't necessary here. So we can
strike option 2 if this is correct.

Option 3:  If it all fails, and I start from scratch, what is the best way to
wipe both drives completely to make sure there is no lingering trace of a
superblock, etc. before recreating array?

 # mdadm -S /dev/md4
 # mdadm --zero-superblock /dev/sdc
 # mdadm --zero-superblock /dev/sdd
 # gdisk to 'fix' /dev/sdc
 # mdadm --create --verbose /dev/md4 --level=1 --metadata=1.2 \
--raid-devices=2 /dev/sdc1 /dev/sdd1
 # mkfs.ext4 -v -L data -m 0.005 -b 4096 -E stride=16,stripe-width=32 /dev/md4
 # update mdadm.conf
 # (recopy data)

So it looks like it boils down to:

(a) do I need to worry about removing unused sdc1/sdd1? Then do I need to use
'dd' or 'wipefs' to fix the GPT and PMBR signatures on sdc (and I assume do
nothing to sdd if I don't need to delete sdd1)

(b) nuke it all and start over (if so what is the plan above OK?)

I'll try the re-add of sdd to a and report back after your response.

-- 
David C. Rankin, J.D.,P.E.
