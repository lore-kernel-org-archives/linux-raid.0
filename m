From: Gionatan Danti <g.danti@assyoma.it>
Subject: Re: Network based (iSCSI) RAID1 setup
Date: Thu, 11 May 2017 17:09:04 +0200
Message-ID: <9dbee0bd-c2c1-513d-3474-a44cb7a66f38@assyoma.it>
References: <dc2c3583-14da-435b-0177-8cee749a1cd0@assyoma.it>
 <651c37fe-68b2-2dd7-a429-e62c994de60b@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <651c37fe-68b2-2dd7-a429-e62c994de60b@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/05/2017 14:08, Adam Goryachev wrote:
> It depends on your definition of production, but for me, the answer is
> no. Once upon a time, I used MD to do RAID1 between a local SSD and a
> remote device with NBD and that worked well, (apart from the fact I
> needed to manually re-add the remote device after a reboot, or whenever
> it dropped out for any other reason). It did save me when the local SSD
> died, and I was able to keep running purely from the remote NBD device
> until I could get in and replace the local SSD.
>
> Today, I use DRBD, and would much prefer that compared to MD + NBD.

Thanks for your feedback, Adam. I agree with your, for the reasons 
expressed below. Hoping to be useful for others, I'll document here my 
findings.

>> I'm using two CentOS 7.3 x86-64 boxes, with kernel version
>> 3.10.0-514.16.1.el7.x86_64 and mdadm v3.4 - 28th January 2016. Here
>> you can find my current RAID1 setup, where /dev/sdb is the iSCSI disk:
>>
>> So, second question: how to enable auto re-add for the remote device
>> when it become available again? For example:
>
> I don't know, but I guess you need to work out what udev rules are
> triggered when the iscsi device is "connected", and then get that to
> trigger the MD add rules. Possibly you could try to create a partition
> on the iscsi, and then use sdb1 for the RAID array, there might be
> better handling by udev in that case (I really don't know, just making
> random suggestions here).

I worked out how to enable auto re-add: the key was to include a default 
"POLICY action=re-add" in /etc/mdadm.conf; at this point, any removed 
disk will be re-attached automatically when it newly become visible.

With a catch: in iSCSI, when the remote disk become unresponsive and it 
is dropped, it is *not* removed (by udev) from the disk entries found in 
/dev. As both the remove and the auto-readd processes depends on udev 
events triggering changes to the /dev directory (ie: a drive 
disappearing and/or reappearing), rebooting the remote host will cause 
the iSCSI-imported disk to be marked as failed, but not as removed (due 
to its entries in /dev being *not* removed); later, when the iSCSI disk 
become visible again, it is re-added as a spare.

So, while mdadm by itself worked quite well with networked disks, I 
agree with Adam in that, for production workloads, this is a too fragile 
setup. Specifically:
- the default iSCSI timeout (120 seconds) it way too high and need to be 
adjusted;
- as, by default, mdadm scans all disk devices for valid arrays, *both* 
the local and remote machines can see the md array. This must be avoided 
with the using of the ARRAY <ignore> directive in the mdadm.conf file on 
the remote machines (ie: the one which exports the iSCSI drives);
- udev is clearly not geared for managing events caused by remote disks 
which suddenly disconnect without advice.

In the end, no problems seems related to mdadm itself, which remains a 
wonderful and extremely flexible tool to manage software RAIDs. Thank 
you all for the hard works.

Regards.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
