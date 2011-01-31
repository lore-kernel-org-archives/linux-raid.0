From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: What's the typical RAID10 setup?
Date: Mon, 31 Jan 2011 14:23:29 -0600
Message-ID: <4D471A41.1090706@hardwarefreak.com>
References: <AANLkTi=oCi1oMTMk_uhsiYA0CA80+8_k-AtvYXZ3jC+U@mail.gmail.com> <AANLkTimc35i0W8vmsEGWrjCH7pYLBo=Ju1inA6xQ8bj6@mail.gmail.com> <AANLkTimoSvWj3mnowZbVKKHEMzwjiQ=WqRUUsj91n_Zr@mail.gmail.com> <20110131152151.GD7861@cthulhu.home.robinhill.me.uk> <AANLkTimfnRxm=chKx4MFSxX1c0hypnVW-jaYwq757DaH@mail.gmail.com> <AANLkTi=mLFwdLzcjcpzC0JJ=v8Aa817g+CzrR88pmy9y@mail.gmail.com> <AANLkTikvXk0gyXz6MBvhyzxXatk0FVeASPr8R8+74c_i@mail.gmail.com> <AANLkTinGSNmp6yUNfb9thnr3zKFTzw=fUFm+Gef3DAHw@mail.gmail.com> <4D470F96.40409@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D470F96.40409@cfl.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Phillip Susi <psusi@cfl.rr.com>
Cc: Denis <denismpa@gmail.com>, Roberto Spadim <roberto@spadim.com.br>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Phillip Susi put forth on 1/31/2011 1:37 PM:

> Raid 10 is not raid 1+0.  Raid 10 defaults to having 2 duplicate copies,

Yes, actually, they are two names for the same RAID level.

> and so can withstand the failure of exactly one disk.  If two disks
> fail, it does not matter which two they are, the array has failed.  You

This is absolutely not correct.  In a 10 disk RAID 10 array, exactly 5 disks can
fail, as long as no two are in the same mirror pair, and the array will continue
to function, with little or no performance degradation.

Where are you getting your information?  Pretty much everything you stated is
wrong...

-- 
Stan
