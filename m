From: antlists <antlists@youngman.org.uk>
Subject: Re: Please show descriptive message about degraded raid when booting
Date: Tue, 24 Mar 2020 00:55:38 +0000
Message-ID: <f49f6418-cf92-7dec-77b4-ef099a39bd58@youngman.org.uk>
References: <CAJTWkdvU3of87+-zyUPn7uDBen8ZBswujwMn8wYSiwZb=0V3EQ@mail.gmail.com>
 <CAJTWkdtYbmSapP0cG+nknTQWcn1ut4NaF4v5rEtS0wwvkuMH=A@mail.gmail.com>
 <CAAMCDeeRD51jy8syBoXD_zy2jWFHfG+v0n5AkEHu5-_X0K3+Lg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAMCDeeRD51jy8syBoXD_zy2jWFHfG+v0n5AkEHu5-_X0K3+Lg@mail.gmail.com>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: Roger Heflin <rogerheflin@gmail.com>, Patrick Dung <patdung100@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 23/03/2020 18:13, Roger Heflin wrote:
> Those default timeouts are usually at least 30 seconds, but in the
> past the scsi subsystem did some retrying internally.  The timeout
> needs to be higher than the length of time the disk could take.
> Non-enterprise, non-raid disks generally have this timeout set 60-120
> seconds hence MD waiting to see if the failure is a sector read
> failure (will be a no-response until the disk timeout) or a complete
> disk failure (no response ever).

https://raid.wiki.kernel.org/index.php/Timeout_Mismatch

The whole website is reasonably up-to-date, so it's worth a read.

Cheers,
Wol
