From: Drew <drew.kay@gmail.com>
Subject: Re: What's the typical RAID10 setup?
Date: Wed, 2 Feb 2011 19:36:44 -0800
Message-ID: <AANLkTikehWC6-wzWE26p0n7Ng1YW6Sv_L1xU_K4LZdkv@mail.gmail.com>
References: <AANLkTikvXk0gyXz6MBvhyzxXatk0FVeASPr8R8+74c_i@mail.gmail.com>
 <AANLkTinGSNmp6yUNfb9thnr3zKFTzw=fUFm+Gef3DAHw@mail.gmail.com>
 <AANLkTim_uQ7AQs_ZSyeYPJPYSLCJd6ChzzTBwBNk2qA9@mail.gmail.com>
 <20110131192858.GD27952@www2.open-std.org> <4D4718E1.9040607@hardwarefreak.com>
 <20110131203725.GB2283@www2.open-std.org> <AANLkTimxCkxkg6xuz8FgFf0=u4KY=0M=6+afnxLzT+Tu@mail.gmail.com>
 <AANLkTi=+rPzaNTKAjB=QUEGsbUcwfN8uijm96DoY_4FA@mail.gmail.com>
 <AANLkTinM6FkJtxL8dNpoy-haGqNsZVfLDwmvZcshTEYQ@mail.gmail.com>
 <AANLkTi=kUGc8bjisn69BEEkZr6kcHUyfKnVZzNtgaJf3@mail.gmail.com>
 <20110131225235.GA11775@www2.open-std.org> <ii8lcv$3jg$1@dough.gmane.org>
 <AANLkTin1MPYZGMuL75c=_q+ndeiz0F5+eCRudpDdTwu9@mail.gmail.com>
 <ii96gl$vrl$1@dough.gmane.org> <AANLkTim3UgP0jtM6E_-3o-_OuNw6j1JG8OZzcvxt8A8s@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTim3UgP0jtM6E_-3o-_OuNw6j1JG8OZzcvxt8A8s@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> in this topic (many emails) there=C2=B4s a important thing. resolve t=
he
> probability problem and make it 'official', include numbers and
> context

The probability that's been talked about in this thread, is how
resilient RAID 0+1 is vs RAID 1+0. The "1 in 3" vs "2 in 3" chance
being refereed to is about "what is the probability a second drive
failure will completely take down my degraded array?"

In a RAID 0+1 you have the following: (a,b) & (c,d) where each pair is
a stripe and the two stripes are mirrored.

In RAID 1+0 you have the following: (a,b) & (c,d) where each pair is a
mirror and the two pairs are striped.

Let's assume 1 drive, say 'a' fails. We're in a degraded state and
should replace the drive. While we're syncing/replacing the new drive
a second disk fails. This second disk can be b, c , or d.

In RAID 0+1, which second disk(s) can fail and we can still recover
the data? Because of the failure of the RAID0 pair (a,b), the higher
level RAID 1 is also degraded. Failure of either c or d will cause the
mirror to lose it's second copy and we're down, hard. This means there
is a '2 in 3' (66%) chance that the failure of a second disk will
detroy the data in this array.

Contrast, RAID 1+0. With the failure of 'a', the lower level RAID 1
pair (a,b) is still intact but degraded. The higher level RAID 0 is
still intact. Which disks can we lose and still keep the upper level
RAID 0 intact? Failure of 'b' will cuase the whole RAID to go down
whereas the failure of either 'c', or 'd' will result in both lower
level RAID 1's being degraded, however the RAID 0 is still intact.
This gives us a "1 in 3" chance (33%) that a second disk failure will
take down the entire array.

You tell me. Given 1 in 3 odds of surviving a second disk failure or 2
in 3 odds, which would you choose? :-)


--=20
Drew

"Nothing in life is to be feared. It is only to be understood."
--Marie Curie
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
