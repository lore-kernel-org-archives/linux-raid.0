From: Christopher Smith <csmith@nighthawkrad.net>
Subject: Re: Raid sync observations
Date: Wed, 21 Dec 2005 12:55:47 +1100
Message-ID: <43A8B623.5060704@nighthawkrad.net>
References: <E1Eol86-0008Ju-3J@highlab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <E1Eol86-0008Ju-3J@highlab.com>
Sender: linux-raid-owner@vger.kernel.org
To: Sebastian Kuzminsky <seb@highlab.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Sebastian Kuzminsky wrote:
> I just created a RAID array (4-disk RAID-6).  When "mdadm -C" returned,
> /proc/mdstat showed it syncing the new array at about 17 MB/s.  "vmstat 1"
> showed hardly any blocks in or out, and an almost completely idle cpu.

This isn't really relevant to your questions but...

Why would you use RAID6 and not RAID10 with four disks ?

CS
