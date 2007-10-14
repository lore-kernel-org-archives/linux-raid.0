From: Neil Brown <neilb@suse.de>
Subject: Re: Help RAID5 reshape Oops / backup-file
Date: Mon, 15 Oct 2007 09:31:23 +1000
Message-ID: <18194.42699.193194.986448@notabene.brown>
References: <20071011142518.igm1jud7ms408ggg@cakebox.homeunix.net>
	<18190.46828.156191.300754@notabene.brown>
	<20071012084328.2f6vk4cdw80kscw0@cakebox.homeunix.net>
	<20071014185550.d6hbv2bk00kkwkgc@cakebox.homeunix.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Nagilum on Sunday October 14
Sender: linux-raid-owner@vger.kernel.org
To: Nagilum <nagilum@nagilum.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday October 14, nagilum@nagilum.org wrote:
> Can someone tell me if I'm on the right track?
> I've now noticed the following:
> # ~/mdadm-2.6.3/mdadm -v -A /dev/md0 /dev/sd[d-e]
> mdadm: looking for devices for /dev/md0
> mdadm: /dev/sdd is identified as a member of /dev/md0, slot -1.
> mdadm: /dev/sde is identified as a member of /dev/md0, slot -1.
> mdadm: No suitable drives found for /dev/md0

Hmm... that might be useful..

I just found your earlier email where you said:

> After the machine came back up (on a rescue disk) I thought I'd
> simply have to go through the process again. So I use add add the
> new disk again. 
> Although that worked, I am now unable to resume the growing
> process. 

Using "add add" again was not correct, and should not have been
possible.
You should have simply assembled the array with the full new set of
devices.  Then reshape would have automatically restarted properly.

Can you remember *exactly* what you did?  If I can reproduce the
situation, I can find the best way to fix it and send you something to
try.

NeilBrown
