From: Yuri Tikhonov <yur@emcraft.com>
Subject: Re[2]: [PATCH 07/11] md: rewrite handle_stripe_dirtying6 in asynchronous  way
Date: Fri, 16 Jan 2009 17:24:03 +0300
Message-ID: <1141743016.20090116172403@emcraft.com>
References: <200812090057.33890.yur@emcraft.com> <e9c3a7c20901151351p5e1b4641h1b4c8ba1ae5dcc73@mail.gmail.com> <e9c3a7c20901151421o69522f71rfe6d7d9621de47eb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e9c3a7c20901151421o69522f71rfe6d7d9621de47eb@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org, linuxppc-dev@ozlabs.org, dzu@denx.de, wd@denx.de, yanok@emcraft.com
List-Id: linux-raid.ids

On Friday, January 16, 2009 you wrote:

> On Thu, Jan 15, 2009 at 2:51 PM, Dan Williams <dan.j.williams@intel.com> wrote:
>> On Mon, Dec 8, 2008 at 2:57 PM, Yuri Tikhonov <yur@emcraft.com> wrote:
>> What's the reasoning behind changing the logic here, i.e. removing
>> must_compute and such?  I'd feel more comfortable seeing copy and
>> paste where possible with cleanups separated out into their own patch.
>>

> Ok, I now see why this change was made.  Please make this changelog
> more descriptive than "Rewrite handle_stripe_dirtying6 function to
> work asynchronously."

 Sure, how about the following:

"

 md: rewrite handle_stripe_dirtying6 in asynchronous way

 Processing stripe dirtying in asynchronous way requires some changes 
to the handle_stripe_dirtying6() algorithm.

 In the synchronous implementation of the stripe dirtying we processed 
dirtying of a degraded stripe (with partially changed strip(s) located 
on the failed drive(s)) inside one handle_stripe_dirtying6() call:
- we computed the missed strips from the old parities, and thus got 
the fully up-to-date stripe, then
- we did reconstruction using the new data to write.

 In the asynchronous case of handle_stripe_dirtying6() we don't 
process anything right inside this function (since we under the lock), 
but only schedule the necessary operations with flags. Thus, if 
handle_stripe_dirtying6() is performed on the top of a degraded array 
we should schedule the reconstruction operation when the failed strips 
are marked (by previously called fetch_block6()) as to be computed 
(with the R5_Wantcompute flag), and all the other strips of the stripe 
are UPTODATE. The schedule_reconstruction() function will set the 
STRIPE_OP_POSTXOR flag [for new parity calculation], which is then 
handled in raid_run_ops() after the STRIPE_OP_COMPUTE_BLK one [which 
causes computing of the data missed].

"

 Regards, Yuri

 --
 Yuri Tikhonov, Senior Software Engineer
 Emcraft Systems, www.emcraft.com

