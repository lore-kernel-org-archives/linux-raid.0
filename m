From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Small chunk size read performance penalty
Date: Sun, 18 Aug 2013 20:40:50 -0500
Message-ID: <521177A2.2010704@hardwarefreak.com>
References: <kurge6$qi0$1@ger.gmane.org>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <kurge6$qi0$1@ger.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Ian Pilcher <arequipeno@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 8/18/2013 5:05 PM, Ian Pilcher wrote:
> Can anyone point me to a good explanation of the read performance impact
> of small (RAID-5 and RAID-6) chunk sizes?

Can you elaborate on your workload that demonstrates this?  Different
workloads behave differently with different chunk sizes.

> I understand why large chunks hurt write performance...

Again this is workload dependent.  Large chunks increase write and read
performance for large streaming workloads.

> The "read penalty" is definitely there; I can see it in the test data
> from my NAS.  I just don't understand *why* it's there.

If you can see it, then please demonstrate this read penalty with
numbers.  You obviously have test data from the same set of disks with
two different RAID5s of different chunk sizes.  This is required to see
such a difference in performance.  Please share this data with us.

-- 
Stan


