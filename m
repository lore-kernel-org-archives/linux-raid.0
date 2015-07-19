From: Steven Reddie <steven.reddie@gmail.com>
Subject: Re: Reversing parity recalculation on out-of-order RAID 6 array
Date: Sun, 19 Jul 2015 12:26:43 +1000
Message-ID: <CAFcup8EbE04Z=60LFLLAF6L+9Kd08aUMkC+8deqwR9Sap5oo-A@mail.gmail.com>
References: <CAFcup8FgJqu6q2BoUc7OSEL=iCFf_43wzj7dBuFXYp2R0t2kdg@mail.gmail.com>
	<alpine.DEB.2.02.1507180731040.11810@uplift.swm.pp.se>
	<CAFcup8G230TBec=FzM45GqUkb218yWcYiJJiHDNOkv9MQHkF0g@mail.gmail.com>
	<alpine.DEB.2.02.1507181342220.11810@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1507181342220.11810@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

It's the same as if I had lost two disks from the array, which RAID 6
can recover. The difference is that for each stripe (right
terminology?) of the array, the overwrites didn't occur on the same
two disks due to the "Q A B C P" layout rotating from stripe to stripe
(each 64KB * 5 in my case). Therefore, for any given stripe, which
disks were overwritten is a function of the current incorrect ordering
of the disks in the array and the offset of the stripe (which tells
which rotation of "Q A B C P" is used). Including knowledge of the
original correct ordering of the disks then allows mapping to which
two components of the original data have been lost (ie. two of Q, A,
B, C, or P). Then it is a simple matter of recalculating the missing
components from the survived components.

I'm now almost done with an nbd-based translator that does this
reversal on the fly (ie. takes /dev/sdg[a-e]5 as input and presents
the translated versions as /dev/nbd[0-4]). Since I wanted to do the
remapping only once per stripe, I haven't used the nbd server and
client code as I'd have to run an instance of each for each of the 5
disks in my array. I've got my own server and client code that
interfaces with the nbd kernel module in the same way, but provides
access to all disks through the one instance.

I don't want to risk messing with any of the MD or LVM metadata on the
Synology, so once the translator is finished I will try assembling an
array from these devices across the network on another machine and
check/mount the filesystem.

I was hoping that there might be a tried and tested tool already
available for this, but if not I'll continue with mine.

Steven

On Sat, Jul 18, 2015 at 9:43 PM, Mikael Abrahamsson <swmike@swm.pp.se> wrote:
> On Sat, 18 Jul 2015, Steven Reddie wrote:
>
>> I need to reverse these disk writes across then entire length of the
>> array, after which I can reassemble the array in the correct order.
>
>
> If you did not use --assume-clean, and had the wrong parity order and the
> array was "resynced", I don't see how you did not irrevocably overwrote
> important information and you now can't reverse this.
>
> --
> Mikael Abrahamsson    email: swmike@swm.pp.se
