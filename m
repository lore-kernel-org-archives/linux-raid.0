From: Phil Turmel <philip@turmel.org>
Subject: Re: raid role number off on one array?
Date: Fri, 11 Sep 2015 09:54:42 -0400
Message-ID: <55F2DD22.3030406@turmel.org>
References: <55F249DB.5010908@suddenlinkmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <55F249DB.5010908@suddenlinkmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "David C. Rankin" <drankinatty@suddenlinkmail.com>, mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi David,

On 09/10/2015 11:26 PM, David C. Rankin wrote:

[trim /]

> md1 : active raid1 sda7[2] sdb7[1]
> 
>   My concern is why is sda7 shown as being in role [2] and sdb7 shown in
> [1]? All other arrays are [0][1]. What concerns me is the information at:

/proc/mdstat doesn't show role numbers.  It shows slot numbers.  Slot
numbers are the indices into the role number tracking tables in the
superblock.  They happen to match role numbers on a freshly-created
array simply because the slots are allocated starting from zero, just
like the roles.  As you add and remove devices, the slot numbers and
role numbers may no longer match.

Phil

