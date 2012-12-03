From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Definitely seeing linux OS RAID device failure on reboot for
 3.x (x >= 5) kernels
Date: Mon, 03 Dec 2012 02:30:10 -0600
Message-ID: <50BC6312.8060807@hardwarefreak.com>
References: <50BB9C5F.4010402@gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50BB9C5F.4010402@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Joe Landman <joe.landman@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/2/2012 12:22 PM, Joe Landman wrote:

> md0 : active raid1 sdc1[0]
>       46890936 blocks super 1.0 [2/1] [U_]
>       bitmap: 1/1 pages [4KB], 65536KB chunk

Apologies for the completely off topic response, but this caught my eye.
 A user specified 64 *MB* chunk size??  I was under the impression that
with RAID1/linear chunk size is ignored.

-- 
Stan

