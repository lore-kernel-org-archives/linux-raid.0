From: Michal Soltys <msoltyspl@yandex.pl>
Subject: Re: Assemblin journaled array fails
Date: Sat, 9 May 2020 15:20:33 +0200
Message-ID: <1615c45f-8f7c-fae2-ef74-a23a29857316@yandex.pl>
References: <f8c61278-1758-66cd-cf25-8a118cb12f58@yandex.pl>
 <9591809e-583d-ebd5-ea0f-a342868a7728@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <9591809e-583d-ebd5-ea0f-a342868a7728@youngman.org.uk>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: antlists <antlists@youngman.org.uk>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 20/05/09 15:15, antlists wrote:
> On 09/05/2020 11:54, Michal Soltys wrote:
>> After the reboot I'm in the situation as outlined above. Any 
>> suggestion how to assemble this array now ?
> 
> mdadm -v ?

mdadm - v4.1 - 2018-10-01

> 
> uname -a ?

Linux xs22 5.4.0-0.bpo.4-amd64 #1 SMP Debian 5.4.19-1~bpo10+1 
(2020-03-09) x86_64 GNU/Linux

> 
> https://raid.wiki.kernel.org/index.php/Asking_for_help
> 
> Dunno what the problem is, and I'm hesitant to recommend it, but 
> re-assembling the array without a journal might work.

I would - if possible - want to avoid this, as the journal is 
write-back. So as a last resort only.

> 
> You have made sure that bitmaps aren't enabled? You can't have both, but 
> for historical reasons you can end up with both enabled and then the 
> resulting array won't start.
> 

Yea, I know - the bitmap is not enabled on this array.
