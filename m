From: =?UTF-8?Q?Nuno_Magalh=C3=A3es?= <nunomagalhaes@eu.ipp.pt>
Subject: Re: RAID newbie, 1 vs 5, chunk sizes
Date: Tue, 17 Jun 2014 01:41:38 +0100
Message-ID: <CADqA9uajh-vnYFLPyeqV4kLinGwaQDhm0kR2JA+A22OrVabuNg@mail.gmail.com>
References: <CADqA9ua4xuJM3J6mQY7jXrt-5f6Rsv3aFaxyiqL1e80t70R6Rg@mail.gmail.com>
 <539E5504.1080809@turmel.org> <CADqA9ub=-=V_RMF+G2ZniQG06oDJ6KDhdPhDuPeufHFpgs4Mdw@mail.gmail.com>
 <539EFF1C.3000009@turmel.org> <CADqA9ubBicDLwrdgOYNT04P0SO8pi+FK-ipjONY+59ThV0zGKw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADqA9ubBicDLwrdgOYNT04P0SO8pi+FK-ipjONY+59ThV0zGKw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Jun 16, 2014 at 5:14 PM, Nuno Magalh=C3=A3es <nunomagalhaes@eu.=
ipp.pt> wrote:
> The one that is taking the lead is WD Red WD10EFRX. Can't
> find the Toshiba DT01ACA100 at an affordable price anymore and Seagat=
e
> is everywhere.

The WD Red has "intellipower" meaning it can - supposedly - go from
5400 to 7200, depending on various conditions and who you ask. This
means that if i wanted to combine it with the DT01 (traditional 7200),
the overall speed of the array would be dictated by the Red, right?
Doesn't this increase the change that a power outage would leave the
array with a piece of new data only on the DT01? The point of having
the array in the first place would be for it to recover, but that
means RAID1 in this case. If that new chunk had it's parity (not yet
written) on the Red in a RAID5, would it recover? I think i've read
somewhere these drives have some sort of technology to mitigate power
issues which, at the time, i read as "watch battery inside" or
something.

I do have a UPS, a crappy one that'll hold for about 10m. The
problem's that i haven't gotten the serial connection working properly
yet (so no way to tell the system the power is out). Such an outage is
rare here, though.

As for the DT01:
# smartctl -l scterc,70,70 /dev/sda
    SCT Error Recovery Control set to:
           Read:     70 (7.0 seconds)
          Write:     70 (7.0 seconds)
=2E..which will have to go into an init script.


On Mon, Jun 16, 2014 at 10:02 PM, Mark Knecht <markknecht@gmail.com> wr=
ote:
> I'd not head of tiobench before. It seems quite out of date looking a=
t
> the website which suggests it hasn't been updated in 12 years.

Didn't know that, thanks for the pointers. :)
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
