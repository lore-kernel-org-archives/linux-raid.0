From: Neil Brown <neilb@suse.de>
Subject: RE: Requesting replace mode for changing a disk
Date: Wed, 13 May 2009 14:31:03 +1000
Message-ID: <18954.19719.172893.761454@notabene.brown>
References: <4A060CBE.9090308@tmr.com>
	<20090513012112681.IEFQ19662@cdptpa-omta02.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Leslie Rhorer on Tuesday May 12
Sender: linux-raid-owner@vger.kernel.org
To: lrhorer@satx.rr.com
Cc: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tuesday May 12, lrhorer@satx.rr.com wrote:
> 
> But doesn't creating the array with the drive wipe the contents?  If so, it
> doesn't seem to me this provides much redundancy.

No.  Creating an array does not wipe the contents.
It might cause a resync which will copy contents from one drive to the
other and I don't promise which one.
However if you:

   mdadm -C /dev/md0 --level 1 -n 2 /dev/foo missing
   mdadm /dev/md0 --add /dev/bar

then the contents on /dev/foo will not be changed (except for a few K
at the end for the metadata) and then all of foo will be copied to
bar.

NeilBrown
