From: David Brown <david@westcontrol.com>
Subject: Re: What's the typical RAID10 setup?
Date: Tue, 01 Feb 2011 11:05:29 +0100
Message-ID: <ii8lkb$3jg$2@dough.gmane.org>
References: <AANLkTi=oCi1oMTMk_uhsiYA0CA80+8_k-AtvYXZ3jC+U@mail.gmail.com>	<AANLkTimc35i0W8vmsEGWrjCH7pYLBo=Ju1inA6xQ8bj6@mail.gmail.com>	<AANLkTimoSvWj3mnowZbVKKHEMzwjiQ=WqRUUsj91n_Zr@mail.gmail.com>	<20110131152151.GD7861@cthulhu.home.robinhill.me.uk>	<AANLkTimfnRxm=chKx4MFSxX1c0hypnVW-jaYwq757DaH@mail.gmail.com>	<AANLkTi=mLFwdLzcjcpzC0JJ=v8Aa817g+CzrR88pmy9y@mail.gmail.com>	<AANLkTikvXk0gyXz6MBvhyzxXatk0FVeASPr8R8+74c_i@mail.gmail.com>	<AANLkTinGSNmp6yUNfb9thnr3zKFTzw=fUFm+Gef3DAHw@mail.gmail.com>	<4D470F96.40409@cfl.rr.com>	<4D471A41.1090706@hardwarefreak.com>	<4D4730C0.8080900@cfl.rr.com> <AANLkTimYzZLjtgrppZKw1H3d+RUV7doEQ-G+P8V7OTTV@mail.gmail.com> <4D473A02.3070809@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D473A02.3070809@cfl.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 31/01/2011 23:38, Phillip Susi wrote:
> On 1/31/2011 5:08 PM, Jon Nelson wrote:
>> I operate (and have done so for a long time) a raid10,f2 on two drives.
>> What makes you think it wants at least 3?
>
> Neat, I thought I tried that the other day and it complained that raid 5
> and 6 ( sic ) need at least 3 drives.  Seemed like it was just a bug or
> oversight.

raid5 needs at least 3 disks to make sense (raid5 with 2 disks is the 
same as raid1), while raid6 needs at least 4 disks.  But mdadm raid10 
needs only two disks.


