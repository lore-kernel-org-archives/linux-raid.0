From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH]: md: Initialize ctl_name field of table raid_root_table/raid_dir_table to avoid dump_trace info in debug kernel
Date: Tue, 13 Mar 2012 19:14:05 -0700
Message-ID: <m14ntsc4k2.fsf@fess.ebiederm.org>
References: <4F5D747D.9060508@oracle.com>
	<20120314125720.1bb87546@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120314125720.1bb87546@notabene.brown> (NeilBrown's message of
	"Wed, 14 Mar 2012 12:57:20 +1100")
Sender: linux-kernel-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: qing gu <qing.gu@oracle.com>, neilb@cse.unsw.edu.au, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, trivial@kernel.org
List-Id: linux-raid.ids

NeilBrown <neilb@suse.de> writes:

> On Mon, 12 Mar 2012 11:58:53 +0800 qing gu <qing.gu@oracle.com> wrote:
>
>> This patch is used to dispense trace info when system boots with debug 
>> kernel. I have verified it on RHEL6.2 & SLES11.2. Both work fine.
>> In the failure case, system logs that:
>> 
>>     /Feb 21 19:33:55 nsgbj-216-137 kernel: sysctl_check_dir: failed: /dev  ref: /dev .7
>>     Feb 21 19:33:55 nsgbj-216-137 kernel: sysctl table check failed: /dev  Inconsistent directory names
>>     Feb 21 19:33:55 nsgbj-216-137 kernel: Pid: 1, comm: swapper Not tainted 2.6.32-220.el6.x86_64.debug #1
>>     Feb 21 19:33:55 nsgbj-216-137 kernel: Call Trace:
>>     Feb 21 19:33:55 nsgbj-216-137 kernel: [<ffffffff810a2029>] ? set_fail+0x59/0x60
>>     Feb 21 19:33:55 nsgbj-216-137 kernel: [<ffffffff810a23d4>] ? sysctl_check_table+0x3a4/0x680
>>     ...
>>     /
>> 
>> As you can see, system failed with mismatch
>> /sysctl_check_dir: failed: /dev ref: /dev .7/
>> 
>> Signed-off-by: Neil Gu <qing.gu@oracle.com>
>> 
>> -----------------------------------------------------------
>
> (please put patches inline in your email - it makes them easier to reply to)
>
>
>  scripts/kconfig/Makefile |   16 ++++++++++++++++
>   1 file changed, 16 insertions(+)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index ce88755..9630ad3 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -129,6 +129,7 @@ static ctl_table raid_table[] = {
>  
>  static ctl_table raid_dir_table[] = {
>  	{
> +		.ctl_name	= DEV_RAID,
>  		.procname	= "raid",
>  		.maxlen		= 0,
>  		.mode		= S_IRUGO|S_IXUGO,
> @@ -139,6 +140,7 @@ static ctl_table raid_dir_table[] = {
>  
>  static ctl_table raid_root_table[] = {
>  	{
> +		.ctl_name	= CTL_DEV,
>  		.procname	= "dev",
>  		.maxlen		= 0,
>  		.mode		= 0555,
>
> These lines were removed in November 2009 by Eric Biederman in
> commit 894d2491153a9f8270dbed21175d06fde4eba6c7
>
> So I'm not keen on adding them back without understanding the history.
>
> Eric:  Do we need these after all?

For the main trunk no.  The .ctl_name field no longer exists.

kernel/binary_sysctl.c is used to provide backwards compatibility with
the old binary names.

There might be a point for doing something in -stable or someone's
enterprise kernel if some messed up set of backports were merged.

Eric
