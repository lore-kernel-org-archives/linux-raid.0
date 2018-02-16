From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: Automatically start two-level mdadm RAID arrays (i.e. RAID 60) on
 boot?
Date: Fri, 16 Feb 2018 09:41:56 +0800
Message-ID: <39e0bf6b-4280-590c-9d96-013c70d4e0a4@fnarfbargle.com>
References: <CAA43vkUG8LrMUjazeYFtGVKVuTvrYRPe-UcPb21r=xeYpctpmg@mail.gmail.com>
 <20180216020217.2a9c7690@natsu>
 <4ebbb6bf-70a9-fb85-1b9f-82850a187e47@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4ebbb6bf-70a9-fb85-1b9f-82850a187e47@turmel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, Roman Mamedov <rm@romanrm.net>, Sean Caron <scaron@umich.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 16/02/18 05:51, Phil Turmel wrote:
> 
> No, it sounds like an old distro that isn't using udev and incremental
> assembly.  I don't know of a solution.

I use several of those (old distros that is). In the initramfs mdadm 
waits for the devices to become available, the starts the arrays in 
order as listed in the mdadm.conf. I've never had an issue failing to 
start a stacked array and I don't use incremental assembly.

You do need to make sure they are listed in the correct order in the 
config file, but even mdadm --detail --scan seems to spit out the arrays 
in the correct order (or maybe I just get lucky).

Brad
