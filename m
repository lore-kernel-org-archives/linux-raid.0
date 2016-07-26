From: "David C. Rankin" <drankinatty@suddenlinkmail.com>
Subject: Re: GPT corruption on Primary Header, backup OK, fixing primary nuked
 array -- help?
Date: Tue, 26 Jul 2016 16:12:26 -0500
Message-ID: <5797D23A.7090606@suddenlinkmail.com>
References: <5796B46B.6060905@suddenlinkmail.com>
 <413b1150-ca38-1907-ea5d-b68ad2f75710@websitemanagers.com.au>
 <5796F4E0.9070206@suddenlinkmail.com> <57971D3C.8040602@suddenlinkmail.com>
 <CAJCQCtQ73Tp_ps57qgDm=S_qdFMHy8J0Z=kB+_TfQD2ugj_6ow@mail.gmail.com>
 <CAJCQCtTUO9nLRDUVQ+nkykiQ2ebc-SO8Oh9VP3_WMVKO2fs7dw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJCQCtTUO9nLRDUVQ+nkykiQ2ebc-SO8Oh9VP3_WMVKO2fs7dw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 07/26/2016 10:55 AM, Chris Murphy wrote:
> However, it does appear that in the OP's case that the array was
> created on the whole disk device, not on the partition. If true, I
> would remove the signatures on the GPT primary and secondary headers
> to make sure they're invalidated. Otherwise it's ambiguous what these
> drives are all about, are they single partition drives that are empty?
> Or are they whole device md members?
> 
> I'd look at using wipefs -b -t or -o to remove the GPT signatures,
> while avoiding the mdadm and file system signatures.

Chris,

  The sequence of events (stupidity - from the actual bash_history) that led to
this issue (I think) was partitioning sdc and sdd with sdc1 and sdd1, but then
creating the arrays with the whole disks by omitting the '1' during the create,
e.g.

# mdadm --create --verbose /dev/md4 --level=1 --metadata=1.2 \
--raid-devices=2 /dev/sdc /dev/sdd

then creating the filesystem on the array:

# mkfs.ext4 -v -L data -m 0.005 -b 4096 -E stride=16,stripe-width=32 /dev/md4

  The gdisk warning regarding the primary GPT header is due to the unused
/dev/sdc1 and /dev/sdd1 partition header being overwritten during the raid
creation process mistakenly on /dev/sdc and /dev/sdd (whole drives). There is
nothing else on this server that would have attempted a read/write to the drives.

  This is a backup box sits idle and configured to take over in case of a
problem with the primary server. There is only one user 'me' and, or course
'root', and the only logins are the weekly ssh for 'pacman -Syu' to update the
Archlinux install. The box simply boots to the multi-user.target and idles. That
is why I am confident it wasn't some other utility that caused the corruption.
The only thing possibility is the case where the Gigabyte virtual.bios file was
written to the beginning of the array (which seems unlikely that it would write
to an array instead of a single drive)

  Since the header corruption was identical for sdc and sdd, it looks like a
side effect of whole-disk raid creation on top of two disks that were
partitioned and intended for the raid to exist on sdc1 and sdd1. My guess is
gdisk is complaining about the unused sdc1/sdd1 GPT header. My drive,
filesystem, array foo runs out before being able to look at the actual record on
the drive as you did in your test case above.

  Let me know if you want me to copy any of the records for you with dd, etc..
if they would have any value to your testing. I'm happy to do it. Otherwise,
I'll scan and responses to the other posts in this thread to see if I can
understand what my best way out of this mess is. Thanks!

-- 
David C. Rankin, J.D.,P.E.
