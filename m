From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: What's the typical RAID10 setup?
Date: Mon, 31 Jan 2011 16:59:28 -0500
Message-ID: <4D4730C0.8080900@cfl.rr.com>
References: <AANLkTi=oCi1oMTMk_uhsiYA0CA80+8_k-AtvYXZ3jC+U@mail.gmail.com> <AANLkTimc35i0W8vmsEGWrjCH7pYLBo=Ju1inA6xQ8bj6@mail.gmail.com> <AANLkTimoSvWj3mnowZbVKKHEMzwjiQ=WqRUUsj91n_Zr@mail.gmail.com> <20110131152151.GD7861@cthulhu.home.robinhill.me.uk> <AANLkTimfnRxm=chKx4MFSxX1c0hypnVW-jaYwq757DaH@mail.gmail.com> <AANLkTi=mLFwdLzcjcpzC0JJ=v8Aa817g+CzrR88pmy9y@mail.gmail.com> <AANLkTikvXk0gyXz6MBvhyzxXatk0FVeASPr8R8+74c_i@mail.gmail.com> <AANLkTinGSNmp6yUNfb9thnr3zKFTzw=fUFm+Gef3DAHw@mail.gmail.com> <4D470F96.40409@cfl.rr.com> <4D471A41.1090706@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D471A41.1090706@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Denis <denismpa@gmail.com>, Roberto Spadim <roberto@spadim.com.br>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 1/31/2011 3:23 PM, Stan Hoeppner wrote:
>> Raid 10 is not raid 1+0.  Raid 10 defaults to having 2 duplicate copies,
> 
> Yes, actually, they are two names for the same RAID level.

No, they are not.  See the mdadm man page.  Raid10 can operate on 3
drives, raid1+0 can not.  In theory a raid10 could be done on two disks
though mdadm seems to want at least 3.

> This is absolutely not correct.  In a 10 disk RAID 10 array, exactly 5 disks can
> fail, as long as no two are in the same mirror pair, and the array will continue
> to function, with little or no performance degradation.

That is a raid 0+1, not raid10.

> Where are you getting your information?  Pretty much everything you stated is
> wrong...

The mdadm man page.

