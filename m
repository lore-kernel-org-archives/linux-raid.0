From: Gavin Hamill <gdh@acentral.co.uk>
Subject: Re: Rebuild after a drive replacement
Date: Mon, 09 Jun 2008 09:12:44 +0100
Message-ID: <1212999164.15461.2.camel@gdh-work>
References: <1212958349.7596.14.camel@gdh-home>
	 <38060.192.168.1.70.1212963930.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <38060.192.168.1.70.1212963930.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 2008-06-09 at 08:25 +1000, NeilBrown wrote:

> > eddie:~# mdadm --add /dev/md3 /dev/hde5
> > mdadm: add new device failed for /dev/hde5 as 3: Invalid argument
> 
> Do you get any kernel messages when this fails?
>    dmesg | tail

Yes indeed...

md: hde5 has invalid sb, not importing!
md: md_import_device returned -22

I have tried zeroing the superblock on hde5, (and mdadm -E /dev/hde5
confirms that it's gone) and then adding the drive again, but it doesn't
change anything :(

> > As you can see, only hde thinks it's a spare, when I want it to replace
> > that 'removed' in all cases. What can I do?
> 
> Given that the --add failed, this is normal.  The device is added to
> the array as a spare, then recover starts.  Once recovery finished
> the device so changed to be a full member of the array.

Well, whatever's going on, it isn't being configured correctly as a
spare, so no rebuild begins:

md3 : active raid5 hda4[1] hdg4[2]
      349702144 blocks level 5, 1024k chunk, algorithm 0 [3/2] [_UU]

Again, any advice warmly received :) At least now each drive is from a
different vendor, so I'm spreading my bets against a double-failure...

Cheers,
Gavin.


