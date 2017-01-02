From: Ben Kamen <benjammin2068@gmail.com>
Subject: Re: Using mdadm --grow to resize a RAID1
Date: Mon, 2 Jan 2017 13:11:32 -0600
Message-ID: <CADDTLRDgH9RvDkVpVAQSLGZVf75f4-jTFguYoxFFifmj_uMF9A@mail.gmail.com>
References: <4716208e-12a9-1ae8-46f4-a89ae15d9077@gmail.com>
 <586A454F.1010308@youngman.org.uk> <ca87be95-bfb1-10c6-18d4-9aca4a6e3558@gmail.com>
 <20170102212412.19832496@natsu> <e37c42da-71f5-e83e-4e9f-2ec3961a14a0@gmail.com>
 <CADDTLRAY=VHydpXOUMh0OSsVYnYefKyo1vtR3hZx4vyGsSW3tQ@mail.gmail.com>
 <586A993C.8010601@youngman.org.uk> <CADDTLRA2fNyKTCsxK_G-2k4p-01wn16M7T_ruRxt_Dot+6-8Aw@mail.gmail.com>
 <586AA155.9000802@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <586AA155.9000802@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Jan 2, 2017 at 12:52 PM, Wols Lists <antlists@youngman.org.uk> wrote:
>
> OUCH!
>
> I don't know how far the kernel and mdadm have come since then, and what
> has or has not been backported, but it sounds like you want a modern
> rescue CD.
>
> I'd be inclined to get something like SystemRescueCD
> https://www.system-rescue-cd.org/SystemRescueCd_Homepage and see if the
> mdadm and kernel on that work any better. It wouldn't surprise me if
> they do.


LoL... yea... Long term stability over bleeding-nose "now what broke?!?"

This server has been plodding away for (I think) over 6yrs now.

I'll download and check it out. I had a feeling I'd need to go
single-user or boot from an external source.

I'm doing the grow on that pesky raid5 (now raid6) I mentioned a while
back. Turned out it looks to be the old samsung drives that were
causing me problems with that JBOD controller. I upgraded the RAID6 to
2TB drives while I was in the midst of getting rid of the 40,000+hr
old 1TB samsungs.

So I'm doing the grow on that from 3tb to 6tb as we speak from single
user mode and that's chugging along fine.

I'll report back later..

Thanks a bunch of the insight.

 -Ben
