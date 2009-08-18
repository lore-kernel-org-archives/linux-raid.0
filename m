From: kwick <kwick@shiftmail.org>
Subject: Hot-swapping: what's that? (and 3ware 9650SE)
Date: Tue, 18 Aug 2009 21:09:19 +0200
Message-ID: <4A8AFC5F.3070108@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello raid-ers
I have been reading previous posts in this ML regarding hot-swapping
capability of controllers or the lack thereof.

One question remains: ok but what is hot-swap anyway?

If I have a controller that does not notify the operating systems of
drive removal and insertions, but will give error if one writes to the
device while the HDD is disconnected, and will correctly write to the
disk if the HDD is later reconnected, would this be "hot-swap"?

Actually we have a 3ware 9650SE controller in JBOD mode here, and it
behaves very similarly to what I have described. Two differences:
1- it actually notifies the OS of drive removal, I can see that in
dmesg, but the block device special-files are still not deleted from the
system in response to this. However if you read or write from those
block devices it immediately returns error (dd stops immediately)
2- you need to use the tw_cli commandline prog to rescan the controller
after the drives' insertion (doing this you can decide whether notify
the OS or not, but this apparently does not make a substantial
difference, it just gets logged in dmesg). The new inserted drives will
get the old drive letters (block-device files), i.e. the drive letters
stay attached to the physical slots, except the case in which you are
reordering drives, in this latter case the controller will try to remap
the "units" so that the drive letters follow the HDDs (it uses the
serial numbers to identify the HDDs).

So is this a "hot-swap" controller or not? What is hot-swap more than this?

BTW I'd have a few more questions which are important for us, related to
hot-swapping. I understand these might be offtopic here, but I see you
are knowledgeable over this matter, so I hope I can ask:

With the 9650SE as described before, I would like to reliably flush all
data to a drive before removing the drive manually.
- Do you confirm that "umount" is not enough for flushing the block device?
- Is the bash "sync" command / sync() syscall what I have to use? (after
umount)
- Is the sync() enough anyway?


Thank you
kwick

