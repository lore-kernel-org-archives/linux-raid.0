From: Tom Oehser <tom@toms.net>
Subject: Re: is automount affecting root device? huh?
Date: Thu, 1 Jul 2004 08:50:03 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0407010848260.471@jupiter.toms.net>
References: <Pine.LNX.4.58.0407010801300.471@jupiter.toms.net>
 <40E405EA.8040803@wasp.net.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <40E405EA.8040803@wasp.net.au>
To: Brad Campbell <brad@wasp.net.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


But, the other drive is a scsi controller- and lilo does the right thing-
and surely it isn't confusing 'root = /dev/rd/c0d0p1' with '/dev/md1'...

Anyway, it seems to do the right thing *if* I have an fstab entry, *or*
I force it with "raid=noautomount" from lilo.conf.

-Tom
