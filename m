From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Have the velociraptors in a test system now, checkout the errors.
Date: Thu, 18 Dec 2008 18:14:24 -0500
Message-ID: <494AD950.3030802@tmr.com>
References: <alpine.DEB.1.10.0812060426280.3494@p34.internal.lan>  <49405A94.8080601@tmr.com> <1229225303.16555.149.camel@localhost> <4949645F.4030407@tmr.com> <alpine.DEB.1.10.0812171820200.26527@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0812171820200.26527@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Redeeman <redeeman@metanurb.dk>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com, smartmontools-support@lists.sourceforge.net
List-Id: linux-raid.ids

Justin Piszcz wrote:
>>
>> Calls itself "WDC WD10EACS-00D" in /sys if that helps. I could dig 
>> out the packing slip if it matters. Runs nicely so far, and if the 
>> SMART temperature probe is correct, very cool:
>>
>> /dev/sda: ST3750640AS: 43 C
>> /dev/sdb: WDC WD10EACS-00D6B1: 31 C
>> /dev/sdc: ST3750640AS: 44 C
>> /dev/sdd: ST3750640AS: 46 C
>>
>> I don't totally trust the temps, there is a LOT of 18C air going into 
>> that box, because it has a lot coming out the back and side.
>
> Hmm do you have a picture of those seagates? Seems like a lack of 
> airflow there
> or do they just run really hot?  Also, how many head unload/loads has the
> 1.0TB GP drive performed, that was one of my concerns when I was 
> looking at
> disks.

How about a diagram:

__________________________________________________
                                                  |
                                                  |
                                                  |
                                                  |
                                                  |
                                                  |
                                                  |
                                                  |
                                                  |
                                                  |
                                                  |
                                 --empty--        |
                                 (seagate)        |
                                 (WD)             |
                                 (seagate)        | <--- case
                                 (seagate)        |
                                 --empty--        |
__________________________________________________|


That's about how the drives sit in the case, air vents are in the front 
of the case, fans in back pulling air out.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


