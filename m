From: Miles Fidelman <mfidelman@meetinghouse.net>
Subject: Re: raid over ethernet
Date: Sat, 29 Jan 2011 18:06:06 -0500
Message-ID: <4D449D5E.5010606@meetinghouse.net>
References: <AANLkTi=2PDZdVSEgF0mQ_ZdwxvkPoSywM6U0e4hMxTXS@mail.gmail.com> <alpine.DEB.1.10.1101290741510.13151@uplift.swm.pp.se> <AANLkTikFHBD_TjTe96tgd4Kmy6zZuD8kdE0W-0ncdCev@mail.gmail.com> <20110129133457.GB15784@mordor.angband.thangorodrim.de> <AANLkTi=6ridRPnHpfdOC=f2_ESndSARmQRkvT_shYO3s@mail.gmail.com> <20110129210815.GC15784@mordor.angband.thangorodrim.de> <4D448CAF.6020409@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D448CAF.6020409@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

John Robinson wrote:
> Now that is interesting, to me at least. More as a thought experiment 
> for now, I was wondering how one would go about setting up a small 
> cluster of commodity servers (maybe 8 machines) running Xen (or 
> perhaps now KVM) VMs, such that if one (or potentially two) of the 
> machines died, the VMs could be picked up by the other machines in the 
> cluster, and only using locally-attached SATA/SAS discs in each machine.
I do that now - albeit only on a 2-node cluster.  DRBD works just fine 
using locally attached drives.

-- 
In theory, there is no difference between theory and practice.
In<fnord>  practice, there is.   .... Yogi Berra


