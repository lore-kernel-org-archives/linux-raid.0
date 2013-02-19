From: Phil Turmel <philip@turmel.org>
Subject: Re: Brocken Raid & LUKS
Date: Tue, 19 Feb 2013 12:57:51 -0500
Message-ID: <5123BD1F.4060200@turmel.org>
References: <5123A1CC.2000003@heisl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5123A1CC.2000003@heisl.org>
Sender: linux-raid-owner@vger.kernel.org
To: "stone@heisl.org" <stone@heisl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/19/2013 11:01 AM, stone@heisl.org wrote:
> hi guys.
> 
> yesterday my raid5 of 4 disk is broken and i dont find a better way as
> to re-create it new.
> mdadm --create /dev/md2 --assume-clean --verbose --level=5
> --raid-devices=4 /dev/sdc1 /dev/sdd1 missing /dev/sdf1
> 
> my problem is now that i cannot open die LUKS on the device md2
> cryptsetup luksOpen /dev/md2 md2_nas
> Device /dev/md2 is not a valid LUKS device.
> 
> i found with an hexdump on the disk sdc1 and sdf1 the LUKS header
> hexdump -C /dev/sdc1 | head -40
> .....
> 00100000  4c 55 4b 53 ba be 00 01  61 65 73 00 00 00 00 00
> |LUKS....aes.....|
> ....
> 
> so i think the header must be also on the md2 device but not on the
> beginning.
> is my raid constrct false? must i reconstruct my array new?
> 
> who can i bring my raid so up that i can open the LUKS and save all my
> data?

Please post your "mdadm -E" reports for your disks from *before* you did
"mdadm --create".  If you do not have these reports, some guessing may
be required.  (And why did you choose mdadm --create?  That's a terrible
step to take without good advice first.)

Also post "mdadm -E" reports for /dev/sdc1, sdd1, and sdf1 as they are
now, so we can compare.

If you still have dmesg from before and after the breakage, please post
it too.

The hexdump above is very valuable, and will certainly help make
educated guesses (if necessary).

Phil

