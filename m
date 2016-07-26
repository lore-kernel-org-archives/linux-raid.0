From: Chris Murphy <lists@colorremedies.com>
Subject: Re: GPT corruption on Primary Header, backup OK, fixing primary nuked
 array -- help?
Date: Tue, 26 Jul 2016 17:18:37 -0600
Message-ID: <CAJCQCtQpGVf2Tj13o57T4=raF=czYr-V99tEDSkJ-_buk7JtTg@mail.gmail.com>
References: <5796B46B.6060905@suddenlinkmail.com> <413b1150-ca38-1907-ea5d-b68ad2f75710@websitemanagers.com.au>
 <5796F4E0.9070206@suddenlinkmail.com> <57971D3C.8040602@suddenlinkmail.com>
 <ff6872cd-98eb-aad2-a71a-7af52050ff30@websitemanagers.com.au>
 <5797C415.8010206@suddenlinkmail.com> <CAJCQCtSkE+-C5U9OEm0-zazLW2KHCMUqduDTA=UHsMxmf4DVrQ@mail.gmail.com>
 <5797E869.8080403@suddenlinkmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5797E869.8080403@suddenlinkmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "David C. Rankin" <drankinatty@suddenlinkmail.com>
Cc: mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Jul 26, 2016 at 4:47 PM, David C. Rankin
<drankinatty@suddenlinkmail.com> wrote:
> On 07/26/2016 03:47 PM, Chris Murphy wrote:
>>> So basically I just need to fix the partition table on sdc,
>> No just remove the GPT signatures, "45 46 49 20 50 41 52 54" and the
>> PMBR signature "55 aa" from the two drives.
>>
>> Restoring the primary GPT on sdd overwrote part of the mdadm metadata.
>> I'm not sure if --readd alone will fix that, or if one of the
>> --update= options is necessary as well, and if so which one.
>
> OK,
>
>   Here is where I need a bit more help. Would I use 'dd' to write the zeros at
> some offset?, or was your mention of wipefs earlier intended as the approach to
> take (e.g., "wipefs -b -t or -o to remove the GPT signatures, while avoiding the
> mdadm and file system signatures.")

wipefs with -b is safer because it only erases the signature, which is
tiny, and easy to replace if you get the command wrong because it's
static information, and backs all of it up to the local directory.

You can use wipefs -a -b on this /dev/sdd because you do in fact want
all the signatures gone before you --add it back to the array and let
it rebuild. But you do not want to use -a on sdc because that'll find
and remove the signatures for mdadm and ext4 unless you use -t instead
of -a to limit what wipefs is going to wipe.

You can certainly use dd, you just have to make sure you get the
command exactly right, and seeing as this whole thread started out
because a command wasn't exactly right :-) I'm helping you err on the
side of caution.

So if you use dd, you're going to zero the first 2 512 byte sectors,
i.e. count=2. That will clobber the PMBR and the primary GPT header.
You don't have to hit anything more than that, but it doesn't hurt
anything to wipe the first 4096 bytes.

To get rid of the backup GPT you'll zero the last two sectors of the
drive. So first get the total number of sectors from something like
gdisk -l which gets you this information (in part):

Disk /dev/sda: 1953525168 sectors, 931.5 GiB

And do
dd if=/dev/zero of=/dev/sda seek=1953525167

That'll erase ..67 and ..68, but the header is in ..67, one sector
before the last one. Nothing should be in the last sector anyway but
I'd check first! I don't know if ext4 put something there. And do not
use the "last usable sector" because that's full 34 sectors from the
end and there very well may be ext4 metadata in there that you do not
want to step on with /dev/sdc.




>   The real question for me is what is the effect of having /dev/sdc1 and
> /dev/sdd1 as unused partitions on the drive while I'm using the whole drive. Is
> that something that can bite me later?

It already bit you. All you have to do is forget again that you're not
using this partition table for anything, and then try to repair it and
you're back in this same situation. You or someone else who ends up
managing the drive. So yeah, it's not an in-use valid structure so I'd
invalidate it so that libblkid unambiguously tells you the only
signatures that matter onthe drive -> drives are not partitioned, they
are completely under the control of mdadm, and the logical array from
those members is ext4 or whatever.



Right now I understand I have a couple of
> options:
>
> Option 1:  attempt a re-add of /dev/sdd to the md4 array currently running in
> degraded mode.

Just --add as Phil says. That'll add the proper metadata to sdd. First
get rid of the PMBR and GPT signatures.


>
>  Do I need to delete sdd1 now while the disk is not being used before attempting
> a re-add sdd to the md4 array?

Yes.

>Does it matter?

Yes.




> Then if that can be successfully
> readded/synced, do I care about the fact that sdc has sdc1 on it and should I
> then --fail --remove sdc, fix the GPT header, delete sdc1 and then readd sdc to
> the md4 array? (or just leave as and ignore the GPT header issue reported by gdisk?)

You do not need to rebuild that drive, there's nothing wrong with it
other than the misleading, and currently unused, GPT and PMBR. Feel
free to just deal with /dev/sdd first, including its rebuild to
completion, before messing with /dev/sdc. And once you do move on to
/dev/sdc, I would umount the file system, stop the array, and then
overwrite the proper sectors as described with dd or wipefs -t, and
then either reboot or run partprobe to make sure the kernel's idea of
the drive's state is up to date. And then you can restart the array.




>
> Option 2:  shrink the filesystem on sdc


Oh no don't do that... that's a PITA and totally not necessary.



> Option 3:  If it all fails, and I start from scratch, what is the best way to
> wipe both drives completely to make sure there is no lingering trace of a
> superblock, etc. before recreating array?

Well you have to do a breakdown to really get it right, starting from the top.

First you wipefs -a /dev/md4 so you get rid of the ext4 signature.
Then you wipefs -a the member drives to get rid of GPT, PMBR, and
mdadm signatures.



>
>  # mdadm -S /dev/md4
>  # mdadm --zero-superblock /dev/sdc
>  # mdadm --zero-superblock /dev/sdd
>  # gdisk to 'fix' /dev/sdc
>  # mdadm --create --verbose /dev/md4 --level=1 --metadata=1.2 \
> --raid-devices=2 /dev/sdc1 /dev/sdd1
>  # mkfs.ext4 -v -L data -m 0.005 -b 4096 -E stride=16,stripe-width=32 /dev/md4
>  # update mdadm.conf
>  # (recopy data)

If you really care about having it partitioned, yes

>
> So it looks like it boils down to:
>
> (a) do I need to worry about removing unused sdc1/sdd1?

Worry is a strong word. It hasn't been a problem up until you got a
complaint from gdisk, didn't remember what you did when you built this
storage stack, and then fixed something that was actually not being
used anyway, which then broke something you were using.

So I think it's better to remove things you aren't using.




Then do I need to use
> 'dd' or 'wipefs' to fix the GPT and PMBR signatures on sdc (and I assume do
> nothing to sdd if I don't need to delete sdd1)
>
> (b) nuke it all and start over (if so what is the plan above OK?)

You do not need to nuke it all.




> I'll try the re-add of sdd to a and report back after your response.

After wiping sdd, you will use --add, not --re-add.



-- 
Chris Murphy
