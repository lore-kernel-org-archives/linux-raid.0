From: Phil Turmel <philip@turmel.org>
Subject: Re: Accidentally resized array to 9
Date: Sat, 30 Sep 2017 12:21:20 -0400
Message-ID: <de7d94b2-7d2c-1419-420d-65b6f531c37f@turmel.org>
References: <0e59cefd-662f-bf77-0c32-49424d504c77@benshoshan.com>
 <20170929175524.57fea3b5@natsu>
 <fec79486-8f23-74dd-9c62-4f89ac00b95d@benshoshan.com>
 <20170930005005.68beae8b@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170930005005.68beae8b@natsu>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.net>, Eli Ben-Shoshan <eli@benshoshan.com>
Cc: linux-raid@vger.kernel.org, John Stoffel <john@stoffel.org>
List-Id: linux-raid.ids

On 09/29/2017 03:50 PM, Roman Mamedov wrote:
> On Fri, 29 Sep 2017 10:53:57 -0400
> Eli Ben-Shoshan <eli@benshoshan.com> wrote:
> 
>> I am just hoping that there might be a way that I can get the 
>> data back.
> 
> In theory what you did was cut the array size to only use 9 KB of each device,
> then reshaped THAT tiny array from 8 to 9 devices, with the rest left
> completely untouched.
> 
> So you could try removing the "new" disk, then try --create --assume-clean
> with old devices only and --raid-devices=8.
> 
> But I'm not sure how you would get the device order right.
> 
> Ideally what you can hope for, is you would get the bulk of array data intact,
> only with the first 9 KB of each device *(8-2), so about the first 54 KB of
> data on the md array, corrupted and unusable. It is likely the LVM and
> filesystem tools will not recognize anything due to that, so you will need to
> use some data recovery software to look for and save the data.
> 

I agree with Roman.  Most of your array should be still on the 8-disk
layout.  But you were mounted and had writing processes immediately
after the broken grow, so there's probably other corruption due to
writes on the 9-disk pattern in the 8 disks.

Roman's suggestion is the best plan, but even after restoring LVM,
expect breakage all over.  Use overlays.

Phil
