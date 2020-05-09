From: antlists <antlists@youngman.org.uk>
Subject: Re: Assemblin journaled array fails
Date: Sat, 9 May 2020 14:15:15 +0100
Message-ID: <9591809e-583d-ebd5-ea0f-a342868a7728@youngman.org.uk>
References: <f8c61278-1758-66cd-cf25-8a118cb12f58@yandex.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f8c61278-1758-66cd-cf25-8a118cb12f58@yandex.pl>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: Michal Soltys <msoltyspl@yandex.pl>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 09/05/2020 11:54, Michal Soltys wrote:
> After the reboot I'm in the situation as outlined above. Any suggestion 
> how to assemble this array now ?

mdadm -v ?

uname -a ?

https://raid.wiki.kernel.org/index.php/Asking_for_help

Dunno what the problem is, and I'm hesitant to recommend it, but 
re-assembling the array without a journal might work.

You have made sure that bitmaps aren't enabled? You can't have both, but 
for historical reasons you can end up with both enabled and then the 
resulting array won't start.

Cheers,
Wol
