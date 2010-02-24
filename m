From: "Stefan G. Weichinger" <lists@xunil.at>
Subject: Re: emergency call for help: raid5 fallen apart
Date: Wed, 24 Feb 2010 18:02:04 +0100
Message-ID: <4B855B8C.8080802@xunil.at>
References: <4B853DB7.1060406@xunil.at> <4B854040.5080603@xunil.at> <20100224152228.GB11039@cthulhu.home.robinhill.me.uk> <4B85467C.5020008@xunil.at> <4B855621.5010000@xunil.at> <4B855987.1010605@xunil.at>
Reply-To: lists@xunil.at
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B855987.1010605@xunil.at>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


sda fails also:


Feb 24 17:57:42 server-gentoo ata1.00: configured for UDMA/133
Feb 24 17:57:42 server-gentoo sd 0:0:0:0: [sda] Result: hostbyte=0x00
driverbyte=0x08
Feb 24 17:57:42 server-gentoo sd 0:0:0:0: [sda] Sense Key : 0x3
[current] [descriptor]
Feb 24 17:57:42 server-gentoo Descriptor sense data with sense
descriptors (in hex):
Feb 24 17:57:42 server-gentoo 72 03 11 04 00 00 00 0c 00 0a 80 00 00 00
00 00
Feb 24 17:57:42 server-gentoo 01 3c ba 1a
Feb 24 17:57:42 server-gentoo sd 0:0:0:0: [sda] ASC=0x11 ASCQ=0x4
Feb 24 17:57:42 server-gentoo end_request: I/O error, dev sda, sector
20757018
Feb 24 17:57:42 server-gentoo raid5:md4: read error not correctable
(sector 1032 on sda4).
Feb 24 17:57:42 server-gentoo raid5: Disk failure on sda4, disabling
device. Operation continuing on 1 devices
Feb 24 17:57:42 server-gentoo raid5:md4: read error not correctable
(sector 1040 on sda4).
Feb 24 17:57:42 server-gentoo raid5:md4: read error not correctable
(sector 1048 on sda4).

(sector 1072 on sda4).



So I am down to one drive, from 3 ...

:-(

Does it make sense to repeat:

mdadm --assemble
xfs_repair
mount

and rsync stuff aside until it fails again?

I once was lucky with such a strategy ...

S
