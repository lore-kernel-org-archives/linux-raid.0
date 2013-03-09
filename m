From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: Raid 5/10 discard support broken in 3.8.2
Date: Sat, 09 Mar 2013 13:26:26 +0800
Message-ID: <513AC802.8070306@fnarfbargle.com>
References: <CAKHEz2a+gwCzj16s3P3UOFMezC=CFe3D2002yyNsA_E5+-Ci6Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAKHEz2a+gwCzj16s3P3UOFMezC=CFe3D2002yyNsA_E5+-Ci6Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dave Cundiff <syshackmin@gmail.com>
Cc: Linux MDADM Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 06/03/13 12:20, Dave Cundiff wrote:
> Hi all,
>
> It appears the Raid 5/10 discard support does not work in the mainline kernel.
>
> I've been trying to backport it to a RHEL 6 kernel without success. I
> finally managed to setup a mainline dev box and discovered it doesn't
> work on it either!
>
> I'm now testing on a stock 3.8.2 kernel. The drives I'm using are
> Samsung 840 Pro's hanging off an LSI 9211-8i. No backplane and each
> drive has a dedicated channel. No RAID on the LSI, its just an HBA.
>

I'd be interested if you could test it against 3.7.9.

I have a 6 drive RAID10. 3 Drives are on the on-board AHCI, and the 
other three are on an LSI 9240-8i (SAS2008 with mpt2sas module).

TRIM is being passed down the stack as after an fstrim of the ext4 fs on 
the RAID the mismatch count goes through the roof.

The 3 drives on the LSI are Intel 330 (which support deterministic read 
after trim) while the drives on the AHCI are Samsung 830 (which are 
*not* deterministic after trim).

My raid is 6 drives in an n2 configuration, so three pairs of mirrors. 
Each one a Samsung and an Intel.

I used dd to pull off the first 2G of the first pair and ran vbindiff 
over them.

The differences are easily spotted where the Samsungs are returning data 
and the Intels are returning zero. So the trim is most certainly making 
its way down through the RAID10 and to the Intel 330 drives on the LSI 
controller on kernel 3.7.9.

It's a production machine, so I can't really pull it down to upgrade it 
to 3.8.2.

Hope this helps.

Regards,
Brad
