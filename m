From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: mdadm striped parity RAID with Advanced Format drives
Date: Mon, 25 Jul 2011 22:57:18 +0400
Message-ID: <4E2DBC8E.1070706@msgid.tls.msk.ru>
References: <201107211011.40151.polhallen@fuckaround.org> <4E27FECE.8010201@hardwarefreak.com> <alpine.DEB.2.00.1107211226540.20159@uplift.swm.pp.se> <4E280AEF.4020801@hardwarefreak.com> <4E2A40AC.8080107@gmail.com> <4E2A7409.60508@msgid.tls.msk.ru> <4E2AEADB.6050105@gmail.com> <alpine.DEB.2.00.1107231757050.20159@uplift.swm.pp.se> <4E2B0CE3.3050702@gmail.com> <4E2D2C23.9010108@oldum.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E2D2C23.9010108@oldum.net>
Sender: linux-raid-owner@vger.kernel.org
To: Nikolay Kichukov <hijacker@oldum.net>
Cc: maurice <mhilarius@gmail.com>, Mikael Abrahamsson <swmike@swm.pp.se>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

25.07.2011 12:41, Nikolay Kichukov wrote:
> I can confirm this has happened to me once. The drive went just a bit smaller than it was originally. Unfortunately I
> have no evidence of this at this stage. It was real strange. Whatever I tried did not bring the same size back. It kept
> being reported as a few sectors less.

It's possible to get smaller size at one point, by enabling HPA area
in a drive.  I think all modern (desktop) drives support this feature.

/mjt

> Cheers,
> -Nik
> 
> On 07/23/2011 09:03 PM, maurice wrote:
>> On 7/23/2011 9:58 AM, Mikael Abrahamsson wrote:
>>> ..
>>> I'd like to see text that indicates this. I agree with the original poster that this just doesn't happen.
>>>
>> I no longer have the details at hand, as I have fixed it, and it was about 8 months ago last time I saw it.
> 
