From: Phil Turmel <philip@turmel.org>
Subject: Re: GPT corruption on Primary Header, backup OK, fixing primary nuked
 array -- help?
Date: Tue, 26 Jul 2016 18:10:05 -0400
Message-ID: <767a0ad7-bb45-b0b8-5d8b-08f65d346fa9@turmel.org>
References: <5796B46B.6060905@suddenlinkmail.com>
 <413b1150-ca38-1907-ea5d-b68ad2f75710@websitemanagers.com.au>
 <5796F4E0.9070206@suddenlinkmail.com> <57971D3C.8040602@suddenlinkmail.com>
 <CAJCQCtQ73Tp_ps57qgDm=S_qdFMHy8J0Z=kB+_TfQD2ugj_6ow@mail.gmail.com>
 <CAJCQCtTUO9nLRDUVQ+nkykiQ2ebc-SO8Oh9VP3_WMVKO2fs7dw@mail.gmail.com>
 <5797D23A.7090606@suddenlinkmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5797D23A.7090606@suddenlinkmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "David C. Rankin" <drankinatty@suddenlinkmail.com>, mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 07/26/2016 05:12 PM, David C. Rankin wrote:
>   Let me know if you want me to copy any of the records for you with dd, etc..
> if they would have any value to your testing. I'm happy to do it. Otherwise,
> I'll scan and responses to the other posts in this thread to see if I can
> understand what my best way out of this mess is. Thanks!

Just zero the first 4k of each drive, wiping the broken GPT partition
table.  Continue using the whole device in your array.  No reformat or
other data movement required.

There's nothing wrong with using entire disks in your array.

You won't be able to re-add sdd because as Chris said, "fixing" the
primary GPT broke mdadm's superblock.  After zeroing the beginning 4k of
sdd, --add it to your array and let it rebuild.

Phil
