From: David Greaves <david@dgreaves.com>
Subject: Re: fedora 3.0 w/RAID1
Date: Thu, 18 Nov 2004 23:42:17 +0000
Message-ID: <419D3359.8050304@dgreaves.com>
References: <419D2BF7.9090408@skybuilders.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <419D2BF7.9090408@skybuilders.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jesse Burkhardt <jesse@skybuilders.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jesse Burkhardt wrote:

> Does anyone know why that fedora 3.0 config'd with RAID1 has no 
> raidtab file? I did a previous install on fedora 2.0 and it did have a 
> raidtab file.
>
I'm a Debian chap now but I would guess that they've migrated to mdadm - 
a far nicer tool.

try
mdadm --detail /dev/md0

and, of course, man mdadm

David
