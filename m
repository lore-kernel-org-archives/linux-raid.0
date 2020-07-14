From: antlists <antlists@youngman.org.uk>
Subject: Re: Reshape using drives not partitions, RAID gone after reboot
Date: Tue, 14 Jul 2020 23:54:29 +0100
Message-ID: <0b857b5f-20aa-871d-a22d-43d26ad64764@youngman.org.uk>
References: <b551920e-ddad-c627-d75a-e99d32247b6d@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <b551920e-ddad-c627-d75a-e99d32247b6d@gmail.com>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: Adam Barnett <adamtravisbarnett@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 14/07/2020 20:50, Adam Barnett wrote:
> Forcing the assembly does not work:
> 
> $ sudo mdadm /dev/md1 --assemble --force /dev/sd[ijmop]1 /dev/sd[kln]
> mdadm: /dev/sdi1 is busy - skipping
> mdadm: /dev/sdj1 is busy - skipping
> mdadm: /dev/sdm1 is busy - skipping
> mdadm: /dev/sdo1 is busy - skipping
> mdadm: /dev/sdp1 is busy - skipping
> mdadm: Cannot assemble mbr metadata on /dev/sdk
> mdadm: /dev/sdk has no superblock - assembly aborted

Did you do an "mdadm --stop /dev/md1" before trying that? That's a 
classic error from an array that's previously been partially assembled 
and failed ...

The other thing I'd do is make sure there aren't any other unepected 
partially assembled arrays. I doubt it applies here, but I have come 
across mirrors that get broken in half and you get two failed arrays 
instead of one working one ...

Cheers,
Wol
