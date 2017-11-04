From: Reindl Harald <h.reindl@thelounge.net>
Subject: Re: RAID header in XFS area?
Date: Sat, 4 Nov 2017 19:34:42 +0100
Message-ID: <63581b55-f7bc-4408-aa72-a8a5c7cc37bf@thelounge.net>
References: <CAGRSmLv2HqyZmf-nR4SqnPaw2HNxDAaOSMA-QXVyiekF4Q5x5w@mail.gmail.com>
 <59FE0739.8020400@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <59FE0739.8020400@youngman.org.uk>
Content-Language: de-CH
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, "David F." <df7729@gmail.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



Am 04.11.2017 um 19:30 schrieb Wols Lists:
> mdadm did exactly what it is supposed to do. A mirror with one drive is
> degraded, so it assembled the array AND STOPPED. Once you force it past
> this point, I think it will happily go past again no problem, but it's
> designed to refuse to proceed with a damaged array, if the array was
> fully okay previous time.
> 
> So, in other words, the disk and everything else is fine.
> 
> What's happened is that mdadm has assembled the array, realised a disk
> is missing, AND STOPPED.

why would it be supposed that a simple mirror with a mising disk is 
stopped while the whole point of mirroring is to not care about one of 
the disks dying?
