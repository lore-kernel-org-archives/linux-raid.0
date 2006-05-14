From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Problem with large devices >2TB
Date: Sun, 14 May 2006 13:10:06 -0700 (PDT)
Message-ID: <e482qu$dkq$1@terminus.zytor.com>
References: <0376848.20060510150440@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Followup to:  <0376848.20060510150440@2ka.mipt.ru>
By author:    Jim Klimov <klimov@2ka.mipt.ru>
In newsgroup: linux.dev.raid
> 
>   Since the new parted worked ok (older one didn't), we were happy
>   until we tried a reboot. During the device initialization and after
>   it the system only recognises the 6 or 7 partitions which start
>   before the 2000Gb limit:
> 

For a DOS partition table, there is no such thing as a partition
starting beyond 2 TB.  You need to use a GPT or other more
sophisticated partition table.

	-hpa
