From: "Martin Bene" <martin.bene@icomedias.com>
Subject: AW: Please review: Slackware RAID How-To
Date: Mon, 17 May 2004 11:54:51 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <FA095C015271B64E99B197937712FD02262EC5@freedom.grz.icomedias.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
To: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

> I too considered lilo a relic of the past until I started using
> Slackware. Oh well, it seems to do much the same thing, so I'm getting
> used to it again. 

There's one feature in lilo I haven't yet found in grub that keeps me
from switching:

I can specify a kernel image to use just for the next reboot (reverting
to the default image afterwards). This is great for upgrading kernel in
remote locations with limited access to systems - if something goes
wrong, and the system doesn't come up with the new kernel, just have the
system reset to go gack to using a known good kernel.

Bye, Martin



