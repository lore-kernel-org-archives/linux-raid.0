From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: What's the typical RAID10 setup?
Date: Mon, 31 Jan 2011 17:10:46 -0500
Message-ID: <4D473366.6090401@cfl.rr.com>
References: <AANLkTi=oCi1oMTMk_uhsiYA0CA80+8_k-AtvYXZ3jC+U@mail.gmail.com>	<AANLkTimc35i0W8vmsEGWrjCH7pYLBo=Ju1inA6xQ8bj6@mail.gmail.com>	<AANLkTimoSvWj3mnowZbVKKHEMzwjiQ=WqRUUsj91n_Zr@mail.gmail.com>	<20110131152151.GD7861@cthulhu.home.robinhill.me.uk>	<AANLkTimfnRxm=chKx4MFSxX1c0hypnVW-jaYwq757DaH@mail.gmail.com>	<AANLkTi=mLFwdLzcjcpzC0JJ=v8Aa817g+CzrR88pmy9y@mail.gmail.com>	<AANLkTikvXk0gyXz6MBvhyzxXatk0FVeASPr8R8+74c_i@mail.gmail.com>	<AANLkTinGSNmp6yUNfb9thnr3zKFTzw=fUFm+Gef3DAHw@mail.gmail.com>	<4D470F96.40409@cfl.rr.com>	<AANLkTim57HwYefXg=4CK06X+VXcW3o28VwRxCEnpaeEV@mail.gmail.com>	<4D4711A5.8070601@cfl.rr.com> <AANLkTinVdMA0izAvN0ZS14wMV=p3XUtbgBe+1LwxafD=@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTinVdMA0izAvN0ZS14wMV=p3XUtbgBe+1LwxafD=@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: Denis <denismpa@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 1/31/2011 2:53 PM, Roberto Spadim wrote:
> if you have a bigger and bigger and bigger disk configuration and only
> two mirrors you still with  50%

No, it goes down with more disks since you still can only tolerate a
single failure, so the more drives you have, the more likely it is that
two will fail.
