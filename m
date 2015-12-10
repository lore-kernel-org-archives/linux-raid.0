From: George Rapp <george.rapp@gmail.com>
Subject: Re: RAID 6 "Failed to restore critical section for reshape, sorry." -
 recovery advice?
Date: Thu, 10 Dec 2015 17:05:49 -0500
Message-ID: <CAF-KpgaLr-qA_RJiDYstFv-=EoHH-Ea3o1q3G3tXC4nX=Wt2XA@mail.gmail.com>
References: <CAF-Kpgb57-LoNy=-jy76ZcE=YPABmARzfsHNitJNZyw3v2AShw@mail.gmail.com>
 <alpine.DEB.2.02.1512100918520.20919@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1512100918520.20919@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Dec 10, 2015 at 3:22 AM, Mikael Abrahamsson <swmike@swm.pp.se> wrote:
> On Wed, 9 Dec 2015, George Rapp wrote:
>
>> # mdadm --assemble --verbose --invalid-backup --force
>> --update=revert-reshape /dev/md4 $OVERLAYS
>> mdadm: looking for devices for /dev/md4
>> [snipped remainder of output]
>
> Just a shot in the dark, what happens if you add a backup file to the above
> command, but without revert-reshape? Ie state both --invalid-backup but also
> supply a backup-file. The text above could indicate that this might help.

Mikael -

First, thanks for the reply.

I tried that and got a different error message:

# mdadm --assemble --verbose --invalid-backup --force
--backup-file=/home/gwr/2015/2015-08/grow_md6.bak /dev/md4 $OVERLAYS
mdadm: looking for devices for /dev/md4
mdadm: /dev/mapper/sdd4 is identified as a member of /dev/md4, slot 0.
mdadm: /dev/mapper/sdc4 is identified as a member of /dev/md4, slot 1.
mdadm: /dev/mapper/sdg4 is identified as a member of /dev/md4, slot 2.
mdadm: /dev/mapper/sdh1 is identified as a member of /dev/md4, slot 3.
mdadm: /dev/mapper/sdi1 is identified as a member of /dev/md4, slot 5.
mdadm: /dev/mapper/sdj1 is identified as a member of /dev/md4, slot 4.
mdadm: /dev/md4 has an active reshape - checking if critical section
needs to be restored
mdadm: No backup metadata on /home/gwr/2015/2015-08/grow_md6.bak
mdadm: Failed to find backup of critical section
mdadm: continuing without restoring backup
mdadm: added /dev/mapper/sdc4 to /dev/md4 as 1
mdadm: added /dev/mapper/sdg4 to /dev/md4 as 2
mdadm: added /dev/mapper/sdh1 to /dev/md4 as 3
mdadm: added /dev/mapper/sdj1 to /dev/md4 as 4
mdadm: added /dev/mapper/sdi1 to /dev/md4 as 5
mdadm: added /dev/mapper/sdd4 to /dev/md4 as 0
mdadm: failed to RUN_ARRAY /dev/md4: Invalid argument

> If you get the array up and running again but it's still reshaping but at
> position 0, issue a --continue to it (this has worked for others). Also, I
> would get the latest git version of mdadm and try with that one if you're
> still using v3.2.2 as per the link to your august original email.

Should have updated that. I'm up to mdadm v3.2.4 now, which is the
latest version offered by the Fedora 22 update repo (and Fedora 23
doesn't offer a newer one):

# mdadm --version
mdadm - v3.3.4 - 3rd August 2015

Thanks again.
-- 
George Rapp  (Pataskala, OH) Home: george.rapp -- at -- gmail.com
LinkedIn profile: https://www.linkedin.com/in/georgerapp
Phone: +1 740 936 RAPP (740 936 7277)
