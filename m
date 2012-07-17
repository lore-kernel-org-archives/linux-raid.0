From: Sebastian Riemer <sebastian.riemer@profitbricks.com>
Subject: raid1: metadata 1.2 size calculation formula needed
Date: Tue, 17 Jul 2012 11:27:41 +0200
Message-ID: <5005300D.6000709@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil, hi others,

we want to be able to calculate the size of the MD metadata 1.2 + bitma=
p
size in advance before creating MD RAID 1 volumes.
Is there somewhere a documented formula?

I guess the metadata is at fixed size + 0x1000 at the beginning of the
block device. Then, the bitmap size depends on the bitmap chunksize +
boundary filling.

When growing/shrinking, the bitmap remains at the size from creation an=
d
only the bitmap chunksize is adjusted, right?

Cheers,
Sebastian

--=20
Sebastian Riemer
Linux Kernel Developer

ProfitBricks GmbH =95 Greifswalder Str. 207 =95 10405 Berlin, Germany
www.profitbricks.com =95 sebastian.riemer@profitbricks.com

Sitz der Gesellschaft: Berlin
Registergericht: Amtsgericht Charlottenburg, HRB 125506 B
Gesch=E4ftsf=FChrer: Andreas Gauger, Achim Weiss

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
