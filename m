From: carlos@fisica.ufpr.br (Carlos Carvalho)
Subject: Re: data recovery on raid5
Date: Sat, 22 Apr 2006 17:28:49 -0300
Message-ID: <17482.37377.738945.114747@fisica.ufpr.br>
References: <444A7C99.80006@abhost.net>
	<62b0912f0604221248s653843bfx363f346c7ef31a94@mail.gmail.com>
	<444A8D04.20809@abhost.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <444A8D04.20809@abhost.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jonathan (jrs@abhost.net) wrote on 22 April 2006 13:07:
 >I was already terrified of screwing things up -- now I'm afraid of 
 >making things worse
 >
 >based on what was posted before is this a sensible thing to try?
 >
 >mdadm -C /dev/md0 -c 32 -n 4 -l 5 missing /dev/etherd/e0.[023]
 >
 >Is what I've done to the superblock size recoverable?

Raid metadata are stored at the end of the partition, in a small area.
Perhaps some overwrite of data happened, I don't know, but it'd be
small. If you re-make the superblock with the right chunk size you
can read the data back.

I'd suggest following the help you're getting on the list, and if you
don't understand something ask before running any commands. Also don't
do anything that causes writes to the disks (such as fsck) before
getting the raid back...
