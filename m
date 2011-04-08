From: Nagilum <nagilum@nagilum.org>
Subject: Re: 4-disk raid5 with 2 disks going bad: best way to proceed?
Date: Fri, 08 Apr 2011 17:47:30 +0200
Message-ID: <20110408174730.19073csbt29o450k@cakebox.homeunix.net>
References: <BC7F2D63-87DF-4402-A42B-00702098AAC4@gmail.com>
 <20110407221334.16604ufejmh3q9s0@cakebox.homeunix.net>
 <20110408220528.40971e55@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-2;
 DelSp="Yes";
 format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110408220528.40971e55@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: rob pfile <rpfile@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

----- Message from neilb@suse.de ---------
     From: NeilBrown <neilb@suse.de>
  Subject: Re: 4-disk raid5 with 2 disks going bad: best way to proceed?


> On Thu, 07 Apr 2011 22:13:34 +0200 Nagilum <nagilum@nagilum.org> wrote:
>
>> Hmm, I think you could:
>>   - add a disk,
>>   - reshape your raid5 to raid6 while using the layout where the raid5
>> disks aren't really changed
>
> That would be
>   mdadm --grow /dev/md0 --level=6 --parity=preserve
> (I think).
>
>>   - let it finish syncing
>>   - reshape the raid6 to raid5 taking one of the bad disks out
>
> I don't think that makes sense. (what command would you use exactly?)

I was thinking one fails one of the bad disks and then does something like:
mdadm --grow /dev/md0 --level=5 --raid-devices=4  
--backup-file=/root/backup-md4

But obviously I've never tried that and I would play around with  
losetup and some files for practice and to see if that works before  
starting.


----- End message from neilb@suse.de -----



========================================================================
#    _  __          _ __     http://www.nagilum.org/ \n icq://69646724 #
#   / |/ /__ ____ _(_) /_ ____ _  nagilum@nagilum.org \n +491776461165 #
#  /    / _ `/ _ `/ / / // /  ' \  Amiga (68k/PPC): AOS/NetBSD/Linux   #
# /_/|_/\_,_/\_, /_/_/\_,_/_/_/_/   Mac (PPC): MacOS-X / NetBSD /Linux #
#           /___/     x86: FreeBSD/Linux/Solaris/Win2k  ARM9: EPOC EV6 #
========================================================================


----------------------------------------------------------------
cakebox.homeunix.net - all the machine one needs..
