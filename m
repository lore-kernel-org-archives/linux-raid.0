From: Sven Anders <anders@anduras.de>
Subject: Linux 2.6.10 / RAID1 problem
Date: Wed, 05 Jan 2005 21:43:08 +0100
Message-ID: <41DC515C.7030208@anduras.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050202090305090002060309"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------050202090305090002060309
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hello!

I'm expirencing strange problems on my server running Software RAID1 (Mirroring) under
the Linux kernel 2.6.10. It works nicely under Linux 2.4.18!

Configuration:
~ Athlon 1.5GHz, 256MB RAM (tested!)
~ 2x160GB Harddisks (same type) on different IDE controllers
~  (ext3 fs with journalling turned on)
~ Swap is turned off
~ Linux Kernel 2.6.10 (vanilla) without SMP, Preemption turned off

Test case:
~ dd if=/dev/zero of=test0 bs=1M count=300
~ while :; do cp test0 test1; cp test1 test2; cp test2 test0; od test0; done

Error:
~ On Linux 2.4.18 it worked serveral hours perfectly (until I stopped it...)
~ On Linux 2.6.10 after some minutes the following (or similar) error occures:


EXT3-fs error (device md5): ext3_free_blocks_sb: bit already cleared for block 1303980
Aborting journal on device md5.
ext3_abort called.
EXT3-fs error (device md5): ext3_journal_start_sb: Detected aborted journal
Remounting filesystem read-only
EXT3-fs error (device md5) in start_transaction: Journal has aborted
EXT3-fs error (device md5) in start_transaction: Journal has aborted
EXT3-fs error (device md5) in start_transaction: Journal has aborted
EXT3-fs error (device md5) in start_transaction: Journal has aborted
EXT3-fs error (device md5): ext3_free_blocks_sb: bit already cleared for block 1303981
ext3_free_blocks_sb: aborting transaction: Journal has aborted in __ext3_journal_get_undo_access<2>EXT3-fs error (devi
ce md5) in ext3_free_blocks_sb: Journal has aborted
ext3_reserve_inode_write: aborting transaction: Journal has aborted in __ext3_journal_get_write_access<2>EXT3-fs error
~ (device md5) in ext3_reserve_inode_write: Journal has aborted
ext3_reserve_inode_write: aborting transaction: Journal has aborted in __ext3_journal_get_write_access<2>EXT3-fs error
~ (device md5) in ext3_reserve_inode_write: Journal has aborted
EXT3-fs error (device md5) in ext3_orphan_del: Journal has aborted
EXT3-fs error (device md5) in ext3_truncate: Journal has aborted
EXT3-fs error (device md5) in start_transaction: Journal has aborted
__journal_remove_journal_head: freeing b_committed_data
__journal_remove_journal_head: freeing b_committed_data
__journal_remove_journal_head: freeing b_committed_data
EXT3-fs error (device md5) in start_transaction: Journal has aborted
EXT3-fs error (device md5) in start_transaction: Journal has aborted
EXT3-fs error (device md5) in start_transaction: Journal has aborted
EXT3-fs error (device md5) in start_transaction: Journal has aborted
EXT3-fs error (device md5) in start_transaction: Journal has aborted
EXT3-fs error (device md5) in start_transaction: Journal has aborted


After this I have to do a filesystem check and the 2.4.18 kernel reports a dirty RAID and
starts the resync...


Does anybody have an idea?
What's the cause of this???

Is there an known bug in the 2.6.10?
Is the Software RAID in the 2.6 series stable?

Any special kernel compile options not to use when using RAID?
Any other (better) test to do?

Regards
~ Sven

- --
~ Sven Anders <anders@anduras.de>

~ ANDURAS service solutions AG
~ Innstraße 71 - 94036 Passau - Germany
~ Web: www.anduras.de - Tel: +49 (0)851-4 90 50-0 - Fax: +49 (0)851-4 90 50-55

Rechtsform: Aktiengesellschaft - Sitz: Passau - Amtsgericht Passau HRB 6032
Mitglieder des Vorstands: Sven Anders, Marcus Junker, Michael Schön
Vorsitzender des Aufsichtsrats: Dipl. Kfm. Karlheinz Antesberger
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFB3FFc5lKZ7Feg4EcRAoidAJ0W3HLPwNt5oni8zccpquO9jSF/qwCcCQz+
tStmVeAocqqm/G5TzAtDe84=
=urMZ
-----END PGP SIGNATURE-----

--------------050202090305090002060309
Content-Type: text/x-vcard; charset=utf8;
 name="anders.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="anders.vcf"

begin:vcard
fn:Sven Anders
n:Anders;Sven
org:ANDURAS AG;Research and Development
adr;quoted-printable:;;Innstra=C3=9Fe 71;Passau;Bavaria;94036;Germany
email;internet:anders@anduras.de
title:Dipl. Inf.
tel;work:++49 (0)851 / 490 50 - 0
tel;fax:+49 (0)851 / 4 90 50 - 55
x-mozilla-html:FALSE
url:http://www.anduras.de
version:2.1
end:vcard


--------------050202090305090002060309--
