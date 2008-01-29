From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: In this partition scheme, grub does not find md information?
Date: Tue, 29 Jan 2008 17:37:28 +0100
Message-ID: <20080129163728.GB16250@rap.rap.dk>
References: <479EAF42.6010604@pobox.com> <18334.46306.611615.493031@notabene.brown> <479F07E1.7060408@pobox.com> <479F0AAB.3090702@rabbit.us> <479F331F.7080902@msgid.tls.msk.ru> <479F3C74.1050605@rabbit.us> <479F4CFC.5060305@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <479F4CFC.5060305@pobox.com>
Sender: linux-raid-owner@vger.kernel.org
To: Moshe Yudkowsky <moshe@pobox.com>
Cc: Peter Rabbitson <rabbit+list@rabbit.us>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jan 29, 2008 at 09:57:48AM -0600, Moshe Yudkowsky wrote:
> 
> In my 4 drive system, I'm clearly not getting 1+0's ability to use grub 
> out of the RAID10.  I expect it's because I used 1.2 superblocks (why 
> not use the latest, I said, foolishly...) and therefore the RAID10 -- 
> with even number of drives -- can't be read by grub. If you'd patch that 
> information into the man pages that'd be very useful indeed.

If you have 4 drives, I think the right thing is to use a raid1 with 4
drives, for your /boot partition. Then yo can survive that 3 disks
crash!


If you want the extra performance, then I think you should not bother
too much for the kernel and initrd load time - which of cause is not
striping on the disks, but some performance improvement can be expected.
Then you can have the rest of /root on a raid10,f2 with 4 disks.

best regards
keld
