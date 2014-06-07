From: Chris Murphy <lists@colorremedies.com>
Subject: Re: writing zeros to bad sector results in persistent read error
Date: Sat, 7 Jun 2014 10:42:50 -0600
Message-ID: <59249777-4AF5-4C9D-8FBB-C06401201071@colorremedies.com>
References: <B7EA34DA-1064-45B1-B0C0-B7C423C7EB47@colorremedies.com> <20140607075140.277c0880@natsu>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140607075140.277c0880@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org List" <linux-raid@vger.kernel.org>
Cc: Roman Mamedov <rm@romanrm.net>, Roger Heflin <rogerheflin@gmail.com>
List-Id: linux-raid.ids


I "embargoed" the bad sector with partitioning to get the user back up =
and running. In the course of an OS X install, it managed to create a "=
recovery/boot" partition right on top of the bad sector. It no longer r=
eturns a read error for that sector. Clearly it was fixed with whatever=
 write command the installer used, and dd as I used it just does someth=
ing different and fails. There are more pending sectors so once I find =
their LBAs with SMART offline testing I'll try the other mentioned tech=
niques.

What I'm still confused about is, an ATA secure erase had been done and=
 yet the Current_Pending_Sector count was still 48, before and after th=
e secure erase. That tells me that secure erase is just about zeroing a=
nd the drive firmware isn't actually confirming if the writes were succ=
essful. Tragic. I'd have thought it would write such sectors, confirm t=
hey're bad, and remove them from use in one whack, this is apparently n=
ot the case.


On Jun 6, 2014, at 7:51 PM, Roman Mamedov <rm@romanrm.net> wrote:
> Try again with "oflag=3Ddirect";
>=20
> If that doesn't help, remember this is a 4K-sector drive, maybe you s=
hould
> retry with bs=3D4096 (recalculating the offset so it still writes to =
the proper
> place).

# smartctl -t select,430195536-max /dev/sda

The next bad LBA reported by SMART is 430235856.

# dd if=3D/dev/sda skip=3D430235856 count=3D1 | hexdump -C
dd: error reading =91/dev/sda=92: Input/output error
0+0 records in
0+0 records out
0 bytes (0 B) copied, 6.97353 s, 0.0 kB/s

# dd if=3D/dev/zero of=3D/dev/sda seek=3D430235856 count=3D1
dd: writing to =91/dev/sda=92: Input/output error
1+0 records in
0+0 records out
0 bytes (0 B) copied, 3.69641 s, 0.0 kB/s

# dd if=3D/dev/zero of=3D/dev/sda seek=3D430235856 count=3D8
8+0 records in
8+0 records out
4096 bytes (4.1 kB) copied, 2.50232 s, 1.6 kB/s

# dd if=3D/dev/sda skip=3D430235856 count=3D1 | hexdump -C
1+0 records in
1+0 records out
512 bytes (512 B) copied00000000  00 00 00 00 00 00 00 00  00 00 00 00 =
00 00 00 00  |................|
, 0.287629 s, 1.8 kB/s
*
00000200

###This command with count=3D8 worked. I don't know why it worked this =
time, it didn't with the earlier LBA.  When I issue the read command ab=
ove piped through hexdump that had failed, now it works. Further when I=
 check smart attributes, the current pending sector count has dropped b=
y a value of 8. That seems conclusive the bad sector has been remapped.

So I'll keep doing selective offline tests to find bad sectors, and wri=
te to them this way and report back.


Chris Murphy


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
