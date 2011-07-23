From: maurice <mhilarius@gmail.com>
Subject: Re: mdadm striped parity RAID with Advanced Format drives
Date: Sat, 23 Jul 2011 09:38:03 -0600
Message-ID: <4E2AEADB.6050105@gmail.com>
References: <201107211011.40151.polhallen@fuckaround.org> <4E27FECE.8010201@hardwarefreak.com> <alpine.DEB.2.00.1107211226540.20159@uplift.swm.pp.se> <4E280AEF.4020801@hardwarefreak.com> <4E2A40AC.8080107@gmail.com> <4E2A7409.60508@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E2A7409.60508@msgid.tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 7/23/2011 1:11 AM, Michael Tokarev wrote:
> ..
>> I have seen the case before where a drive has been "kicked out" and when
>> you go to add it back, it is refused as "too small"
>> Grown defects have shrunk the device.
> This CAN NOT HAPPEN.  Drive never changes its size.

If you say so.
   ;>}

I have seen this exact issue happen at least twice.The arrays were 
originally built.
After a failure they could not be rebuilt as one or more drives had 
become too small.
If you have an explanation for that, I am all ears..

At that point it is a lot of work to recover as one needs to go and find 
a drive that is bigger , to facilitate the recovery.


-- 
Cheers,
Maurice Hilarius
eMail: /mhilarius@gmail.com/
