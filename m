From: Herman Oosthuysen <Herman@WirelessNetworksInc.com>
Subject: Re: RAID backup
Date: Fri, 04 Oct 2002 09:31:26 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3D9DB44E.4090609@WirelessNetworksInc.com>
References: <Pine.LNX.3.96.1021004041421.5688A-100000@Maggie.Linux-Consulting.com> <1033735943.31839.12.camel@irongate.swansea.linux.org.uk> <20021004132419.GF710@gallifrey> <3D9DA67A.8050608@comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Howdy,

The MTTF number is calculated during a process intended to identify 
weaknesses in the design of electronic equipment.  Depending on how you 
model the failure modes and who's failure tables you use, the MTTF 
number will vary enormously.

The important thing is not the number per se, but rather the quality 
review process associated with the calculation effort.

Unfortunately, the MTTF number became a marketing fad, with the result 
that some companies will calculate it, without doing any quality 
reviews, purely for marketing purposes.  There is no way to tell what 
they did.  The MTTF number is consequently totally meaningless by itself.

However, judging by my own experience, Maxtor drives are quite reliable 
and should last 3 years or more when in use and just about indefinitely 
when in storage.

Self demagnetization used to be a problem of magnetic media and some 
components such as capacitors used to deteriorate with age, but I think 
that those problems have been solved decades ago, so equipment in clean 
and dry storage should last almost forever.

The important thing to remember with disks and tapes is that they will 
eventually fail.  When that will happen is anybody's guess, but you have 
to plan for the eventuality; you can't just sit on your hands and hope 
for the best and the backup measures that you implement, should be 
commensurate with the value of the data.

Cheers,

Herman
http://www.AerospaceSoftware.com

Luca Berra wrote:
> Dr. David Alan Gilbert wrote:
> 
>> * Alan Cox (alan@lxorguk.ukuu.org.uk) wrote:
>>
>>> The problem with disks is you still have to archive them somewhere, and
>>> they are bulky. I also dont know what studies are available on the
>>> degradation of stored disk media over time. 
>>
>>
>>
>> Not sure about that; DLT tapes are pretty bulky themselves; I think the
>> difference between say a set of 4 DLT tapes and a single Maxtor 320 in
>> caddy would be minimal. As for stored media, I think Maxtor are quoting
>> 1M hours MTTF - (I hate to think how you measure such a figure) - for
>> the 320G, and that is probably longer than I'd trust either the tape or
>> the drive to survive.
> 
> 
> i DO seriously doubt that this figure includes removing the drive, 
> stuffing it in a siutcase or similar, loading on a truck/car/bike and 
> unloading at a remote site.
> 
> Regards,
> L.
> 

-- 

------------------------------------------------------------------------
Herman Oosthuysen
B.Eng.(E), Member of IEEE
Wireless Networks Inc.
http://www.WirelessNetworksInc.com
E-mail: Herman@WirelessNetworksInc.com
Phone: 1.403.569-5687, Fax: 1.403.235-3964
------------------------------------------------------------------------


