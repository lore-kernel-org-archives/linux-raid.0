From: Alex Besogonov <alex.besogonov@gmail.com>
Subject: Re: Working TRIM for md RAID
Date: Mon, 7 Nov 2011 15:15:57 -0500
Message-ID: <CA+4wGE6np=4t4=vCUUaQSYGVYuagst2wZvW+4zB4HYtctJ7a4g@mail.gmail.com>
References: <CA+4wGE4VwodRhzi4FQ0+32Vd9UmjVt-xy34t-uBRxsGbVkdkZg@mail.gmail.com>
	<CAHtT9Rs27b3uA3S2JCPa1QvC4qMnhBtAZKOrCw4GNPB4dOt4YQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAHtT9Rs27b3uA3S2JCPa1QvC4qMnhBtAZKOrCw4GNPB4dOt4YQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Rees <drees76@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Nov 7, 2011 at 2:54 PM, David Rees <drees76@gmail.com> wrote:
>> Since it calls TRIM on raw devices there is a possibility of really bad data
>> corruption bugs. So there's test/test.sh script which try to test mdtrim by
>> creating MD array on a single SSD drive, filling it up with random data and
>> then TRIMing empty space. So far, it works for me but it would be great to
>> have more test results.
>> You can get it here: https://github.com/Cyberax/mdtrim
> Nice - I'll have to give this a shot - have you found that SSDs
> generally "zero" out the trimmed space so that the mismatch_cnts stay
> in sync?
Modern drives generally do. You can check it by running "hdparm -I /dev/sda"
and checking that "Deterministic read ZEROs after TRIM" is on.

> I had worked on modifying the raid1ext4trim.sh to run on MD1 arrays,
> but was never brave enough to test it on live data yet and don't have
> spare SSDs to use for testing.
I've actually used our spare drive on production server to do testing. You can
create MD array on /dev/sda1 and /dev/sda2 :) The test script actually does
exactly that.

I'm working on RAID0 support, should be ready soon.
