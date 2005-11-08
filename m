From: Neil Brown <neilb@suse.de>
Subject: Re: RAID 5 array keeps dropping drive on boot
Date: Tue, 8 Nov 2005 12:55:44 +1100
Message-ID: <17264.1440.176313.287686@cse.unsw.edu.au>
References: <2A807893-B5A6-4EF1-B862-1D6F22D71B60@fnuck.dk>
	<17263.57266.902113.362087@cse.unsw.edu.au>
	<5DD8751D-7FE2-4179-9887-853A704DE0D6@fnuck.dk>
	<17263.59743.163989.959271@cse.unsw.edu.au>
	<D8682F09-5A4D-4356-8FA6-825880F93AE4@fnuck.dk>
	<17263.61561.506974.198576@cse.unsw.edu.au>
	<4E521E9D-FDA7-4F7B-9E30-6DE568050214@fnuck.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Troels Bang Jensen on Tuesday November 8
Sender: linux-raid-owner@vger.kernel.org
To: Troels Bang Jensen <marvin@fnuck.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday November 8, marvin@fnuck.dk wrote:
> 
> On Nov 8, 2005, at 01:25 , Neil Brown wrote:
> 
> > On Tuesday November 8, marvin@fnuck.dk wrote:
> >
> >>
> >> All in all I have made 4 or 5 syncs now, each taking about 9 hours.
> >> And I've made sure to shut down the computer cleanly afterwards.
> >>
> >>
> >
> > Ok.  Can you give me a complete boot log, rather than the edited
> > version.  There might be something important in there.
> >
> >
> 
> Okay. This log starts with a sync, after which I reboot to see if the  
> disk will stay in the RAID.
> 
> Note that hdc at this point is placed on a PCI IDE controller, so  
> it's called hde, i.e. we have hda3, hde3 and hdg2 as disks in md1.  
> compare with md0, which is hda1 and hde1 and gets detected properly.
> 

Thanks.
You are booting with a ramdisk which loads various modules including
raid, and then attempts to assemble the raid arrays.
It is not using auto-detect to assemble the arrays (so the partition
type is irrelevant).
It is not using 'raidstart' to assemble the arrays (which is good, and
raid start is broken).
So it must be using mdadm (or mdassemble).

Can you find that ramdisk (probably in /boot/initrd* somewhere), mount
it, (-t cramfs -o loop) and look inside it.
Look particularly for /etc/mdadm.conf. but look around for anything
else that might be related to md or raid.

... actually, you said which distribution you were using (Debian) so I
should be able to figure it out from that...  Hm.. mkinitrd in pretty
broken in debian wrt mdadm :-(
You should find some script called 'md-1script' or something like that 
which has something like

   mdadm -A /dev/md1 -R -u  4b22b17d:06048bd3:ecec156c:31fabbaf /dev/hda3 /dev..

This is probably broken.

Maybe if you just run mkinitrd again while the array is fully working,
it might boot properly next time.
Someone needs to fix Debian's mkinitrd script.... 

NeilBrown
