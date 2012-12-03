From: Brad Campbell <brad@fnarfbargle.com>
Subject: Re: Definitely seeing linux OS RAID device failure on reboot for
 3.x (x >= 5) kernels
Date: Mon, 03 Dec 2012 17:02:36 +0800
Message-ID: <50BC6AAC.7020604@fnarfbargle.com>
References: <50BB9C5F.4010402@gmail.com> <50BC6312.8060807@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50BC6312.8060807@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: Joe Landman <joe.landman@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 03/12/12 16:30, Stan Hoeppner wrote:
> On 12/2/2012 12:22 PM, Joe Landman wrote:
>
>> md0 : active raid1 sdc1[0]
>>        46890936 blocks super 1.0 [2/1] [U_]
>>        bitmap: 1/1 pages [4KB], 65536KB chunk
> Apologies for the completely off topic response, but this caught my eye.
>   A user specified 64 *MB* chunk size??  I was under the impression that
> with RAID1/linear chunk size is ignored.

I thought that was the size chunk represented by one bit in the write intent bitmap.

