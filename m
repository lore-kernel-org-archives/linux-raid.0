From: Reindl Harald <h.reindl@thelounge.net>
Subject: Re: Filesystem corruption on RAID1
Date: Thu, 13 Jul 2017 23:34:17 +0200
Message-ID: <d1255092-73f5-1ca4-0e68-69ff37631a26@thelounge.net>
References: <c2fe6593-c806-ab9f-fcff-8327c013237b@assyoma.it>
 <20170713214856.4a5c8778@natsu> <592f19bf608e9a959f9445f7f25c5dad@assyoma.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <592f19bf608e9a959f9445f7f25c5dad@assyoma.it>
Content-Language: de-CH
Sender: linux-raid-owner@vger.kernel.org
To: Gionatan Danti <g.danti@assyoma.it>, Roman Mamedov <rm@romanrm.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Am 13.07.2017 um 23:28 schrieb Gionatan Danti:
> I understand and agree with that. I'm fully aware that MD can not (by 
> design) detect/correct corrupted data. However, I wonder if, and why, a 
> disk with obvious errors was not kicked out of the array.
maybe because the disk is, well, not in a good shape and don't know that 
by itself - i had storage devices which refused to write but said 
nothing (flash media), frankly you where able to even format that crap 
and overwrite if with zeros and all looked fine - until you pulled the 
broken device and inserted it again - same data as yesterday - a sd-card 
doestroyed a smartphone phisically by empty the whole battey within 30 
minutes while sitting in the cinema

broken hardware don't know that it's broken moste of the time

that#s why you need always backups or can just delete the data at all 
because they are not important

thins like above only could be detected by verify every write with an 
uncached read/verify which would lead in a uneccaptable performane 
penalty (and no filesystems with checksums won't magically recover your 
data, they just tell you realier they are gone)
