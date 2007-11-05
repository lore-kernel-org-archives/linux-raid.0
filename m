From: Paul VanGundy <pvangundy@bradfordnetworks.com>
Subject: Kernel Module - Raid
Date: Mon, 05 Nov 2007 15:19:57 -0500
Message-ID: <472F7AED.1030207@bradfordnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

All,

Hello. I don't know if this is the right place to post this issue but it
does deal with RAID so I thought I would try.

I successfully built a new kernel and am able to boot from it.
However, I need to incorporate a specific RAID driver (adpahci.ko) so we
can use the on-board RAID. The reason I am needing this is because we
have it working with one kernel (the one it was compiled on) but we
can't just copy the adpahci.ko and incorporate it into another kernel
because the kernel complains. I have the adpahci.ko and am unable to get
it to compile against any other kernel because I don't have the original
kernel module (adpahci.c I assume is what I need). Is there any way I
can view the adpahci.ko and copy the contents to make a adpahci.c? Is it
possible to get the kernel object to compile with another kernel only
using the adpahci.ko? Am I making sense?  :)  Thanks in advance.

/paul
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHL3rtul+dQkHY548RAtIDAJoDZWME/Hku9QCESFW/yo/YG3WE5wCfeHPb
fzs7FpKbhSr8PUbl2xrCfGA=
=Lcdq
-----END PGP SIGNATURE-----
