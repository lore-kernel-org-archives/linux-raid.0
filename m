From: Anu Matthew <anu.matthew@bms.com>
Subject: Re: Problems with SCSI devices renaming...
Date: Tue, 19 Oct 2004 15:38:01 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <41756D19.7040409@bms.com>
References: <LGEHJKEJFBMMDCIAJCDCEEAOCCAA.mc@openskynet.de>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=ISO-8859-1
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <LGEHJKEJFBMMDCIAJCDCEEAOCCAA.mc@openskynet.de>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

mdadm - with multipath devices: I remember it bringing up the md device 
after the names changed, but had to manually add the alternate path. 
And, thereafter it behaved well, and have not added any more luns yet.  
Not sure if it is so in v1.7.0.

You may want to check out devlabel as Matt said..

Martin Clauss wrote:

>>forget autodetect,
>>forget raidtools,
>>switch to mdadm.
>>    
>>
>Yep, seems a bit smarter, and I discovered that there were multiple superblocks
>on some of the disks (from former usage i guess), which confused mdrun....
>Now I hope that it can handle changed device names, I'll try tomorrow...
>
>Thanks,
>Martin
>
>  
>
