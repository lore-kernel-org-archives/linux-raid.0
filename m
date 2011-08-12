From: Asdo <asdo@shiftmail.org>
Subject: Re: single cpu thread performance limit?
Date: Fri, 12 Aug 2011 14:48:23 +0200
Message-ID: <4E452117.9060300@shiftmail.org>
References: <CAACGR8sSieD1MLCEnY0Wv24pHd9xpcJ=mhduwGMCqo5A5ttZpw@mail.gmail.com>
 <4E44265D.3050809@hardwarefreak.com>
 <CAACGR8to9iybX+fJ_CGYBFgR6XtgPoqCt8kFA4mpqo4d1jEMqw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <CAACGR8to9iybX+fJ_CGYBFgR6XtgPoqCt8kFA4mpqo4d1jEMqw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: mark delfman <markdelfman@googlemail.com>
Cc: Stan Hoeppner <stan@hardwarefreak.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

On 08/11/11 21:37, mark delfman wrote:
> So, a single RAID10 creates a single thread - which will max at maybe 200K IOPS.
> Create 4 x RAID10's seems OK, but they will not scale so great with a
> RAID0 on top :(
> Ideal would be a few threads per RAIDx

Try this: LVM.
AFAIR, LVM does not have its thread, it is the application thread that 
executes LVM code.
This should not impede scalability.

If you are testing with something like fio, which randomly spans the 
whole device with random I/O during test, you can use a linear LVM 
concatenation (which is the default when you create a LV that spans the 
whole VG).
Otherwise use striping on lvcreate.
Try both if possible.

Also, as other people have said, your kernel is quite old... Actually I 
don't remember if there were performance improvements regarding what you 
are doing, but you probably should try a newer one.

Let me know how it goes.
