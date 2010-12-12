From: Phil Genera <pg@fivesevenfive.org>
Subject: Re: Crash during raid6 reshape, now cannot restart?
Date: Sat, 11 Dec 2010 19:12:37 -0800
Message-ID: <AANLkTimgP5Cc5U+B6fa8SO8X00PXECtcdbw6H5taHumU@mail.gmail.com>
References: <AANLkTimk7Ecth7n+qPZ7R-JOAmCmJUJbCTAw3uY8FpPO@mail.gmail.com>
 <20101211074305.5f55c4b4@notabene.brown> <20101211090253.2f2b7a7c@notabene.brown>
 <AANLkTikSZTahD2teZg7dkDkfrTaHJhjbG4q0W8n40C7o@mail.gmail.com> <AANLkTin=_nTe8RgrOSyhPbcU26EDxJ=Sx177CzB2MD58@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTin=_nTe8RgrOSyhPbcU26EDxJ=Sx177CzB2MD58@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Dec 11, 2010 at 11:06, Phil Genera <pg@fivesevenfive.org> wrote:
> On Fri, Dec 10, 2010 at 14:11, Phil Genera <pg@fivesevenfive.org> wrote:
>> I'm happy to try my own kernel, but first I think I'll try pulling the
>> disks and putting them on an x86 machine to see if its actually
>> platform related. If that works, I can keep the broken array around
>> for a bit to troubleshoot on. Thanks!
>
> Gave it a shot on an x86 machine today (with an oddly old mdadm, from
> ubuntu lucid), and mdadm segfault'd. I guess there's no avoiding
> building some kernel modules.
>
> details:
>
> $ mdadm --version
> mdadm - v2.6.7.1 - 15th October 2008

I built mdam 3.1.4 from source, and got the array reshaping again on
x86. I'm still trying to build a new raid456.ko on this tiny arm box
with some extra debugging in it.

-- 
Phil
