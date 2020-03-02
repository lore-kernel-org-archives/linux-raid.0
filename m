From: "David C. Rankin" <drankinatty@suddenlinkmail.com>
Subject: Re: Linux 5.5 Breaks Raid1 on Device instead of Partition, Unusable
 I/O
Date: Mon, 2 Mar 2020 00:46:38 -0600
Message-ID: <1691270c-0ead-08ba-27b0-3e672f584030@suddenlinkmail.com>
References: <e46b2ae7-3b88-05f2-58d7-94ee3df449e4@suddenlinkmail.com>
 <20200302102542.309e2d19@natsu>
 <920df583-1d9e-6037-1d61-cbd5e1133d4d@suddenlinkmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <920df583-1d9e-6037-1d61-cbd5e1133d4d@suddenlinkmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 03/02/2020 12:38 AM, David C. Rankin wrote:
> Thank you Roman, iostat and smartctl -a for sdc/sdd attached,
> 
>   sdc has a few errors from a power hit taken 3000 hours ago or so, but since
> that time it has been fine. I had rolled back to several earlier kernels from
> Jan 14, Jan 21, and Jan 27 with no change, I then updated to current which is
> Archlinux 5.5.6-arch1-1.
> 
>   I'm not sure what to make of the iostat output, but the r_await looks
> suspicious. Could this all be due to one flaky disk without it throwing any
> errors?

Actually,

  I think sdc looks like the flaky culprit... So what is recommended in the
interim, fail sdc and remove from array and run on sdd until the replacement
arrives to rebuild? (seems better than limping along with sdc if that is the
one causing all the slowdown)

-- 
David C. Rankin, J.D.,P.E.
