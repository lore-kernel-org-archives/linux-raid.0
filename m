From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH 5/8] {platform,super}-intel: Fix two resource leaks
Date: Wed, 09 Mar 2016 11:23:50 -0500
Message-ID: <wrfjegbjvcvd.fsf@redhat.com>
References: <1457458252-20203-1-git-send-email-Jes.Sorensen@redhat.com>
	<1457458252-20203-6-git-send-email-Jes.Sorensen@redhat.com>
	<87d1r4lhb8.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87d1r4lhb8.fsf@notabene.neil.brown.name> (NeilBrown's message of
	"Wed, 09 Mar 2016 09:45:47 +1100")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, gqjiang@suse.com, pawel.baldysiak@intel.com
List-Id: linux-raid.ids

NeilBrown <neilb@suse.de> writes:
> On Wed, Mar 09 2016, Jes.Sorensen@redhat.com wrote:
>
>> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>>
>> The code did not free 'dir' allocated by opendir(). An additional
>> benefit is that this simplifies the for() loops.
>>
>> Fixes: 60f0f54d ("IMSM: Add support for VMD")
>> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
>> ---
>>  platform-intel.c | 7 ++++++-
>>  super-intel.c    | 6 +++++-
>>  2 files changed, 11 insertions(+), 2 deletions(-)
>>
>> diff --git a/platform-intel.c b/platform-intel.c
>> index 88818f3..c60fd9e 100644
>> --- a/platform-intel.c
>> +++ b/platform-intel.c
>> @@ -724,8 +724,10 @@ char *vmd_domain_to_controller(struct sys_dev *hba, char *buf)
>>  		return NULL;
>>  
>>  	dir = opendir("/sys/bus/pci/drivers/vmd");
>> +	if (!dir)
>> +		return NULL;
>>  
>> -	for (ent = dir ? readdir(dir) : NULL; ent; ent = readdir(dir)) {
>> +	for (ent = readdir(dir); ent; ent = readdir(dir)) {
>>  		sprintf(path, "/sys/bus/pci/drivers/vmd/%s/domain/device",
>>  			ent->d_name);
>>  
>> @@ -734,8 +736,11 @@ char *vmd_domain_to_controller(struct sys_dev *hba, char *buf)
>>  
>>  		if (strncmp(buf, hba->path, strlen(buf)) == 0) {
>>  			sprintf(path, "/sys/bus/pci/drivers/vmd/%s", ent->d_name);
>> +			closedir(dir);
>>  			return realpath(path, buf);
>>  		}
>>  	}
>> +
>> +	closedir(dir);
>>  	return NULL;
>>  }
>> diff --git a/super-intel.c b/super-intel.c
>> index 158f4e8..e1bee75 100644
>> --- a/super-intel.c
>> +++ b/super-intel.c
>> @@ -1781,7 +1781,10 @@ static int print_vmd_attached_devs(struct sys_dev *hba)
>>  	 * this hba
>>  	 */
>>  	dir = opendir("/sys/bus/pci/drivers/nvme");
>> -	for (ent = dir ? readdir(dir) : NULL; ent; ent = readdir(dir)) {
>> +	if (!dir)
>> +		return 1;
>> +
>
> Returning '1' looks really weird here.  I can see it is consistent with
> 	if (hba->type != SYS_DEV_VMD)
> 		return 1;
>
> above, but still....
> As the return value is never used, should we just make it 'void' ??

Seems reasonable - I'll put that in a separate patch.

Cheers,
Jes
