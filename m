From: Steven Haigh <netwiz@crc.id.au>
Subject: Re: RAID5 -> RAID6 conversion, please help
Date: Wed, 11 May 2011 09:39:27 +1000
Message-ID: <4DC9CCAF.9010709@crc.id.au>
References: <002a01cc0f68$1c851180$558f3480$@priv.hu> <20110511093155.5b1a203e@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110511093155.5b1a203e@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/05/2011 9:31 AM, NeilBrown wrote:
> When it finished you will have a perfectly functional RAID6 array with full
> redundancy.  It might perform slightly differently to a standard layout -
> I've never performed any measurements to see how differently.
>
> If you want to (after the recovery completes) you could convert to a regular
> RAID6 with
>    mdadm -G /dev/md0 --layout=normalise   --backup=/some/file/on/a/different/device
>
> but you probably don't have to.
>

This makes me wonder. How can one tell if the layout is 'normal' or with 
Q blocks on a single device?

I recently changed my array from RAID5->6. Mine created a backup file 
and took just under 40 hours for 4 x 1Tb devices. I assume that this 
means that data was reorganised to the standard RAID6 style? The 
conversion was done at about 4-6Mb/sec.

Is there any effect on doing a --layout=normalise if the above happened?

-- 
Steven Haigh

Email: netwiz@crc.id.au
Web: http://www.crc.id.au
Phone: (03) 9001 6090 - 0412 935 897
Fax: (03) 8338 0299
