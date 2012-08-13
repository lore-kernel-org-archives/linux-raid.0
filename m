From: Phil Turmel <philip@turmel.org>
Subject: Re: Disk Order
Date: Sun, 12 Aug 2012 20:01:22 -0400
Message-ID: <502843D2.60709@turmel.org>
References: <50281BB1.6030309@abpni.co.uk> <50283949.9050906@grumpydevil.homelinux.org> <502840A9.1000303@abpni.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <502840A9.1000303@abpni.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Jonathan Tripathy <jonnyt@abpni.co.uk>
Cc: Rudy Zijlstra <rudy@grumpydevil.homelinux.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Jonathan,

On 08/12/2012 07:47 PM, Jonathan Tripathy wrote:

[trim /]

> how do I know/configure which disk is A1 and which is A2? I just want to
> know the disk order after i split my array across different adapters.

The output of "mdadm -D /dev/md0" will show you the order in the
"RaidDevice" column.

HTH,

Phil
