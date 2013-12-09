From: Tomas Agartz <tlund@nxs.se>
Subject: Re: How to assemble 4-disk raid5 with one broken disk and one marked
 as spare by operator error?
Date: Mon, 9 Dec 2013 12:27:57 +0100 (CET)
Message-ID: <Pine.LNX.4.61.1312091224020.13787@envy.nxs.se>
References: <Pine.LNX.4.61.1312082056110.13787@envy.nxs.se>
 <20131209144645.70e01149@notabene.brown>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20131209144645.70e01149@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 9 Dec 2013, NeilBrown wrote:

> If you want to re-add, it is safest to ask mdadm to --re-add, not to --add.

Yeah, that was a bit of a brain fart :(

> The only real option at this point is to --create the array.  There isn't
> enough information for mdadm to be able  to do anything clever.

> Check the "Data Offset" of the devices and make sure the newly created array
> gets the same "Data Offset" (it can explicitly be set with the latest mdadm).

Ok, then I was on the right track at least.

However! Good news! After fiddeling with SATA cables and, in the end 
replacing all of them, I managed to get the "sdb" disk working again. I 
did a --force assemble with those 3 disks and then added the fourth disk 
back and let it rebuild. Since the array was never written to while all of 
this happened, the filesystem (and all the data) was intact when done.

Best regards,
Tomas
