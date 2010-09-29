From: Tim Small <tim@seoss.co.uk>
Subject: Re: raid5+hotspare: request for recommended procedure
Date: Wed, 29 Sep 2010 11:03:33 +0100
Message-ID: <4CA30EF5.8020702@seoss.co.uk>
References: <4CA300EB.1070909@xunil.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4CA300EB.1070909@xunil.at>
Sender: linux-raid-owner@vger.kernel.org
To: lists@xunil.at, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 29/09/10 10:03, Stefan G. Weichinger wrote:
> I also ran a "echo check>  /sys/block/mdX/md/sync_action" because this
> had helped to remove those errors at another server, unfortunately it
> did not help here.
>
> Could you please advise what the better and safer alternative would be?
>
>    

Run smartctl -t long, and see what the LBA of the errors are (smartctl 
-a when finished, and look at the error log) - it may be that it is 
outside of the used space (e.g. right at the end of the drive - I've 
seen this in the past) if this is the case, you can just dd over it.

If the test completes without error then the unreadable sector is either 
not user-addressable, or doesn't really exist, in which case I'd ignore 
it (or perhaps a security-erase will get the drive back into a sensible 
state).  Some of the earlier firmwares for the ST3250310NS were a little 
buggy in my experience, so you might want to look at upgrading it 
(latest Seagate non-OEM firmware is SN06), which can be done with hdparm.

Tim.

-- 
South East Open Source Solutions Limited
Registered in England and Wales with company number 06134732.
Registered Office: 2 Powell Gardens, Redhill, Surrey, RH1 1TQ
VAT number: 900 6633 53  http://seoss.co.uk/ +44-(0)1273-808309

