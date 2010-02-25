From: Giovanni Tessore <giotex@texsoft.it>
Subject: Re: emergency call for help: raid5 fallen apart
Date: Thu, 25 Feb 2010 09:05:00 +0100
Message-ID: <4B862F2C.5030302@texsoft.it>
References: <4B853DB7.1060406@xunil.at> <4B854040.5080603@xunil.at> <20100224152228.GB11039@cthulhu.home.robinhill.me.uk> <4B85467C.5020008@xunil.at> <4B855621.5010000@xunil.at> <4B855987.1010605@xunil.at> <4B855B8C.8080802@xunil.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B855B8C.8080802@xunil.at>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Stefan G. Weichinger wrote:
> Feb 24 17:57:42 server-gentoo end_request: I/O error, dev sda, sector
> 20757018
> Feb 24 17:57:42 server-gentoo raid5:md4: read error not correctable
> (sector 1032 on sda4).
> Feb 24 17:57:42 server-gentoo raid5: Disk failure on sda4, disabling
> device. Operation continuing on 1 devices
> Feb 24 17:57:42 server-gentoo raid5:md4: read error not correctable
> (sector 1040 on sda4).
> Feb 24 17:57:42 server-gentoo raid5:md4: read error not correctable
> (sector 1048 on sda4).
>
>
> Does it make sense to repeat:
>
> mdadm --assemble
> xfs_repair
> mount
>
> and rsync stuff aside until it fails again?
>
> I once was lucky with such a strategy ...
>   

I recently had similar problem with a 6 disk array, when one died and 
another gave read errors during reconstruction (see older posts about 
end of january).
I was able to recover most data reassembling the array and copying data 
from it to another storage, repeating the assembly each time the read 
errors was encountered; so the 'strategy' mostly worked for me 
(recovered almost everything); it may help setting the md device in 
readonly mode, and mounign the partition as readonly.

I hope you can recover your data.
Regards

PS.
I see this is the 4th time in a month that poeple reports problem on 
raid5 due to the read errors during reconstruction; it looks like the 
'corrected read errors' policy is quite a real concern.

-- 
Cordiali saluti.
Yours faithfully.

Giovanni Tessore


