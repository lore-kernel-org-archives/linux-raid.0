From: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Subject: dm-integrity
Date: Sun, 12 Jan 2020 14:42:16 +0100
Message-ID: <CAJH6TXhnkB10BUENn0P+qXy4nunwY6QVtgDvaFVpfGDpvE-V=Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I'm testing dm-integrity.
Simple question: when corrupted data are found, repair is done
immediately or on next scrub?

This is what I have:

[ 6727.395808] md: data-check of RAID array md0
[ 6727.528589] device-mapper: integrity: Checksum failed at sector 0xe228
[ 6727.938689] md: md0: data-check done.
[ 6749.125075] md: data-check of RAID array md0
[ 6749.664269] md: md0: data-check done.

if repair is done immediatly, would be possible to add a single log
line saying that ?
something like:
[ 6727.528589] md: md0: Repaired data at sector 0xe228
