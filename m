From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Hlep hardware selection
Date: Thu, 18 Jul 2013 17:34:13 -0500
Message-ID: <51E86D65.6020707@hardwarefreak.com>
References: <CAH3kUhHWQ3tNr843=oO+JacEG8uTvqhXsyx0WvN8Dk+F_tDGoA@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAH3kUhHWQ3tNr843=oO+JacEG8uTvqhXsyx0WvN8Dk+F_tDGoA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 7/18/2013 4:26 PM, Roberto Spadim wrote:
> Hi guys, i'm a bit distant from last hardware
> i need four disks (enterprise level ~ 120 to 300gb)
> two ssd (for cache via bcache,dmcache or flashcache ~ 120gb or less)
> and a raid controller card that i could use smartctl and others tools
> to check disk status
> 
> any help is welcome, i don't know if here is the better place to ask,
> or if anyone know some high level forum / list for hardware updates
> i need true fail safe disks (enterprise use), i'm talking about
> checksum of disk, silent error detection or maybe silent error prof

You've presented somewhat of a fairy land smorgasbord wish list, not an
actual set of requirements.  Maybe if provide an actual set of
requirements you'd get some real answers.  I.e.

My workload needs net capacity X, Y IOPS, and Z bandwidth.  I want to
use a real enterprise caliber RAID card with battery/flash backed write
cache, and I want to use enterprise class drives.  My budget is $AAAA.

Will the drives will be housed in an external SAS JBOD hot swap chassis
or in a hot swap SAS backplane in an existing server?  If you're not
using hot swap backplanes none of your "enterprise" aspirations are valid.

-- 
Stan


