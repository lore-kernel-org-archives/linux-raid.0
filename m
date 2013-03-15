From: Chris Murphy <lists@colorremedies.com>
Subject: Re: md RAID1 passes I/O errors to the filesystem despite having alive mirrors?
Date: Thu, 14 Mar 2013 22:04:17 -0600
Message-ID: <E8003AD2-CDB8-4007-A80C-D95350144C90@colorremedies.com>
References: <20130315041054.79eb5dcc@natsu>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130315041054.79eb5dcc@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Mar 14, 2013, at 4:10 PM, Roman Mamedov <rm@romanrm.ru> wrote:

>=20
> - a device (sdg1) was added as a write-mostly member to a degraded tw=
o-member RAID1 (md3) and started recovering;
> - then it had some I/O errors;

Actually, I'm confused. The UNC errors lines aren't directly tied to sd=
g, but then later =85. (The following lines in [] are one contiguous un=
edited section from the dmesg, in order but split up.)

[  771.438883] Add. Sense: Unrecovered read error - auto reallocate fai=
led
[  771.438887] sd 10:0:0:0: [sdg] CDB:=20
[  771.438890] Read(10): 28 00 00 0c 5a 00 00 00 20 00
[  771.438904] end_request: I/O error, dev sdg, sector 809472

=85 these are lines clearly indicating it's a Read error with sdg. But =
why is sdg1, which is rebuilding, reading anything at all?=20

So it's actually three things:
1. sdg is reading, why?
2. sdg is encountering UNC read errors, probably bad sectors, why it's =
new right?
3. md3 might be getting the mirrored copy off sdf, I can't actually tel=
l

[  771.438945] btrfs: bdev /dev/md3 errs: wr 0, rd 9, flush 0, corrupt =
0, gen 0

That line is btrfs reporting read errors from md3, not corruptions.

[  771.439011] ata11: EH complete
[  771.439035] btrfs no csum found for inode 31016 start 5668864
[  771.479594] btrfs csum failed ino 31016 off 5668864 csum 2731683453 =
private 0

What are your btrfs mount options? Are you using nodatasum or nodatacow=
?

Chris Murphy--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
