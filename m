From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Incredibly poor performance of mdraid-1 with 2 SSD Samsung 840
 PRO
Date: Tue, 23 Apr 2013 06:49:25 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1304230648160.26743@uplift.swm.pp.se>
References: <5171CBF9.9020701@redhost.ro> <51732E2B.6090607@hardwarefreak.com> <5174501F.80509@redhost.ro> <51747382.1010105@hardwarefreak.com> <5175C6D0.3030901@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5175C6D0.3030901@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Andrei Banu <andrei.banu@redhost.ro>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 22 Apr 2013, Stan Hoeppner wrote:

> On 4/21/2013 6:17 PM, Stan Hoeppner wrote:
>
>> It may not be necessary, at least to solve any SSD performance problems
>> anyway.  Reexamining your numbers shows you hit 262MB/s to /dev/sda.
>> That's 65% of SATA2 interface bandwidth, so this kernel probably does
>> have the patch.  Your problem lie elsewhere.
>
> Big correction.  That should state 87% of SATA2 interface bandwidth.  I
> must have been thinking of three things at once when I fubar'd that, as
> that's not simply a typo.

As far as I know, the 300 megabyte/s of SATA2 bw doesn't include coding 
overhead etc, so it's not theoretically possible to reach all the way up 
to 300. From all tests I've seen, around 260-270 megabyte/s seems to be 
maximum that can be achievable, so I'd say 262 MB/s is basically as much 
as can be expected from SATA2.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
