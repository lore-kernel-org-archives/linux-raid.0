From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: What's the typical RAID10 setup?
Date: Mon, 31 Jan 2011 14:37:58 -0500
Message-ID: <4D470F96.40409@cfl.rr.com>
References: <AANLkTi=oCi1oMTMk_uhsiYA0CA80+8_k-AtvYXZ3jC+U@mail.gmail.com> <AANLkTimc35i0W8vmsEGWrjCH7pYLBo=Ju1inA6xQ8bj6@mail.gmail.com> <AANLkTimoSvWj3mnowZbVKKHEMzwjiQ=WqRUUsj91n_Zr@mail.gmail.com> <20110131152151.GD7861@cthulhu.home.robinhill.me.uk> <AANLkTimfnRxm=chKx4MFSxX1c0hypnVW-jaYwq757DaH@mail.gmail.com> <AANLkTi=mLFwdLzcjcpzC0JJ=v8Aa817g+CzrR88pmy9y@mail.gmail.com> <AANLkTikvXk0gyXz6MBvhyzxXatk0FVeASPr8R8+74c_i@mail.gmail.com> <AANLkTinGSNmp6yUNfb9thnr3zKFTzw=fUFm+Gef3DAHw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTinGSNmp6yUNfb9thnr3zKFTzw=fUFm+Gef3DAHw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Denis <denismpa@gmail.com>
Cc: Roberto Spadim <roberto@spadim.com.br>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 1/31/2011 1:35 PM, Denis wrote:
> Roberto, to quite understend how better a raid 10 is over raid 01  you
> need to take down into a mathematical level:

Raid 10 is not raid 1+0.  Raid 10 defaults to having 2 duplicate copies,
and so can withstand the failure of exactly one disk.  If two disks
fail, it does not matter which two they are, the array has failed.  You
can increase it to 3 copies so you can build an array of any size ( 4,
6, 8, whatever ) that can withstand exactly 2 failed disks, in any
combination.

