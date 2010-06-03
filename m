From: Christian Gatzemeier <c.gatzemeier@tu-bs.de>
Subject: Re: Question about preferred minor.
Date: Thu, 3 Jun 2010 08:42:44 +0000 (UTC)
Message-ID: <loom.20100603T104147-488@post.gmane.org>
References: <AANLkTimbMat99Su8F4FauQIa8mpeZJk6syJ0oXjHyygG@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Andrew Dunn <andrew.g.dunn.dod <at> gmail.com> writes:

> What is the meaning of Preferred Minor : 2 ?

Most of the time that array will get assembled as md2, but conflicts,
other numbers and errors stemming from differently assembled arrays can
occur.

From https://wiki.ubuntu.com/ReliableRaid:
"Mdadm is setting up arrays according to unreliable superblock
information. (Device "minor" numbers, labels and hostnames in
superblocks are not sure to be unique and can be outdated.) This is
combined with the idea of fixing the unreliability by limiting array
assembly with information from mdadm.conf. (Defining PARTITIONS, ARRAY,
HOMEHOST lines.) Consequently this forces setup tools, admins and
installers to create mdadm.conf files and subjects them to the exact
same reliability problems."

I guess this conflict prone behavior is mostly legacy behavior from the
past, or is there still an apparent reason to expose dynamic kernel
internals like the minor to userspace instead of basing device node name on
"md-UUID"?

Regards,
Christian


