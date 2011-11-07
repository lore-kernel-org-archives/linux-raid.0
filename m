From: David Rees <drees76@gmail.com>
Subject: Re: Working TRIM for md RAID
Date: Mon, 7 Nov 2011 11:54:06 -0800
Message-ID: <CAHtT9Rs27b3uA3S2JCPa1QvC4qMnhBtAZKOrCw4GNPB4dOt4YQ@mail.gmail.com>
References: <CA+4wGE4VwodRhzi4FQ0+32Vd9UmjVt-xy34t-uBRxsGbVkdkZg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+4wGE4VwodRhzi4FQ0+32Vd9UmjVt-xy34t-uBRxsGbVkdkZg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alex Besogonov <alex.besogonov@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Oct 18, 2011 at 1:24 PM, Alex Besogonov
<alex.besogonov@gmail.com> wrote:
> Well, I've written a simple utility which TRIMs empty space on MD RAID-1
> devices, ext4/3 on RAID-1 are supported. My script was inspired by
> raid1ext4trim.sh-1.4 script in hdparm, but my script also supports TRIM on
> arbitrary partitioned devices.
>
> Since it calls TRIM on raw devices there is a possibility of really bad data
> corruption bugs. So there's test/test.sh script which try to test mdtrim by
> creating MD array on a single SSD drive, filling it up with random data and
> then TRIMing empty space. So far, it works for me but it would be great to
> have more test results.
>
> You can get it here: https://github.com/Cyberax/mdtrim

Nice - I'll have to give this a shot - have you found that SSDs
generally "zero" out the trimmed space so that the mismatch_cnts stay
in sync?

I had worked on modifying the raid1ext4trim.sh to run on MD1 arrays,
but was never brave enough to test it on live data yet and don't have
spare SSDs to use for testing.

-Dave
