From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm: superblock on /dev/sdr1 doesn't match others - assembly aborted
Date: Wed, 25 Jan 2006 12:23:28 +1100
Message-ID: <17366.54032.174297.848326@cse.unsw.edu.au>
References: <1138145033.43d6b70968906@mail.lr-netcon.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from mdadm@lr-netcon.de on Wednesday January 25
Sender: linux-raid-owner@vger.kernel.org
To: mdadm@lr-netcon.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday January 25, mdadm@lr-netcon.de wrote:
> Hi,
> 
> I am using a 8 disc scsi raid5 array on a fedora 3 system.
> 
> after a system crash, while the array was rebuilding a missing hd, 
> i am now unable to get this array running again.
> 
> thats all i get (/dev/sdr1 is not the one which was rebuild):
> # mdadm -R /dev/md4
> mdadm: failed to run array /dev/md4: Invalid argument   
> 
> # mdadm -A /dev/md4 -
> v /dev/sdk1 /dev/sdl1 /dev/sdm1 /dev/sdn1 /dev/sdo1 /dev/sdp1 /dev/sdq1 /dev/sdr
> 1
> looking for devices for /dev/md4
> /dev/sdk1 is identified as a member of /dev/md4, slot 0.
> /dev/sdl1 is identified as a member of /dev/md4, slot 1.
> /dev/sdm1 is identified as a member of /dev/md4, slot 2.
> /dev/sdn1 is identified as a member of /dev/md4, slot 8.
> /dev/sdo1 is identified as a member of /dev/md4, slot 4.
> /dev/sdp1 is identified as a member of /dev/md4, slot 5.
> /dev/sdq1 is identified as a member of /dev/md4, slot 6.
> mdadm: superblock on /dev/sdr1 doesn't match others - assembly aborted    
> 
> 
> # mdadm --examine /dev/sdk1
> /dev/sdk1:
>           Magic : a92b4efc
>         Version : 00.90.01
>            UUID : 232635af:1afe6aa5:e06f8828:99966325
snip
> 
> 
> 
> # mdadm --examine /dev/sdr1
> /dev/sdr1:
>           Magic : a92b4efc
>         Version : 00.90.01
>            UUID : 232605af:1afe6aa5:e06f8828:99966325

Putting those UUIDs right next to each other:
>            UUID : 232635af:1afe6aa5:e06f8828:99966325
>            UUID : 232605af:1afe6aa5:e06f8828:99966325
                        ^
                        |

We have 2 bits of difference.  This suggests a bad drive, bad RAM, bad
cabling or.... something.

You could be able to recreate the array:

 mdadm -C /dev/md4 -l5 -n8 -c4 -pls /dev/sdk1 /dev/sdl1 /dev/sdm1 \
         missing /dev/sdo1 /dev/sdp1 /dev/sdq1 /dev/sdr1

(double check all of that before you actually run it, I think I have
the order right...)
but be warned that you have some dodgey hardware somewhere, and data
corruption is a real possibility.... What caused the system crash?

NeilBrown
