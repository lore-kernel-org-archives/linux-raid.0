From: Maarten v d Berg <maarten@vbvb.nl>
Subject: Re: Recovering RAID5 array
Date: Tue, 20 Jan 2004 13:57:32 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200401201357.32747.maarten@vbvb.nl>
References: <400CD0BF.2010808@upfrontsystems.co.za> <200401201310.48900.maarten@vbvb.nl> <400D1DA6.80509@upfrontsystems.co.za>
Reply-To: maarten@nebula.vbvb.nl
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <400D1DA6.80509@upfrontsystems.co.za>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday 20 January 2004 13:23, Jean Jordaan wrote:
> Hi Maarten
>
> > So, maybe mount is right and /mnt/gentoo/raid/ IS actually wrong...?
>
> I.e. the filesystem under RAID is corrupt? This is what I'm afraid of.

Not neccessarily... just that /mnt/gentoo/raid/ is NOT a directory.

First things first.  Why don't you try to mount /dev/md0 on /mnt ?

> > So maybe more prudent would be a reiserfsck --check...
>
> Oooh! Looks like something worked .. still can't mount though ..
> should I try --rebuild-tree next? :

That choice is entirely up to you.  Please be well aware that such choices may 
determine the fate of your data on /dev/md0...!!  So better think twice.
Looking at the errors you may want to experiment with the order in which you 
assembled the md device. Then you can compare the severity of the errors that 
reiserfsck reports. Once you choose rebuild-tree there is NO way back.

But don't ask me, I'm no real expert on these questions. In fact, several 
months ago people on this list helped me solve MY raid5 two-disk failure... 

good luck
Maarten

> cdimage root # reiserfsck --check /dev/md0
>
> <-------------reiserfsck, 2003------------->
> reiserfsprogs 3.6.8
>
> [...]
> Will read-only check consistency of the filesystem on /dev/md0
> Will put log info to 'stdout'
>
> Do you want to run this program?[N/Yes] (note need to type Yes if you
> do):Yes ###########
> reiserfsck --check started at Tue Jan 20 12:19:38 2004
> ###########
> Replaying journal..
> 0 transactions replayed
> Checking internal tree../  1 (of   2)/  1 (of 126)/  1 (of 153)block 8211:
> The level of the node (25938) is not correct, (1) expected
>   the problem in the internal node occured (8211), whole subtree is skipped
> finished
> Comparing bitmaps..vpf-10640: The on-disk and the correct bitmaps differs.
> Bad nodes were found, Semantic pass skipped
> 1 found corruptions can be fixed only during --rebuild-tree
> ###########
> reiserfsck finished at Tue Jan 20 12:20:11 2004
> ###########
> cdimage root # mount -r -t reiserfs /dev/md0 /mnt/gentoo/raid/
> mount: Not a directory
>
> (Apologies for direct mail but speed is of the essence .. )

