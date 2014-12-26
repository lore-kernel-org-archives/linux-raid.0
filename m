From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: Re: [PATCH 00/24] Clustered MD RAID1
Date: Fri, 26 Dec 2014 16:49:10 -0600
Message-ID: <549DE5E6.2060208@suse.de>
References: <20141218161456.GA29504@shrek.lan> <5499A55E.3010705@suse.de> <549DE299.3010205@kieser.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <549DE299.3010205@kieser.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Kieser <peter@kieser.ca>, neilb@suse.de
Cc: lzhong@suse.com, john@stoffel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Peter,

On 12/26/2014 04:35 PM, Peter Kieser wrote:
>
> On 2014-12-23 9:24 AM, Goldwyn Rodrigues wrote:
>> This md device can be used as a regular shared device. There are no
>> restrictions on the type of filesystem or LVM you can use, as long as
>> you observe clustering rules of using a shared device.
>
> This is very vague. I feel like this is a huge layering violation. LVM
> or filesystem on top of mdadm should not have to be aware of what is
> going on below.

How is this a layering violation? I said there are _no_ restrictions as 
long you follow the clustering rules of using a shared device. This 
device can be used as a regular device with the filesystem being unaware 
of how the data is handled underneath. The only thing the md device 
ensures is that the data (between mirrors) is consistent for the cluster.

By clustering rules I mean rules such as:
	- Use a clustered filesystem
	- Use cLVM (as opposed to usual LVM) on top of MD-RAID.
	- Use local filesystems in active/passive mode

> Otherwise, I feel like other clustered filesystems that
> include RAID are better suited.

such as?


> As it stands, what are the benefits of
> using this over $CLUSTER_FS?

This is not a cluster filesystem. This is a RAID which is made cluster 
aware for your shared storage. This provides redundancy at the device 
level for a clustered filesystem. Your cluster shared storage  is a 
single point of failure (in case hardware-based raid is not used) and 
this software-based solution avoids making it a single point of failure.

An example usage scenario (not limited to) could be using it across two 
iSCSI devices to ensure higher availability.

-- 
Goldwyn
