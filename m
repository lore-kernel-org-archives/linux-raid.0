From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: imsm: 32 bit sector counts and > 2TB disks
Date: Thu, 13 Dec 2012 17:08:23 +0000
Message-ID: <50CA0B87.5080200@anonymous.org.uk>
References: <50CA062D.2000002@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50CA062D.2000002@ubuntu.com>
Sender: linux-raid-owner@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 13/12/2012 16:45, Phillip Susi wrote:
> It appears that the imsm format only uses 32 bits to represent the
> sector counts used from each disk.  It appears that at least on
> Windows, a disk > 2 TB works

It certainly does. I built a Supermicro server with 3TB drives and IMSM 
RAID a couple of weeks ago.

> so could someone from intel explain how
> this is supposed to work?

I'd be interested too. If I need to expand the array on the above, I was 
expecting to use a Linux live CD and mdadm to do the reshape.

Cheers,

John.

