From: Chris Murphy <lists@colorremedies.com>
Subject: Re: bootsect replicated in p1, RAID enclosure suggestions?
Date: Thu, 1 Sep 2016 17:10:40 -0600
Message-ID: <CAJCQCtTSkD=R0-mCR1wOTDKreujMh-bgRbW9XTCfePx5dXSHCg@mail.gmail.com>
References: <20160823050947.GL32250@subspacefield.org> <57C863D2.2010802@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <57C863D2.2010802@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Sep 1, 2016 at 11:22 AM, Wols Lists <antlists@youngman.org.uk> wrote:
> On 23/08/16 06:09, travis+ml-linux-raid@subspacefield.org wrote:
>> Hello all,
>>
>> So I have an Intel NUC (for low power Linux) plugged via USB into a 4
>> bay enclosure doing linear (yeah I know; it's the backup server, the
>> primary is raid10).
>>
>> And every once in a while, this happens (*see end).  The partition 1
>> that would normally contain a MD slice ends up being a replica of the
>> boot cylinder.  I can't tell if it's the mdraid linear impl, the
>> kernel doing something weird, the USB drivers, the enclosure firmware,
>> or what.
>
> Interesting snippet from LWN ...
>
> The Btrfs CRC checking means that a read from a corrupted sector will
> cause an I/O error rather than return garbage. Facebook had some storage
> devices that would appear to store data correctly in a set of logical
> block addresses (LBAs) until the next reboot, at which point reads to
> those blocks would return GUID partition table (GPT) data instead.

Wow that's right in between bizarre and hilarious. Maybe Travis should
check for firmware updates (for the computer, and the enclosure if it
offers such a thing, and maybe even the drives).


 >He
> did not name the device maker because it turned out to actually be a
> BIOS problem. In any case, the CRCs allowed the Facebook team to quickly
> figure out that the problem was not in Btrfs when it affected thousands
> of machines as they were rebooted for a kernel upgrade.

Yeah even in a recent case on linux-btrfs where there's two drives
with bad sectors causing grief, the volume (somewhat surprisingly)
mounted ro,degraded and appears to be mostly recoverable, but the main
thing is that even in that case, other than nocow files, it's expected
anything that copies over (cp, rsync, btrfs send) is not corrupt. If
it were corrupt even after reconstruction from parity (even bad
parity), Brfs will give an I/O error and not submit the data to user
space.


-- 
Chris Murphy
