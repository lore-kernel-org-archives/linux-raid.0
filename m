From: Martin Wilck <martin.wilck@ts.fujitsu.com>
Subject: Re: [PATCH 9/9] Create: set array status to frozen until monitoring
 starts
Date: Thu, 08 Aug 2013 09:31:22 +0200
Message-ID: <5203494A.9020009@ts.fujitsu.com>
References: <52016A06.8070400@arcor.de> <1375825083-7856-5-git-send-email-mwilck@arcor.de> <20130808104445.7158f437@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130808104445.7158f437@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 08/08/2013 02:44 AM, NeilBrown wrote:
> On Tue,  6 Aug 2013 23:38:03 +0200 mwilck@arcor.de wrote:
> 
>> When we create an array while mdmon is working on an event
>> (e.g. disk failure), the meta data on disk may not be up-to-date.
>>
>> Patch "DDF: ddf_open_new: check device status for new subarray"
>> added some checks for in the monitor for that situation - in particular,
>> to handle a freshly created array with faulty disks. The remaining
>> problem is that the kernel may start syncing the disks before this
>> situation is detected. This patch delays recovery until mdmon finished
>> checking.
>>
>> tests/10ddf-fail-create-race should succeed reliably with this patch
>> and "DDF: ddf_open_new: check device status for new subarray". Without,
>> it will fail sporadically.
>>
>> Signed-off-by: Martin Wilck <mwilck@arcor.de>
>> ---
>>  Create.c    |    8 ++++++++
>>  managemon.c |    6 ++++++
>>  2 files changed, 14 insertions(+), 0 deletions(-)
>>
>> diff --git a/Create.c b/Create.c
>> index ac22f77..f9b7db2 100644
>> --- a/Create.c
>> +++ b/Create.c
>> @@ -993,6 +993,14 @@ int Create(struct supertype *st, char *mddev,
>>  				need_mdmon = 0;
>>  				break;
>>  			default:
>> +				/*
>> +				 * The meta data we saw on disk may not be
>> +				 * up-to-date. The monitor will check and
>> +				 * possibly fail. Avoid a resync happening
>> +				 * in the kernel before that.
>> +				 */
>> +				sysfs_set_str(&info, NULL, "sync_action",
>> +					      "frozen");
>>  				err = sysfs_set_str(&info, NULL, "array_state",
>>  						    "readonly");
>>  				break;
>> diff --git a/managemon.c b/managemon.c
>> index f40bbdb..5bc54da 100644
>> --- a/managemon.c
>> +++ b/managemon.c
>> @@ -744,6 +744,12 @@ static void manage_new(struct mdstat_ent *mdstat,
>>  		new->container = NULL;
>>  		free_aa(new);
>>  	} else {
>> +		/*
>> +		 * Create() set this to frozen.
>> +		 * This relies on the kernel clear FROZEN status
>> +		 * if an invalid value is written to sync_action.
>> +		 */
>> +		sysfs_set_str(&new->info, NULL, "sync_action", "");
>>  		replace_array(container, victim, new);
>>  		if (failed) {
>>  			new->check_degraded = 1;
> 
> 
> I don't think that this patch should be necessary.
> If you find it makes a difference, then I'm missing something.
> 
> Recovery never starts while the array is readonly - the kernel doesn't allow
> it.
> So mdmon should be in complete control as it is the only one that is allowed
> to change the array from readonly.
> 
> Whether it quite does the right thing in this case I can't promise, but it
> should be able to do the right thing without any extra help from mdadm.

I had a look at the dmesg output and it appeared to me that the kernel
started resync on the new array before it noticed that one of the disks
were faulty. But I may have been mistaken. Unfortunately I didn't keep
those logs. For now I am fine with what you are saying - you know the
ways of the kernel MD driver way better then me.

> And writing an empty string to 'sync_action' will not do anything useful.
> You probably mean to write "idle".

Hmm...

4223 static ssize_t
4224 action_store(struct mddev *mddev, const char *page, size_t len)
4225 {
...
4229     if (cmd_match(page, "frozen"))
4230         set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
4231     else
4232         clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);

To me this looks as if FROZEN was cleared whenever anything else but
"frozen" was written. What am I missing here? I actually meant to do
exactly that because I didn't want to loose the previous status. But as
I said, I am not familiar enough with the kernel md code to understand
exactly what happens.

> I've applied and push out the previous patches but not this one.

Thanks.
Martin



-- 
Dr. Martin Wilck
PRIMERGY System Software Engineer
x86 Server Engineering

FUJITSU
Fujitsu Technology Solutions GmbH
Heinz-Nixdorf-Ring 1
33106 Paderborn, Germany
Phone:			++49 5251 525 2796
Fax:			++49 5251 525 2820
Email:			martin.wilck@ts.fujitsu.com
Internet:		http://ts.fujitsu.com
Company Details:	http://ts.fujitsu.com/imprint
