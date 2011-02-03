From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: What's the typical RAID10 setup?
Date: Thu, 03 Feb 2011 02:18:24 -0600
Message-ID: <4D4A64D0.5060900@hardwarefreak.com>
References: <AANLkTikvXk0gyXz6MBvhyzxXatk0FVeASPr8R8+74c_i@mail.gmail.com> <AANLkTinGSNmp6yUNfb9thnr3zKFTzw=fUFm+Gef3DAHw@mail.gmail.com> <AANLkTim_uQ7AQs_ZSyeYPJPYSLCJd6ChzzTBwBNk2qA9@mail.gmail.com> <20110131192858.GD27952@www2.open-std.org> <4D4718E1.9040607@hardwarefreak.com> <20110131203725.GB2283@www2.open-std.org> <AANLkTimxCkxkg6xuz8FgFf0=u4KY=0M=6+afnxLzT+Tu@mail.gmail.com> <AANLkTi=+rPzaNTKAjB=QUEGsbUcwfN8uijm96DoY_4FA@mail.gmail.com> <AANLkTinM6FkJtxL8dNpoy-haGqNsZVfLDwmvZcshTEYQ@mail.gmail.com> <AANLkTi=kUGc8bjisn69BEEkZr6kcHUyfKnVZzNtgaJf3@mail.gmail.com> <20110131225235.GA11775@www2.open-std.org> <ii8lcv$3jg$1@dough.gmane.org> <AANLkTin1MPYZGMuL75c=_q+ndeiz0F5+eCRudpDdTwu9@mail.gmail.com> <ii96gl$vrl$1@dough.gmane.org> <AANLkTim3UgP0jtM6E_-3o-_OuNw6j1JG8OZzcvxt8A8s@mail.gmail
 .com> <AANLkTikehWC6-wzWE26p0n7Ng1YW6Sv_L1xU_K4LZdkv@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTikehWC6-wzWE26p0n7Ng1YW6Sv_L1xU_K4LZdkv@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Drew <drew.kay@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Drew put forth on 2/2/2011 9:36 PM:

> You tell me. Given 1 in 3 odds of surviving a second disk failure or 2
> in 3 odds, which would you choose? :-)

This is also why few, if any, hardware RAID vendors offer RAID 0+1.  Most (all?)
offer only RAID 10.  However, due to the RAID level migrations offered by some
hardware RAID controllers, a customer can actually end up with a RAID 0+1 array
if they go through a specific migration/expansion path.  Obviously you'd want to
avoid those paths.

-- 
Stan
