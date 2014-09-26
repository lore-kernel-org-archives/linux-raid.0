From: Francis Moreau <francis.moro@gmail.com>
Subject: Re: /sys/block/md126 still exists even after stopping the array
Date: Fri, 26 Sep 2014 14:50:08 +0200
Message-ID: <54256100.3090507@gmail.com>
References: <53A99B76.3020603@gmail.com>	<20140625110348.48ab2d7a@notabene.brown>	<54243ED7.6090904@gmail.com>	<20140926103348.5f5ea568@notabene.brown>	<54253E9F.4070505@gmail.com> <20140926204445.1ec830b9@notabene.brown> <54255A30.9010406@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <54255A30.9010406@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>, sebastian.riemer@profitbricks.com
List-Id: linux-raid.ids

On 09/26/2014 02:21 PM, Francis Moreau wrote:
[...]

> 
>>>> mdadm --stop --scan <<<
> 
> [   89.975162] md_open(): md125 opened by mdadm [930]
> [   89.975305] md_release(): md125 released by mdadm [930]
> [   89.977434] md_open(): md125 opened by mdadm [932]
> [   89.978813] md_open(): md125 opened by mdadm [930]
> [   89.979365] md_release(): md125 released by mdadm [932]
> [   89.979693] md_open(): md125 opened by systemd-udevd [931]
> [   89.985790] md_release(): md125 released by systemd-udevd [931]
> [   90.179911] md_release(): md125 released by mdadm [930]
> [   90.180168] md_open(): md127 opened by mdadm [459]
> [   90.180187] md_release(): md127 released by mdadm [459]
> [   90.180199] md_open(): md126 opened by mdadm [459]
> [   90.180205] md_release(): md126 released by mdadm [459]
> [   90.180556] md_open(): md126 opened by mdadm [930]
> [   90.180653] md_release(): md126 released by mdadm [930]
> [   90.180690] md_open(): md126 opened by mdadm [930]
> [   90.180758] md_open(): mdX opened by mdadm [459]

What is this 'mdX' device that mdadm operates on ?

It also doesn't have a counterpart release() call.


> [   90.180995] md_open(): md125 opened by mdadm [459]
> [   90.181056] md_release(): md125 released by mdadm [459]
> [   90.182717] md_open(): md127 opened by mdadm [459]
> [   90.182725] md_release(): md127 released by mdadm [459]
> [   90.182732] md_open(): md126 opened by mdadm [459]
> [   90.182761] md_release(): md126 released by mdadm [459]
> [   90.182770] md_open(): md125 opened by mdadm [459]
> [   90.182775] md_release(): md125 released by mdadm [459]
> [   90.182940] md_release(): md126 released by mdadm [930]
> [   90.183167] md_open(): md127 opened by mdadm [930]
> [   90.183257] md_release(): md127 released by mdadm [930]
> [   90.183288] md_open(): md127 opened by mdadm [930]
> [   90.183461] md_open(): md127 opened by mdadm [459]
> [   90.183488] md_release(): md127 released by mdadm [459]
> [   90.183499] md_open(): md125 opened by mdadm [459]
> [   90.183505] md_release(): md125 released by mdadm [459]
> [   90.183686] md_release(): md127 released by mdadm [930]
> 
> 
>> Probably there is a 'change' event happening just before the 'remove' event,
>> and udev runs "mdadm" on the 'change' event, and that ends up happening after
>> the device has been removed.
>>
>> Is this really a problem?  Can't you just ignore it and pretend it isn't
>> there?
> 
> Well, if you list the block devices that the kernel detected in order to
> operate on them, it could. I don't know exactly what would be the result
> to use it but it could confuse some tools.
> 
> Is there a way to check that the 'ghost' device has been removed by
> poking sysfs ?
> 
> Thanks
> 

