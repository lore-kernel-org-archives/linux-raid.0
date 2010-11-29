From: Jan Ceuleers <jan.ceuleers@computer.org>
Subject: Re: Problems after reshaping of Raid5 array
Date: Mon, 29 Nov 2010 20:12:32 +0100
Message-ID: <4CF3FB20.2040100@computer.org>
References: <AANLkTinUU6Mh-cYbyCF_vL2PzGzFKMcqSZmPULxctquh@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTinUU6Mh-cYbyCF_vL2PzGzFKMcqSZmPULxctquh@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michele Bonera <mbonera@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 29/11/10 18:24, Michele Bonera wrote:
> After rebooting, the reshaping restarted, but the disk become sdb
> not sdb1 in the raid array, and the file system became unreadable
>
> Any ideas of what happened?

Michele,

I've had similar problems, which I resolved by changing the partition 
type from fd (Linux RAID autodetect) to 83 (Linux), ensuring that the 
initrd is able to assemble the RAID.

Worth a shot.

HTH, Jan
