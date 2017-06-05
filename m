From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: Recovery after accidental raid5 superblock rewrite
Date: Tue, 6 Jun 2017 01:56:19 +0200
Message-ID: <20170605235619.GA8478@metamorpher.de>
References: <2009e689-39b7-14fa-44bd-3288f96b9c91@tonel.li>
 <20170603212011.GA13271@metamorpher.de>
 <12fc0496-423a-bca6-ac57-ed40958645e7@tonel.li>
 <20170603232919.GA17108@metamorpher.de>
 <b8b6eb18-2952-86ee-5329-9e4f4c406c3d@tonel.li>
 <20170605092454.GA3651@metamorpher.de>
 <dfa4dd0d-c68a-4e1b-aac7-649f7f1a72f6@tonel.li>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <dfa4dd0d-c68a-4e1b-aac7-649f7f1a72f6@tonel.li>
Sender: linux-raid-owner@vger.kernel.org
To: Paul Tonelli <paul@tonel.li>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jun 06, 2017 at 01:24:41AM +0200, Paul Tonelli wrote:
> mdadm --create /dev/md0 --level=5 --assume-clean --raid-devices=3 missing /dev/mapper/sdd /dev/mapper/sdb

You did not specify the --data-offset here?
Check mdadm --examine to make sure which offset it's using.

> xxd -u /dev/mapper/sdc | grep  -C 3 'LABELONE'
>  >7f001e0: 0000 0000 0000 0000 0000 0000 0000 0000 ................
>  >7f001f0: 0000 0000 0000 0000 0000 0000 0000 0000 ................
>  >7f00200: 4C41 4245 4C4F 4E45 0100 0000 0000 0000 LABELONE........

If correct this should appear at the start of /dev/md0 (even w/o adding sdc).

LABELONE should appear on the first drive so this should not be wrong, 
however the sdd sdb could still have switched  order, and of course 
the chunk size could be different (although unlikely according to your log).

> I believe you are right, the issue is still the raid: I have tried 
> photorec and most files I have opened look like they have been 
> truncated.

Well, files could be fragmented, there's a certain sweet spot 
(like - megapixel JPEGs of few megs size) where it's sufficiently 
unlikely to be a problem.

I don't know what files you have, if it's movies it would be okay 
too if the first few megs of the file were playable.

> - apart from the raid superblock, the disks I use (sdd and sdb) have not 
> been erased  (as sdc is rebuilt from xor)

It only rebuilds starting from offset. So it should not have covered that 
offset if you did not specify it. Check it's not there before you --add. 
If it's there then this is after all not the drive you overwrite with dd?

I am confused now.

Regards
Andreas Klauer
