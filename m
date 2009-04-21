From: "NeilBrown" <neilb@suse.de>
Subject: Re: Performance of a software raid 5
Date: Tue, 21 Apr 2009 11:19:34 +1000 (EST)
Message-ID: <15c92f8bd27d912e292c013fea2467e4.squirrel@neil.brown.name>
References: <a5cd9eed0904201012o67503049laa50f4cb5b8d88de@mail.gmail.com>
    <49ED096E.1000002@anonymous.org.uk>
    <a5cd9eed0904201710j5b05d9cam8a61b50f34eda2c0@mail.gmail.com>
    <49ED18E6.1090301@anonymous.org.uk>
    <a5cd9eed0904201805n1b52aafm206bda5a1afc0b5c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <a5cd9eed0904201805n1b52aafm206bda5a1afc0b5c@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Johannes Segitz <johannes.segitz@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, April 21, 2009 11:05 am, Johannes Segitz wrote:
> On Tue, Apr 21, 2009 at 2:52 AM, John Robinson
> <john.robinson@anonymous.org.uk> wrote:
>> There's no redundancy but it's still the RAID-5 4-disc layout with 3
>> data
>> and 1 parity, the parity on a different disc in each stripe. In your
>> case
>> with a missing disc, for 3 stripes in 4 you have 2 data and 1 parity. Of
>> course the parity is having to be calculated when you're writing, and
>> whatever would be written to your missing disc is being discarded.
>
> you're right, i didn't think of that. But calculating an xor isn't really
> a big deal (especially with the aes on top of it) so i still can't see why
> it's so slow

Large sequential writes to a degraded RAID5 will be the same speed as to a
non-degraded RAID5.  Smaller random write can still be slower as the
amount of pre-reading can increase.

Reads from a degraded raid5 will be slower not because of the XOR, but
because of needing to read all that extra data to feed in to the XOR.

Have you done any testing without the crypto layer to see what effect
that has?

Can I suggest:

  for d in /dev/sd[gjk]1 /dev/md6 /dev/mapper/data bigfile
  do
    dd if=$d of=/dev/null bs=1M count=100
  done

and report the times.

NeilBrown

