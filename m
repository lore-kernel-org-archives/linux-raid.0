From: Ladislav Mate <ladislav.mate@gmail.com>
Subject: Re: looking for good reference on storage configuration
Date: Thu, 5 Nov 2015 18:44:30 +0100
Message-ID: <CAG--WThaDTXk9udk=bfp8_mR+CzLgTdkNadWTfvh0nxUrpt+Pw@mail.gmail.com>
References: <56277E47.9070003@meetinghouse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <56277E47.9070003@meetinghouse.net>
Sender: linux-raid-owner@vger.kernel.org
To: Miles Fidelman <mfidelman@meetinghouse.net>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Oct 21, 2015 at 2:00 PM, Miles Fidelman
<mfidelman@meetinghouse.net> wrote:
> Hi Folks,
>
> Perhaps someone here might be able to point me at a reference or two =
on
> alternatives and best practices for configuring storage for a server =
- using
> a mix of SSDs and conventional drives.
>
> I'm in the process of upgrading a small cluster of 4 machines - each
> containing RAID arrays, with DRBD across clusters to support failover=
=2E  Easy
> enough with a uniform collection of HDDs.  But I can't get my head ar=
ound
> how to add SSDs into the mix - what with the mismatch in access speed=
s and
> all, it would seem like one needs a more complex configuration with a=
 level
> of caching between the faster and slower media.
>
> Seems like someone would have written a book, or tutorial, or case st=
udy, or
> conference presentation - but damned if I can find anything.  Any poi=
nters,
> or guidance, would be much appreciated.
>
> Thanks,
>
> Miles Fidelman
>
> --
> In theory, there is no difference between theory and practice.
> In practice, there is.   .... Yogi Berra
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
Hi Miles,
might me long shot, but can take a look on LVM caching..
Good description how to setup it is here :
http://blog-vpodzime.rhcloud.com/?p=3D45
Working for me for months now.... without DRBD.
HTH,

--
Ladislav M=C3=A1te
--
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
