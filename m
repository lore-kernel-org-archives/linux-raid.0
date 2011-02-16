From: Giovanni Tessore <giotex@texsoft.it>
Subject: Re: md road-map: 2011
Date: Wed, 16 Feb 2011 12:28:42 +0100
Message-ID: <4D5BB4EA.8030907@texsoft.it>
References: <20110216212751.51a294aa@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110216212751.51a294aa@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,
I apreciate very much the Bad Block Log feature, as I had big troubles 
with read errors during recovery of a degraded RAID-5 array.
It seems to me a very good idea to just fail a stripe or even a single 
block (the smallest possible unit of information possibly) if the read 
error is unrecoverable, letting the remainig 99.99..% of the device 
still online and available (that is, return the unrecoverable read error 
to the 'caller' as would do a single disk).
Also having the list of bad block availabe into sysfs is a very useful 
feature.

Still regarding to correctable read errors, how are they currently 
managed with RAID-1? If a read error occurs on sector XZY of disk A, the 
same sector XYZ is get from another disk (ramdomly) in the same array 
and rewritten to disk A? (for RAID456 it's reconstructed from parity, 
and it's clearly much safer).

Regards.


On 02/16/2011 11:27 AM, NeilBrown wrote:
> I all,
>   I wrote this today and posted it at
> http://neil.brown.name/blog/20110216044002
>
> I thought it might be worth posting it here too...
>
> NeilBrown


-- 
Cordiali saluti.
Yours faithfully.

Giovanni Tessore


