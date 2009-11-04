From: Simon Jackson <sjackson@bluearc.com>
Subject: RE: Migrating RAID 1 volumes to Dual ported disks.
Date: Wed, 4 Nov 2009 15:24:43 +0000
Message-ID: <ABFC24E4C13D81489F7F624E14891C865AA4C9A2@uk-ex-mbx1.terastack.bluearc.com>
References: <ABFC24E4C13D81489F7F624E14891C865AA4C65E@uk-ex-mbx1.terastack.bluearc.com>
 <87r5sf4d6o.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87r5sf4d6o.fsf@frosties.localdomain>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "goswin-v-b@web.de" <goswin-v-b@web.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Sorry, I am probably being thick here, but do you mean something like:

mdadm --create /dev/md10 --level=multipath --raid-devices=2 /dev/sdc /dev/sdd

When I tried this I got:

# mdadm --create /dev/md10 --level=multipath --raid-devices=2 /dev/sdc /dev/sdd
mdadm: /dev/sdc is too small: 0K
mdadm: create aborted
#



-----Original Message-----
From: goswin-v-b@web.de [mailto:goswin-v-b@web.de] 
Sent: 03 November 2009 19:32
To: Simon Jackson
Cc: linux-raid@vger.kernel.org
Subject: Re: Migrating RAID 1 volumes to Dual ported disks.

Simon Jackson <sjackson@bluearc.com> writes:

> Hi.
>
> I am currently using SATA drives in a RAID 1 configuration.  I am looking to use SAS drives instead of SATA.  As my first experiment I have plugged my SAS drive into a system and I have noticed that Linux sees the individual ports on the device as separate devices, so I have /dev/sdc and /dev/sdd which are both the same physical device.
>
> So if I have a system with 2 SAS drives I am going to have 4 devices representing the two physical drives.  So my question is how do I create RAID 1 sets for partitions on these types of drive?  
>
> My existing system carves 3 RAID 1 volumes from a pair of drives.  How do I translate this to the dual port SAS devices? 
>
> Thanks Simon.

You would set up multipath to combine the two paths to the same disk
as a single device and then run raid over that.

MfG
        Goswin
