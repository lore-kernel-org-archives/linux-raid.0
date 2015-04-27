From: David Wahler <dwahler@gmail.com>
Subject: Fwd: BUG?: RAID6 reshape hung in reshape_request
Date: Sun, 26 Apr 2015 20:56:58 -0500
Message-ID: <CAGivzjHvk8pSUyWOMzNioNtgpQ7gRoL=hkTX0=m7Mi8KzgRWAg@mail.gmail.com>
References: <CAGivzjGyifS3r0rypqM7n2P-fcA7NvPjJWa6kV_wfGx2biDrDg@mail.gmail.com>
 <20150427112056.7195d226@notabene.brown> <CAGivzjE4zVGpoUdGpgKR_e+EaiBE60R3Ta=o9mW+VFqO8McrrQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGivzjE4zVGpoUdGpgKR_e+EaiBE60R3Ta=o9mW+VFqO8McrrQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

[oops, forgot to cc the list]

On Sun, Apr 26, 2015 at 8:20 PM, NeilBrown <neilb@suse.de> wrote:
>> And the output of mdadm --detail/-E:
>> https://gist.github.com/anonymous/0b090668b56ef54bb2f0
>
> What is wrong with simply including this directly in the email???

My bad; I wasn't sure whether it was appropriate to paste such a long
dump inline.

> Anyway:
>
>   Bad Block Log : 512 entries available at offset 72 sectors - bad blocks present.
>
> that is the only thing that looks at all interesting.  Particularly the last
> 3 words.
> What does
>    mdadm --examine-badblocks /dev/sd[cde]1
> show?

root@ceres:~# mdadm --examine-badblocks /dev/sd[cde]1
Bad-blocks on /dev/sdc1:
          3699640928 for 32 sectors
Bad-blocks on /dev/sdd1:
          3699640928 for 32 sectors
Bad-blocks on /dev/sde1:
          3699640928 for 32 sectors

Hmm, that seems kind of odd to me. For what it's worth, all four
drives passed a SMART self-test, and "dd > /dev/null" completed
without errors on all of them. I just read about the "badblocks" tool
and I'm running it now.

-- David
