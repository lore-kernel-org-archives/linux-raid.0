From: Chris Murphy <lists@colorremedies.com>
Subject: Re: RAID6 reshape, 2 disk failures
Date: Wed, 17 Oct 2012 03:09:03 -0600
Message-ID: <235A81EB-2E6D-45AD-9175-29ABA1628632@colorremedies.com>
References: <CADNH=7FunKmUSREJJz2Lonqjb42gB_WHMQJ7-jmip-X8-1yZnw@mail.gmail.com> <C0A56E30-4D1A-44D3-8480-AC70706897B3@colorremedies.com> <CADNH=7GRyxe7c1NE-5WQUnkpmorchoYCWYtWgeabHkk4pzVMvg@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADNH=7GRyxe7c1NE-5WQUnkpmorchoYCWYtWgeabHkk4pzVMvg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Oct 17, 2012, at 2:03 AM, Mathias Bur=E9n wrote:

> Weekly scrubs and weekly offline self-tests. SMART always looked good=
,
> until 1 drive died completely, the other has 5 uncorrectable sectors.
> LCC is under 250K. WD20EARS.

Color me confused. Uncorrectable sectors should produce a read error on=
 a check, which will cause the data to be reconstructed from parity, an=
d written back to those sectors. A write to a bad sector, if persistent=
, will cause it to be relocated. If this isn't possible, the disk is to=
ast if it can't reliably deal with bad sectors (out of reserve sectors?=
)

The smartmontools page has information on how to clear uncorrectable se=
ctors manually. But I'd think check would do this.

> There are basically no files under 8GB on the array so therefore I
> thought the new chunk size made sense.

Yeah it seems reasonable in that case. But unless it's benchmarked you =
don't actually know if it matters.

> It's slow because it's broken (see above).
> Any idea why it says rebuilding, when it's not? Is it going to attemp=
t
> a rebuild after the reshape?

Not sure. With two drives missing, you're in a very precarious situatio=
n. I would not worry about this detail until you have the sda (#6) repl=
aced and rebuilt. Presumably the reshape must finish before the rebuild=
 will start but I'm not sure of this.

What's dmesg reporting while all of this is going on?


Chris Murphy--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
