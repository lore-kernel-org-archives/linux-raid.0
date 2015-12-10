From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: RAID 6 "Failed to restore critical section for reshape, sorry."
 - recovery advice?
Date: Thu, 10 Dec 2015 09:22:11 +0100 (CET)
Message-ID: <alpine.DEB.2.02.1512100918520.20919@uplift.swm.pp.se>
References: <CAF-Kpgb57-LoNy=-jy76ZcE=YPABmARzfsHNitJNZyw3v2AShw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAF-Kpgb57-LoNy=-jy76ZcE=YPABmARzfsHNitJNZyw3v2AShw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: George Rapp <george.rapp@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 9 Dec 2015, George Rapp wrote:

> # mdadm --assemble --verbose --invalid-backup --force
> --update=revert-reshape /dev/md4 $OVERLAYS
> mdadm: looking for devices for /dev/md4
> mdadm: /dev/mapper/sdg4 is identified as a member of /dev/md4, slot 2.
> mdadm: /dev/mapper/sdi1 is identified as a member of /dev/md4, slot 5.
> mdadm: /dev/mapper/sdc4 is identified as a member of /dev/md4, slot 1.
> mdadm: /dev/mapper/sdh1 is identified as a member of /dev/md4, slot 3.
> mdadm: /dev/mapper/sdj1 is identified as a member of /dev/md4, slot 4.
> mdadm: /dev/mapper/sdd4 is identified as a member of /dev/md4, slot 0.
> mdadm: /dev/md4 has an active reshape - checking if critical section
> needs to be restored
> mdadm: Failed to find backup of critical section
> mdadm: continuing without restoring backup
> mdadm: added /dev/mapper/sdc4 to /dev/md4 as 1
> mdadm: added /dev/mapper/sdg4 to /dev/md4 as 2
> mdadm: added /dev/mapper/sdh1 to /dev/md4 as 3
> mdadm: added /dev/mapper/sdj1 to /dev/md4 as 4
> mdadm: added /dev/mapper/sdi1 to /dev/md4 as 5
> mdadm: added /dev/mapper/sdd4 to /dev/md4 as 0
> mdadm: /dev/md4: Need a backup file to complete reshape of this array.
> mdadm: Please provided one with "--backup-file=..."
> mdadm: (Don't specify --update=revert-reshape again, that part succeeded.)
>
> How can the array have an active reshape if the reshape pos'n is 0 on
> all devices? Doesn't that mean that the reshape never actually
> started? If so, can I just revert -- somehow -- to a 5-device RAID 6
> array to recover my data?

Just a shot in the dark, what happens if you add a backup file to the 
above command, but without revert-reshape? Ie state both --invalid-backup 
but also supply a backup-file. The text above could indicate that this 
might help.

If you get the array up and running again but it's still reshaping but at 
position 0, issue a --continue to it (this has worked for others). Also, I 
would get the latest git version of mdadm and try with that one if you're 
still using v3.2.2 as per the link to your august original email.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
