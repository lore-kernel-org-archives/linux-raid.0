From: Sebastian Riemer <sebastian.riemer@profitbricks.com>
Subject: Reason for md raid1 max_sectors_kb limited to 127?
Date: Mon, 07 May 2012 11:41:43 +0200
Message-ID: <4FA798D7.4070506@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi list,

I'm wondering why max_sectors_kb is set to 127 with md raid1.
This value is at 512 on normal HDDs.

If I do a file copy on ext4 on a normal HDD then I can see with
blktrace/blkparse that 128 KiB chunks are read and 512 KiB chunks are
written.

With md raid it looks like this: 124 KiB, 4 KiB, 124 KiB, 4 KiB, ... .
This looks very inefficient.

So, is there a particular reason that max_sectors_kb is set to 127?

Cheers,
Sebastian

--=20
Sebastian Riemer
Linux Kernel Developer

ProfitBricks GmbH
Greifswalder Str. 207
10405 Berlin, Germany

Tel.:  +49 - 30 - 60 98 56 991 - 303
=46ax:   +49 - 30 - 51 64 09 22
Email: sebastian.riemer@profitbricks.com
Web:   http://www.profitbricks.com/

Sitz der Gesellschaft: Berlin
Registergericht: Amtsgericht Charlottenburg, HRB 125506 B
Gesch=E4ftsf=FChrer: Andreas Gauger, Achim Weiss
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
