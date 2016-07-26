From: Chris Murphy <lists@colorremedies.com>
Subject: Re: GPT corruption on Primary Header, backup OK, fixing primary nuked
 array -- help?
Date: Tue, 26 Jul 2016 17:23:04 -0600
Message-ID: <CAJCQCtQQ=bEuN9f+4NX5VmVgtt41opTSddM7GQ8G6HMcb+VXmA@mail.gmail.com>
References: <5796B46B.6060905@suddenlinkmail.com> <413b1150-ca38-1907-ea5d-b68ad2f75710@websitemanagers.com.au>
 <5796F4E0.9070206@suddenlinkmail.com> <57971D3C.8040602@suddenlinkmail.com>
 <CAJCQCtQ73Tp_ps57qgDm=S_qdFMHy8J0Z=kB+_TfQD2ugj_6ow@mail.gmail.com>
 <CAJCQCtTUO9nLRDUVQ+nkykiQ2ebc-SO8Oh9VP3_WMVKO2fs7dw@mail.gmail.com>
 <5797D23A.7090606@suddenlinkmail.com> <767a0ad7-bb45-b0b8-5d8b-08f65d346fa9@turmel.org>
 <5797EB6D.2000104@suddenlinkmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5797EB6D.2000104@suddenlinkmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "David C. Rankin" <drankinatty@suddenlinkmail.com>
Cc: mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Jul 26, 2016 at 4:59 PM, David C. Rankin
<drankinatty@suddenlinkmail.com> wrote:
> On 07/26/2016 05:10 PM, Phil Turmel wrote:
>> You won't be able to re-add sdd because as Chris said, "fixing" the
>> primary GPT broke mdadm's superblock.  After zeroing the beginning 4k of
>> sdd, --add it to your array and let it rebuild.
>>
>> Phil
>
> Thanks Phil, what's the quickest way to zero the 4k, something like
>
> # dd of=/dev/sdd if=/dev/zero bs=1 count=4096

Yeah fine, or type the count= first so that if you accidentally hit
return after you've completed typing if= and of= but before count= you
aren't zeroing your drive very slowly but still too fast for a cancel
to help save you.

Just don't use bs=1 when you go to zero the backup GPT, because the
sector values are predicated on 512 byte sectors, which happens to be
dd's default bs= size. So if you use bs=1 without altering the seek
value, you'll break something again. :-D




-- 
Chris Murphy
