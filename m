From: Jan Kasprzak <kas@fi.muni.cz>
Subject: Re: RAID-10 explicitly defined drive pairs?
Date: Fri, 6 Jan 2012 22:02:27 +0100
Message-ID: <20120106210227.GD13358@fi.muni.cz>
References: <20111212115459.GC20730@fi.muni.cz>
 <4EE61EAE.20101@anonymous.org.uk>
 <20120106150823.GX25976@fi.muni.cz>
 <20120107075526.59ed433c@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120107075526.59ed433c@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>, John Robinson <john.robinson@anonymous.org.uk>
List-Id: linux-raid.ids

NeilBrown wrote:
: > 	I have tried mdadm --add /dev/mdN /dev/sd.. /dev/sd.. /dev/sd..,
: > but it behaves the same way as issuing mdadm --add one drive at a time.
: 
: I would expect that to first recover just the first device added, then
: recover all the rest at once.
: 
: If you:
:   echo frozen > /sys/block/mdN/md/sync_action
:   mdadm --add /dev/mdN /dev......
:   echo recover > /sys/block/mdN/md/sync_action
: 
: it should do them all at once.

	Wow, it works! Thanks!

: I should teach mdadm about this..

	It would be nice if mdadm --add /dev/mdN <multiple devices>
did this.

-Yenya

-- 
| Jan "Yenya" Kasprzak  <kas at {fi.muni.cz - work | yenya.net - private}> |
| GPG: ID 1024/D3498839      Fingerprint 0D99A7FB206605D7 8B35FCDE05B18A5E |
| http://www.fi.muni.cz/~kas/    Journal: http://www.fi.muni.cz/~kas/blog/ |
Please don't top post and in particular don't attach entire digests to your
mail or we'll all soon be using bittorrent to read the list.     --Alan Cox
