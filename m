From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: recover data from linear raid
Date: Tue, 27 Jun 2006 11:23:10 +1000
Message-ID: <17568.34942.243102.778519@cse.unsw.edu.au>
References: <Pine.LNX.4.64.0606242233000.32322@tassadar.physics.auth.gr>
	<17566.13544.15613.709664@cse.unsw.edu.au>
	<Pine.LNX.4.64.0606261640330.16450@tassadar.physics.auth.gr>
	<Pine.LNX.4.64.0606261818510.18573@tassadar.physics.auth.gr>
	<Pine.LNX.4.64.0606261835040.18573@tassadar.physics.auth.gr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Dimitris Zilaskos on Monday June 26
Sender: linux-raid-owner@vger.kernel.org
To: Dimitris Zilaskos <dzila@tassadar.physics.auth.gr>
Cc: linux-raid@vger.kernel.org, ext3-users@redhat.com
List-Id: linux-raid.ids

On Monday June 26, dzila@tassadar.physics.auth.gr wrote:
> 
>  	This is what I get now, after creating with fdisk /dev/hdb1 and 
> /dev/hdc1 as linux raid autodetect partitions

So I'm totally confused now.

You said it was 'linear', but the boot log showed 'raid0'.

The drives didn't have a partition table on them, yet it is clear from
the old boot log that the did.  Are you sure they are the same drives,
'cause it doesn't seem like it.

You could try hunting for ext3 superblocks on the device.  There might
be an easier way but

  od -x /dev/hdb | grep '^.....60 .... .... .... .... ef53 '

should find them.  Once you have this information we might be able to
make something work.  But I feel the chances are dwindling.


NeilBrown
