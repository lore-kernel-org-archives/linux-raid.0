From: Norman Schmidt <Norman.Schmidt@chemie.uni-erlangen.de>
Subject: Re: ANNOUNCE: mdadm 1.6.0 - A tool for managing Soft RAID under
 Linux
Date: Mon, 7 Jun 2004 00:58:09 +0200 (CEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0406070056480.17664@pcmail.chemie.uni-erlangen.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Neil Brown schrieb:

> The simplest way to access this functionality is with
> 
>     mdadm --create /dev/md/XX --auto=partition --level= ....

I finally got it. After mkdir /dev/md, that works.

One more thing: It would be helpful to have a reference between the device 
name (which is user for mounting, partitionimg etc) and the /proc/mdstat 
entry. In my case that would be /dev/md/mdp1 and md_d0.

For unpartitionable raid this is no problem, since the device name occurs 
in /proc/mdstat directly.

Thanks for the great work so far.

Norman Schmidt.
