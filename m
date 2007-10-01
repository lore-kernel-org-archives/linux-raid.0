From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: problem killing raid 5
Date: Mon, 1 Oct 2007 17:44:55 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0710011744390.13979@p34.internal.lan>
References: <4700D454.7020607@gmail.com> <47013A6B.30302@gmail.com>
 <470140B5.3020203@msgid.tls.msk.ru> <47014368.4040204@ucolick.org>
 <47015A14.9020400@msgid.tls.msk.ru> <47016271.20908@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47016271.20908@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Daniel Santos <daniel.dlds@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Mon, 1 Oct 2007, Daniel Santos wrote:

> It stopped the reconstruction process and the output of /proc/mdstat was :
>
> oraculo:/home/dlsa# cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4] [raid1] [raid0] [linear]
> md0 : active raid5 sdc1[3](S) sdb1[4](F) sdd1[0]
>     781417472 blocks level 5, 256k chunk, algorithm 2 [3/1] [U__]
>
> I then stopped the array and tried to assemble it with a scan :
>
> oraculo:/home/dlsa# mdadm --assemble --scan
> mdadm: /dev/md0 assembled from 1 drive and 1 spare - not enough to start the 
> array.
> oraculo:/home/dlsa# cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4] [raid1] [raid0] [linear]
> md0 : inactive sdd1[0](S) sdc1[3](S) sdb1[1](S)
>     1172126208 blocks
>
> The fourth drive I had to put in mdadm.conf as missing.
>
> The result was that because of the read error, the reconstruction process for 
> the new array aborted, and the assemble came up with an array that seems like 
> the one that failed before I created the new one.
>
> I am running debian with a 2.6.22 kernel.
>
>
> Michael Tokarev wrote:
>> Patrik Jonsson wrote:
>> 
>>> Michael Tokarev wrote:
>>> 
>> []
>> 
>>>> But in any case, md should not stall - be it during reconstruction
>>>> or not.  For this, I can't comment - to me it smells like a bug
>>>> somewhere (md layer? error handling in driver? something else?)
>>>> which should be found and fixed.  And for this, some more details
>>>> are needed I guess -- kernel version is a start.
>>>> 
>>> Really? It's my understanding that if md finds an unreadable block
>>> during raid5 reconstruction, it has no option but to fail since the
>>> information can't be reconstructed. When this happened to me, I had to
>>> 
>> 
>> Yes indeed, it should fail, but not stuck as Daniel reported.
>> Ie, it should either complete the work or fail, but not sleep
>> somewhere in between.
>> 
>> []
>> 
>>> This is why it's important to run a weekly check so md can repair blocks
>>> *before* a drive fails.
>>> 
>> 
>> *nod*.
>> 
>> /mjt
>>
>> 
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Yikes.  By the way are all those drives on the same chipset? What type of 
drives did you use?

Justin.
