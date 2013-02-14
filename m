From: Jeff Johnson <jeff.johnson@aeoncomputing.com>
Subject: Re: Best practice for large storage?
Date: Thu, 14 Feb 2013 09:48:12 -0800
Message-ID: <511D235C.6070409@aeoncomputing.com>
References: <9702021.20.1360863570996.JavaMail.root@zimbra>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <9702021.20.1360863570996.JavaMail.root@zimbra>
Sender: linux-raid-owner@vger.kernel.org
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Stable enough where it is being used at Lawrence Livermore Nat'l Labs o=
n=20
a 55PB Lustre resource.

I've been using it on a pre-release Lustre 2.4 and I have not had any=20
issues.


On 2/14/13 9:39 AM, Roy Sigurd Karlsbakk wrote:
> I don't feel like using the fuse version, but is zfsonlinux really st=
able yet?
>
> ----- Opprinnelig melding -----
>> Roy,
>>
>> Why not use ZFS on Linux? (http://www.zfsonlinux.org)
>>
>> ZFS on Linux is being merged into the upcoming Lustre 2.4 parallel
>> filesystem release.
>>
>> --Jeff
>>
>> On 2/14/13 9:28 AM, Roy Sigurd Karlsbakk wrote:
>>> Hi all
>>>
>>> It seems we may need some storage for video soon. This is a 20k
>>> studen college in Norway, with rather a few on media related
>>> studies. Since these students produce rather large amounts of raw
>>> material, typically to be stored during the semester, we may need
>>> some 50-100TiB, perhaps more. I have setup systems with these
>>> amounts of storage earlier on ZFS, but may be using Linux MD for
>>> this project. I'm aware of the lack of checksumming, snapshots etc
>>> with Linux, but may be using it because of more Linux knowledge
>>> amongst the sysadmins here. In such a setup, I guess nearline SAS
>>> drives on a SAS expander will be used, and with the amount of
>>> storage needed, I won't be using a single RAID-6 (too insecure) or
>>> RAID-10 (too expensive) for the lot. In ZFS-land I used smallish
>>> VDEVs (~10 drives each) in a large pool.
>>>
>>>    - Would using LVM on top of RAID-6 give me something similar?
>>>    - If so, should I stripe the RAID sets, and again, if striping
>>>    them, will it be as easy to add new RAID sets as we run out of
>>>    space?
>>>
>>> Thanks, and best regards
>>>
>>> roy
>>> --
>>> Roy Sigurd Karlsbakk
>>> (+47) 98013356
>>> roy@karlsbakk.net
>>> http://blogg.karlsbakk.net/
>>> GPG Public key: http://karlsbakk.net/roysigurdkarlsbakk.pubkey.txt
>>> --
>>> I all pedagogikk er det essensielt at pensum presenteres
>>> intelligibelt. Det er et element=C3=A6rt imperativ for alle pedagog=
er =C3=A5
>>> unng=C3=A5 eksessiv anvendelse av idiomer med xenotyp etymologi. I =
de
>>> fleste tilfeller eksisterer adekvate og relevante synonymer p=C3=A5
>>> norsk.
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe
>>> linux-raid" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>>
>> --
>> ------------------------------
>> Jeff Johnson
>> Co-Founder
>> Aeon Computing
>>
>> jeff.johnson@aeoncomputing.com
>> www.aeoncomputing.com
>> t: 858-412-3810 x101 f: 858-412-3845
>> m: 619-204-9061
>>
>> /* New Address */
>> 4170 Morena Boulevard, Suite D - San Diego, CA 92117


--=20
------------------------------
Jeff Johnson
Co-Founder
Aeon Computing

jeff.johnson@aeoncomputing.com
www.aeoncomputing.com
t: 858-412-3810 x101   f: 858-412-3845
m: 619-204-9061

/* New Address */
4170 Morena Boulevard, Suite D - San Diego, CA 92117

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
