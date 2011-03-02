From: Mark Knecht <markknecht@gmail.com>
Subject: Re: RAID10 Performance
Date: Wed, 2 Mar 2011 06:42:09 -0800
Message-ID: <AANLkTi=YpZYMPKVNYHTYLswOixg61Z2iJY__9sZAtC_9@mail.gmail.com>
References: <4D6E0813.1070903@cendio.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D6E0813.1070903@cendio.se>
Sender: linux-raid-owner@vger.kernel.org
To: Aaron Sowry <aaron@cendio.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Mar 2, 2011 at 1:04 AM, Aaron Sowry <aaron@cendio.se> wrote:
<SNIP>
>
> 2) Does md RAID1 support 'striped' reads? If not, is RAID1 read
> performance in any way related to the number of disks in the array?
<SNIP>

RAID1 is all about redundancy/reliability and not about improving
performance as measured by MB/S.

- Mark
