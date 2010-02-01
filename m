From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: feature suggestion to handle read errors during re-sync of  raid5
Date: Tue, 02 Feb 2010 09:30:07 +1300
Message-ID: <4B6739CF.8050808@sauce.co.nz>
References: <alpine.DEB.1.10.1001301331560.15329@uplift.swm.pp.se> <4B6471A1.2070407@texsoft.it> <4B6482BD.6090102@anonymous.org.uk> <alpine.DEB.1.10.1001302228540.15329@uplift.swm.pp.se> <4B65AD05.5050000@anonymous.org.uk> <alpine.DEB.1.10.1001311854530.15329@uplift.swm.pp.se> <4B662ED1.3060003@gmail.com> <alpine.DEB.1.10.1002010814080.31777@uplift.swm.pp.se> <E15146CE216E4737A20C4EC59D414720@m5> <alpine.DEB.1.10.1002011440550.31777@uplift.swm.pp.se> <87r5p556na.fsf@frosties.localdomain> <alpine.DEB.1.10.1002011726570.31777@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.1002011726570.31777@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Mikael Abrahamsson wrote:

> Since the drive has ECC, it would be interesting to see the amount of
> read errors ECC has corrected. Would also be interesting to know if the
> drive will rewrite a sector if it's ECC corrected, so that ECC doesn't
> have to kick in next time (or if they're actually operating in so narrow
> margins that they actually use the ECC constantly because the s/n ratio
> is bad and that this is part of the design).

I guess this is manufacturer and model specific, but looking smartd 
output from a representative (as in similar errors etc to others of the 
same model) Seagate SCSI drive, they are not rewriting on ECC:

Error counter log:
            Errors Corrected by           Total   Correction 
Gigabytes    Total
                EEC          rereads/    errors   algorithm 
processed    uncorrected
            fast | delayed   rewrites  corrected  invocations   [10^9 
bytes]  errors
read:    2205106        0         0   2205106    2205106      18342.407 
           0
write:         0        0         0         0          0       3831.185 
           0


Regards,

Richard
