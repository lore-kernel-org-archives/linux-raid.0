From: Nicolas Jungers <nicolas@jungers.net>
Subject: Re: bug in kernel 3.2 (up to date Debian wheezy)
Date: Fri, 28 Jun 2013 19:35:00 +0200
Message-ID: <51CDC944.1000000@jungers.net>
References: <51CC74C2.6010608@jungers.net>
Reply-To: Nicolas Jungers <nicolas@jungers.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51CC74C2.6010608@jungers.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 06/27/2013 07:22 PM, Nicolas Jungers wrote:
> Assembling a raid 10 array on Debian Wheezy I got the following messages:
>
>
> #-----------
> uname -a
> Linux ha1 3.2.0-4-amd64 #1 SMP Debian 3.2.46-1 x86_64 GNU/Linux
> mdadm --version
> mdadm - v3.2.5 - 18th May 2012
> #-----------
>
> The operation was:
>
> mdadm -C /dev/md0 -l10 -pf2  -n4 -x1 --assume-clean -b internal
> /dev/sd[abcde]1
>
>

[snip]


For info, the partition 1 is ~1 GB and the bug disappear if I suppress 
the internal bitmap. It doesn't show itself on a ~900 GB partition.

regards,
N.

