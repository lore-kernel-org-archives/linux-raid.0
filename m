From: Victor Geller <vgeller@spindrift.on.ca>
Subject: Re: ADD_NEW_DISK failed
Date: Sun, 23 Feb 2003 17:19:30 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <5.1.0.14.0.20030223170503.00b36180@psimail.spindrift.on.ca>
References: <message from Norman Schmidt on Sunday February 23>
 <5.1.0.14.0.20030223085025.00b08b30@psimail.spindrift.on.ca>
 <3E58EBA1.7010305@ratnet.stw.uni-erlangen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <15961.12440.64252.132242@notabene.cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>, schmidt@naa.net
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Norman, Neil and Adam,

Thank you for your help.

I am a bit confused on the sequence of steps I have to do.
I can
1. umount /dev/hdc*
2. mdadm -Cv /dev/md0 -n2 -l1 /dev/hdc1 "missing"
3. mdadm -Cv /dev/md1 -n2 -l1 /dev/hdc6 "missing"

What would be the next steps?


At 07:35 AM 2/24/2003 +1100, Neil Brown wrote:
>On Sunday February 23, norman.schmidt@ratnet.stw.uni-erlangen.de wrote:
> >
> > By the way: This failed-disk approach is not so well documented for
> > mdadm, or did I overlook something? Any documentation anywhere?
> >
>
>Fourth paragraph of the "CREATE MODE" section:
>
>        To create a "degraded" array in which some devices are 
> missing,  simply
>        give the word missing in place of a device name.  This will cause 
> mdadm
>        to leave the corresponding slot in the array 
> empty.   For  a  RAID4  or
>        RAID5  array  at most one slot can be missing.  For a RAID1 array, 
> only
>        one real device needs to be given.  All of the others can be missing.
>
>
>If that is not clear, please help me re-phrase it.
>
>
>NeilBrown

