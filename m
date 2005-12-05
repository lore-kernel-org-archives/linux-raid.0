From: Michael Tokarev <mjt@tls.msk.ru>
Subject: mdadm --size and --update=uuid etc options...
Date: Mon, 05 Dec 2005 13:49:53 +0300
Message-ID: <43941B51.5090601@tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I found it's quite difficult, after resizing underlying
partitions, to compute the new size for
  mdadm /dev/mdX -G --size=xyz
command, because of the way how it finds the superblock
offset.  So, the question is -- is it possible to make
the argument of --size to be optional, and let mdadm to
compute the size automatically, just like resize2fs does
now?  Or, maybe, to keep backward compatibility for
those people who used --size z (as opposed to --size=z),
to recognize `0' as special size, to mean "whole partition"
or "max size".  The latter is probably the best, i think.

The same is for newly appeared --update=uuid:xyz: I'd let
mdadm to choose an uuid just like it does for newly create
array, if the uuid argument isn't specified, like:
  --update=uuid:1234 --- use uuid=1234
  --update=uuid      --- choose random uid

Does it all look ok?

/mjt, who goes to produce some patches...
