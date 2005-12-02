From: Neil Brown <neilb@suse.de>
Subject: Re: Data errors on clean, degraded Raid5. Help Please.
Date: Fri, 2 Dec 2005 16:24:48 +1100
Message-ID: <17295.55968.810625.163694@cse.unsw.edu.au>
References: <d39ad6430512011852g47d155a7i3f03db36996c01b2@mail.gmail.com>
	<17295.50156.217214.617838@cse.unsw.edu.au>
	<d39ad6430512012112y5545c2b1v29f93c741d41ffdb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Erich Newell on Friday December 2
Sender: linux-raid-owner@vger.kernel.org
To: Erich Newell <erich.newell@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday December 2, erich.newell@gmail.com wrote:
> Thank you for the feedback Neil.
> 
> Although, your last comment did confuse me a little...run what in
> parallel? Should I be running badblocks against the unassembled
> components of the raid and then doing something like:
>      >fsck -l /badblockfile_sda3.txt /dev/md0
>      >fsck -l /badblockfile_sdb3.txt /dev/md0
>      >fsck -l /badblockfile_sdc3.txt /dev/md0
>      >fsck -l /badblockfile_sdd3.txt /dev/md0

type in haste, repent at leisure....

I was thinking that you wold be using 'badblocks' directly rather then
via fsck, and was suggesting
   badblocks -n /dev/sda3 & badblocks /dev/sdb3 & badblocks /dev/sdd3
   ....

Running 'badblocks' across a raid5 array isn't a good idea, as if
there are any bad block, the devices will be kicked from the array,
and the test will abort.

NeilBrown
