From: Matt Darcy <kernel-lists@projecthugo.co.uk>
Subject: Re: 2.6.15-mm3 sata_mv / raid 5 array start failure on boot
Date: Wed, 11 Jan 2006 10:08:29 +0000
Message-ID: <43C4D91D.9060008@projecthugo.co.uk>
References: <43B82DDE.3060509@projecthugo.co.uk>	<43BA9A24.7030002@projecthugo.co.uk> <17347.3650.415581.4115@cse.unsw.edu.au>
Reply-To: kernel-lists@projecthugo.co.uk
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <17347.3650.415581.4115@cse.unsw.edu.au>
Sender: linux-ide-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-ide@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:

>On Tuesday January 3, kernel-lists@projecthugo.co.uk wrote:
>  
>
>>I re-created the array - and took a dump of the raid config
>>
>>ARRAY /dev/md6 level=raid5 num-devices=6 spares=1 
>>UUID=f92fa512:1fe54278:d3ba820f:cecb842a
>>    
>>
>
>You'll need a 'DEVICES' line in the mdadm.conf for it to work.
>
>NeilBrown
>  
>
thanks for this tip.

Matt

