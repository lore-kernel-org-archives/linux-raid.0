From: Zhong Lidong <lidong.zhong@suse.com>
Subject: Re: [PATCH] Monitor: remove autorebuild pidfile when it exits
Date: Tue, 28 Apr 2020 00:19:52 +0800
Message-ID: <23c27b96-b6ef-396c-bd8b-3f7b14c25c46@suse.com>
References: <20200327012854.5654-1-lidong.zhong@suse.com>
 <7fce6b8e-dbbc-b8b9-608b-cc5479484882@trained-monkey.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7fce6b8e-dbbc-b8b9-608b-cc5479484882@trained-monkey.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <jes@trained-monkey.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 4/27/20 10:40 PM, Jes Sorensen wrote:
> On 3/26/20 9:28 PM, Lidong Zhong wrote:
>> mdadm monitor is supposed to run in background and never exit. However
>> if it is killed by accident and the pid stored in autorebuild.pid is 
>> taken by some other process, it reports an error when restarting
>> "mdadm: Only one autorebuild process allowed in scan mode, aborting"
>> even though no autorebuild process exists. With the patch, this file
>> will be removed at the end to fix this scenario.
>>
>> Signed-off-by: Lidong Zhong <lidong.zhong@suse.com>
>> ---
>> Hi Jes, 
>>
>> Sorry to ping you, but could you please share your opinion about this patch? TIA.
>> ---
>>  Monitor.c | 39 ++++++++++++++++++++++++++++++++++++++-
>>  1 file changed, 38 insertions(+), 1 deletion(-)
>>
>> diff --git a/Monitor.c b/Monitor.c
>> index b527165..4cb113d 100644
>> --- a/Monitor.c
>> +++ b/Monitor.c
>> @@ -62,6 +62,7 @@ struct alert_info {
>>  	int dosyslog;
>>  };
>>  static int make_daemon(char *pidfile);
>> +static int cleanup_sharer_pidfile();
>>  static int check_one_sharer(int scan);
>>  static void alert(char *event, char *dev, char *disc, struct alert_info *info);
>>  static int check_array(struct state *st, struct mdstat_ent *mdstat,
>> @@ -71,6 +72,12 @@ static int add_new_arrays(struct mdstat_ent *mdstat, struct state **statelist,
>>  			  int test, struct alert_info *info);
>>  static void try_spare_migration(struct state *statelist, struct alert_info *info);
>>  static void link_containers_with_subarrays(struct state *list);
>> +static volatile sig_atomic_t finished = 0;
>> +
>> +static void _exit_handler(int sig)                                                                                               
>> +{
>> +	finished= 1;
> 
> Please respect formatting rules.
> 
> Also this patch fails to apply cleanly:
> 
> Applying: Monitor: remove autorebuild pidfile when it exits
> Using index info to reconstruct a base tree...
> M	Monitor.c
> .git/rebase-apply/patch:27: trailing whitespace.
> static void _exit_handler(int sig)
> 
> .git/rebase-apply/patch:46: trailing whitespace.
> 	
> .git/rebase-apply/patch:47: trailing whitespace.
> 	signal(SIGTERM, &_exit_handler);
> .git/rebase-apply/patch:48: trailing whitespace.
> 	signal(SIGKILL, &_exit_handler);
> warning: 4 lines add whitespace errors.
> Falling back to patching base and 3-way merge...
> Auto-merging Monitor.c
> 
> Please fix and resubmit a v2.
> 

Hi Jes,

Thanks for your reply. Please ignore this one since Coly's patch

Monitor: improve check_one_sharer() for checking duplicated process

is already applied. They are aimed to fix the same issue.

Regards,
Lidong
> Jes
> 
