From: Ferenc-Jan <ferenc@avz.xs4all.nl>
Subject: Re: mdadm -D /dev/md3: 1  0  0  0  sync ???
Date: Sun, 26 Dec 2004 10:01:18 +0100
Message-ID: <41CE7DDE.6000008@avz.xs4all.nl>
References: <41C9D08A.5080303@avz.xs4all.nl> <16841.64160.683580.423091@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16841.64160.683580.423091@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Neil Brown <neilb@cse.unsw.edu.au>
List-Id: linux-raid.ids

>>     Number   Major   Minor   RaidDevice State
>>        0       3        6        0      active sync   /dev/hda6
>>        1       0        0        0      sync
>>
>>        2      22        6        2      active sync   /dev/hdc6
>>
>>Please help. Which disk is '1  0  0  0  sync'? The array is currently 
>>degraded. How do I remove number 1 and bring number 2 up?
> 
> This is a missing drive, that is marked as in-sync, which is bad.  
> I don't know how it happened, but the best way to fix it is to remake
> the array:
> 
>    umount ....
>    mdadm -S /dev/md3
>    mdadm -C /dev/md3 -R -l1 -n2 /dev/hda6 missing
>    mdadm /dev/md3 -a /dev/hdc6
> 
> should make it work.  It won't destroy any data

Worked as you said. Thank you very very much!

cheers

Ferenc
