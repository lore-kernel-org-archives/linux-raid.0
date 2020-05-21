From: Roger Heflin <rogerheflin@gmail.com>
Subject: Re: re-add syntax
Date: Thu, 21 May 2020 13:40:56 -0500
Message-ID: <CAAMCDecB+CU-EGtx+4bMPKBYcy65sgT-8MW=s=OeviyZeq6URA@mail.gmail.com>
References: <20200520200514.GE1415@justpickone.org> <5EC5BBEF.7070002@youngman.org.uk>
 <20200520235347.GF1415@justpickone.org> <5EC63745.1080602@youngman.org.uk>
 <20200521110139.GW1711@justpickone.org> <20200521112421.GK1415@justpickone.org>
 <5EC66D4E.8070708@youngman.org.uk> <20200521123306.GO1415@justpickone.org>
 <828a3b59-f79c-a205-3e1e-83e34ae93eac@youngman.org.uk> <20200521131500.GP1415@justpickone.org>
 <20200521180700.GT1415@justpickone.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200521180700.GT1415@justpickone.org>
Sender: linux-raid-owner@vger.kernel.org
To: David T-G <davidtg-robot@justpickone.org>
Cc: Linux RAID list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

For re-add to work the array must have a bitmap, so that mdadm knows
what parts of the disk need updating.

mine looks like this:
md13 : active raid6 sdi3[9] sdf3[12] sdg3[6] sdd3[1] sdc3[5] sdb3[7] sde3[10]
      3612623360 blocks super 1.2 level 6, 512k chunk, algorithm 2
[7/7] [UUUUUUU]
      bitmap: 0/6 pages [0KB], 65536KB chunk


On Thu, May 21, 2020 at 1:10 PM David T-G <davidtg-robot@justpickone.org> wrote:
>
> Hi, all --
>
> ...and then davidtg-robot@justpickone.org said...
> %
> % ...and then antlists said...
> % %
> % % So *you* should choose re-add. Let mdadm choose add if it can't do a re-add.
> %
> % Thanks.  Sooooo ...  Given this
> ...
> % does this
> %
> %   mdadm --manage /dev/md0 --re-add /dev/sdd1
> %
> % look like the right next step?
>
> Perhaps it did, but it wasn't to be:
>
>   diskfarm:root:10:~> mdadm --manage /dev/md0 --re-add /dev/sdd1
>   mdadm: --re-add for /dev/sdd1 to /dev/md0 is not possible
>
> So we'll try "add"
>
>   diskfarm:root:10:~> mdadm --manage /dev/md0 --add /dev/sdd1
>   mdadm: added /dev/sdd1
>
> and now we wait :-)
>
>
> Thanks again to all
>
> :-D
> --
> David T-G
> See http://justpickone.org/davidtg/email/
> See http://justpickone.org/davidtg/tofu.txt
>
