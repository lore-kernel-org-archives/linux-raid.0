From: "David C. Rankin" <drankinatty@suddenlinkmail.com>
Subject: Re: GPT corruption on Primary Header, backup OK, fixing primary nuked
 array -- help?
Date: Tue, 26 Jul 2016 19:19:19 -0500
Message-ID: <5797FE07.709@suddenlinkmail.com>
References: <5796B46B.6060905@suddenlinkmail.com>
 <413b1150-ca38-1907-ea5d-b68ad2f75710@websitemanagers.com.au>
 <5796F4E0.9070206@suddenlinkmail.com> <57971D3C.8040602@suddenlinkmail.com>
 <CAJCQCtQ73Tp_ps57qgDm=S_qdFMHy8J0Z=kB+_TfQD2ugj_6ow@mail.gmail.com>
 <CAJCQCtTUO9nLRDUVQ+nkykiQ2ebc-SO8Oh9VP3_WMVKO2fs7dw@mail.gmail.com>
 <5797D23A.7090606@suddenlinkmail.com>
 <767a0ad7-bb45-b0b8-5d8b-08f65d346fa9@turmel.org>
 <5797EB6D.2000104@suddenlinkmail.com>
 <CAJCQCtQQ=bEuN9f+4NX5VmVgtt41opTSddM7GQ8G6HMcb+VXmA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJCQCtQQ=bEuN9f+4NX5VmVgtt41opTSddM7GQ8G6HMcb+VXmA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 07/26/2016 06:23 PM, Chris Murphy wrote:
> Yeah fine, or type the count= first so that if you accidentally hit
> return after you've completed typing if= and of= but before count= you
> aren't zeroing your drive very slowly but still too fast for a cancel
> to help save you.
> 
> Just don't use bs=1 when you go to zero the backup GPT, because the
> sector values are predicated on 512 byte sectors, which happens to be
> dd's default bs= size. So if you use bs=1 without altering the seek
> value, you'll break something again. :-D
> 

Heh, heh... Yes, my proclivity for an errant key is notorious ;-)

All and all, thank you and Phil and the rest. This exercise has really helped
separate how the distinction between the array itself how it relates to the
filesystem and how that interacts with the underlying partitioning (the fact
that whole disk raid1 is fine). Where the initial confusion hit was my lack of
understanding the mdadm will in fact use the entire disk if you tell it to --
even if you intended to create the array out of partitions.

Once that occurred and I happily created the ext4 filesystem, I just blindly
thought it was within the sdc1/sdd1 partitions, and it never occurred to me that
it wasn't until this fiasco occurred. Even with the 50 times I've looked at the
mdstat info, nothing clicked regarding the missing number. The rest has been a
good learning experience. Stopping, restarting in degraded mode, etc.. when that
is something you rarely do (I think my last post involving working though a
drive failure was 2013...)

So thanks to all, In 165 more minutes I should be up and running again:

Personalities : [raid1]
md4 : active raid1 sdd[2] sdc[0]
      2930135488 blocks super 1.2 [2/1] [U_]
      [======>..............]  recovery = 34.5% (1013009664/2930135488)
finish=165.7min speed=192823K/sec
      bitmap: 2/22 pages [8KB], 65536KB chunk


-- 
David C. Rankin, J.D.,P.E.
