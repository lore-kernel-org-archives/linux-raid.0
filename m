From: Daniel Reichelt <mail@itamservices.de>
Subject: Re: Raid array is not automatically detected.
Date: Fri, 17 Oct 2008 17:07:16 +0200
Message-ID: <48F8AA24.7050607@itamservices.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: bryan.christ@hp.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Bryan,
I was just having the same problem and the mdadm man page clearly states:
----------------------------
--homehost=
    This will override any HOMEHOST setting in the config file and provides the
identity of the host which should be considered the home for any arrays.

    When creating an array, the homehost will be recorded in the superblock.
For version-1 superblocks, it will be prefixed to the array name. For
version-0.90 superblocks, part of the SHA1 hash of the hostname will be stored
in the later half of the UUID.

    When reporting information about an array, any array which is tagged for
the given homehost will be reported as such.

****
    When using Auto-Assemble, only arrays tagged for the given homehost will be
assembled.
****
----------------------------

So just once stop your array and manually assemble it like
mdadm -A <md-device> <components> --homehost=<somestring> --update=homehost
and from the next reboot on, that array, too, will automatically be assembled
by the linux kernel.
HTH
Daniel
