From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: RAID10 scrub
Date: Tue, 1 Oct 2013 22:13:58 +0100
Message-ID: <CADNH=7HfAT4p3_izwQJYe6qmX9ojt50J1rcj3vFPqTyw_7TCZA@mail.gmail.com>
References: <CA+FAjA90MPuA4aQUqmKRAzEsxJFMFJ9_UZFeiWJd__QAmS-mBg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+FAjA90MPuA4aQUqmKRAzEsxJFMFJ9_UZFeiWJd__QAmS-mBg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Keisler <mark@mitsein.net>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 1 October 2013 21:42, Mark Keisler <mark@mitsein.net> wrote:
> Is scrub (sync) needed on RAID10?  I've noticed in mdadm monitor logs that
> it seems to re-allocate data destined for bad blocks on the fly anyway.
>  Maybe I don't quite understand what the scrub does, though :)
> I ran it for the first time on my RAID last night anyway to make sure all
> way well since I am failing out a dying disk for replacement today.
> --
> Mark Keisler
> "I have been here. Now I am going there. Where? ... No, I won't have it!"
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

"Scrubbing" (or verifying the array consistency) is not /required/ on
any array, but it's recommended, if you care about your data. So yeah,
why not? For a RAID10 I suppose it just checks that the copies in the
2 sub arrays are identical.
Another thing to do in addition to scrubbing would be extended SMART
self-tests (smartctl -t long).

Mathias
