From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: Spares and partitioning huge disks
Date: Thu, 13 Jan 2005 11:11:18 +0100
Message-ID: <63uhb2-gku.ln1@news.it.uc3m.es>
References: <FA095C015271B64E99B197937712FD025109C6@freedom.grz.icomedias.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Bene Martin <martin.bene@icomedias.com> wrote:
> Neat concept :-) I still have an issue with it though: the raid 1 resync
> will fail if there's an unreadable block on the disk designated for
> replacemant; I'd call this fairly probable since there's probably a
> reason you want to replace the disk..

You're right. 

>    The desired situation would be for
> raid code to reconstruct the required data from teh remainin disks and
> write that to the new disk.

Hmm.  One could either continue the low level resync after the read
error but mark that block bad in a bitmap (on the top level array),
or fail the whole low level array to the top level, and wait for the
top level to resync it.

This seems to argue that arrays contained in arrays should be able to
communicate upwards. Any more details, anyone?

Adding the robust-read patch that I posted a few days ago can't hurt,
but it won't get one out of jail in the situation you describe because
the redundant information required to fix the problem is not always
available at the level at which it is detected.

Peter

