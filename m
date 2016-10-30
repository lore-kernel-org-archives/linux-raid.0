From: Marc MERLIN <marc@merlins.org>
Subject: Re: Buffer I/O error on dev md5, logical block 7073536, async page read
Date: Sun, 30 Oct 2016 08:38:57 -0700
Message-ID: <20161030153857.GB28648@merlins.org>
References: <20161030021614.asws67j34ji64qle@merlins.org> <20161030093337.GA3627@metamorpher.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161030093337.GA3627@metamorpher.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Oct 30, 2016 at 10:33:37AM +0100, Andreas Klauer wrote:
> On Sat, Oct 29, 2016 at 07:16:14PM -0700, Marc MERLIN wrote:
> > Can someone tell me how this is possible?
> > More generally, is it possible for the kernel to return an md error 
> > and then not log any underlying hardware error on the drives the md 
> > was being read from?
> 
> Is there something in mdadm --examine(-badblocks) /dev/sd*?

Well, well, I learned something new today. First I had to upgrade my mdadm
tools to get that option, and sure enough:
myth:~# mdadm --examine-badblocks /dev/sd[defgh]1
Bad-blocks on /dev/sdd1:
            14408704 for 352 sectors
            14409568 for 160 sectors
           132523032 for 512 sectors
           372496968 for 440 sectors
Bad-blocks list is empty in /dev/sde1
Bad-blocks on /dev/sdf1:
            14408704 for 352 sectors
            14409568 for 160 sectors
           132523032 for 512 sectors
           372496968 for 440 sectors
Bad-blocks list is empty in /dev/sdg1
Bad-blocks list is empty in /dev/sdh1

So thank you for pointing me in the right direction.

I think they are due to the fact that it's an external disk array on a port
multiplier where sometimes I get bus errors that aren't actually on the
disks.

Questions:
1) shouldn't my array have been invalidated if I have bad blocks on 2 drives
in the same place or is the only possible way for this to happen that it did
get invalidated and I somehow force rebuilt the array to bring it back up
and I don't remember doing so?
(mmmh, but even so, rebuilding the spare should have cleared the bad blocks
on at least one drive, no?)

2) I'm currently running this, which I believe is the way to recover:
myth:~# echo 'check' > /sys/block/md5/md/sync_action 
but I'm not too hopeful on how that's going to work out if I have 2 drives with
supposed bad blocks at the same offsets.

Is there another way to just clear the bad block list on both drives if I've
already verified that those blocks are not bad and that they were due to some 
I/O errors that came from a bad cable connection?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
