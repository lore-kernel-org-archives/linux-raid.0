From: Norman Schmidt <norman.schmidt@web.de>
Subject: Re: strange nr. of devices in array
Date: Sat, 21 Feb 2004 10:19:01 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40372285.7060002@web.de>
References: <20040220214811.0000192c@valo.lan.valo.at>
Reply-To: schmidt@naa.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040220214811.0000192c@valo.lan.valo.at>
To: Christian Kivalo <valo@valo.at>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Christian!

Christian Kivalo schrieb:
> hi everybody!
> 
> i found out, that the superblock of my raid5 array says it's built out
> of 7 disks, but i created it with only 6 disk. the mdadm call used to
> create the array was:
>

> i'm using mdadm version 0.7.2, i think that is pretty old. i will
> upgrade to a more recent version and recreate the array.
> 
> still i would like to know if i encountered a bug or if thats some other
> problem. this mdadm version is the one from debian woody (stable).
> 
> 
> thanks in advance
> christian

Yes, that is a bug in the (very old) 0.7.2 of Debian. Additionally, 
these old versions cannot handle spare devices (after each assemble, you 
hae to add them manually). Use at least mdadm 1.4.0, better the newest 
(I believe 1.5.0). You do not need to recreate the array, simply stop it 
and (re-)assemble it after you have the new mdadm in place - and the bug 
and the wrong output is gone.

Had the same problem (that with the spare device) with SuSE 8.2 and 
Debian Woody...

Bye, Norman.

-- 

Norman Schmidt          Institut fuer Physikal. u. Theoret. Chemie
Dipl.-Chem.             Friedrich-Alexander-Universitaet
schmidt@naa.net         Erlangen-Nuernberg
                         IT-Systembetreuer Physikalische Chemie
