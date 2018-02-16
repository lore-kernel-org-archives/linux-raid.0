From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: Automatically start two-level mdadm RAID arrays (i.e. RAID 60) on
 boot?
Date: Fri, 16 Feb 2018 11:57:59 +0800
Message-ID: <28a0949a-b8f3-9d76-b2b4-93f5d4c4d3ab@fnarfbargle.com>
References: <CAA43vkUG8LrMUjazeYFtGVKVuTvrYRPe-UcPb21r=xeYpctpmg@mail.gmail.com>
 <20180216020217.2a9c7690@natsu>
 <4ebbb6bf-70a9-fb85-1b9f-82850a187e47@turmel.org>
 <39e0bf6b-4280-590c-9d96-013c70d4e0a4@fnarfbargle.com>
 <CAA43vkW82nJXmwo7=HAhO+shx_Obak_tm7Vy0EKWW+HWW6brnw@mail.gmail.com>
 <30189529-36a2-b8d5-b409-8c1ee1da8037@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <30189529-36a2-b8d5-b409-8c1ee1da8037@fnarfbargle.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Sean Caron <scaron@umich.edu>
Cc: Phil Turmel <philip@turmel.org>, Roman Mamedov <rm@romanrm.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 16/02/18 11:53, Brad Campbell wrote:
> On 16/02/18 10:17, Sean Caron wrote:
> 
>> It's interesting that everyone has reported nested mdadm arrays
>> starting automatically. Is there something special in mdadm.conf to
>> enable this? I was starting to suspect mdadm only does a single pass
>> when trying to auto-start arrays, but everyone's reports make me
>> wonder if I'm just not configuring something quite right.
> 
> I've just checked onne of my Ubuntu 14 VMs and it still uses 
> initramfs-utils. Try this :
> 
> Boot with break=top on the kernel cmd line. That'll drop you into the 
> initramfs at the point where all your modules should be loaded but the 
> scripts in /scripts/local-top/ haven't been executed yet. You can then 
> run them manually (in the order specified in the ORDER file). Run the 
> mdadm script with sh -x mdadm and watch what it does.

Actually, before you try that make sure /etc/default/mdadm has :

INITRDSTART='all'

in it.

Brad
