From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: Re: [PATCH 1/7] imsm: metadata changes for PPL
Date: Tue, 29 Nov 2016 11:47:59 +0100
Message-ID: <f4ded4a5-abf2-f988-f5d0-7063f5d080d1@intel.com>
References: <20161124122952.16529-1-artur.paszkiewicz@intel.com>
 <20161124122952.16529-2-artur.paszkiewicz@intel.com>
 <wrfjpolfjibn.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <wrfjpolfjibn.fsf@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/29/2016 12:27 AM, Jes Sorensen wrote:
> Artur Paszkiewicz <artur.paszkiewicz@intel.com> writes:
>> Updates for the IMSM metadata format, including PPL header structures.
>>
>> Extend imsm_vol dirty field adding a third value, which is required to
>> enable PPL recovery in Windows and UEFI drivers.
>>
>> Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
>> ---
>>  super-intel.c | 48 ++++++++++++++++++++++++++++++++++++++++--------
>>  1 file changed, 40 insertions(+), 8 deletions(-)
> 
> A couple of comments on this change:
> 
>> diff --git a/super-intel.c b/super-intel.c
>> index 5740088..69f6201 100644
>> --- a/super-intel.c
>> +++ b/super-intel.c
>> @@ -154,6 +157,9 @@ struct imsm_vol {
>>  #define MIGR_STATE_CHANGE 4
>>  #define MIGR_REPAIR 5
>>  	__u8  migr_type;	/* Initializing, Rebuilding, ... */
>> +#define RAIDVOL_CLEAN          0
>> +#define RAIDVOL_DIRTY          1
>> +#define RAIDVOL_DSRECORD_VALID 2
>>  	__u8  dirty;
>>  	__u8  fs_state;		/* fast-sync state for CnG (0xff == disabled) */
>>  	__u16 verify_errors;	/* number of mismatches */
>> @@ -189,7 +195,30 @@ struct imsm_dev {
>>  	__u16 cache_policy;
>>  	__u8  cng_state;
>>  	__u8  cng_sub_state;
>> -#define IMSM_DEV_FILLERS 10
>> +	__u16 my_vol_raid_dev_num; /* Used in Unique volume Id for this RaidDev */
>> +
>> +	/* NVM_EN */
>> +	__u8 nv_cache_mode;
>> +	union {
>> +		__u8 nv_cache_flags;
>> +		struct {
>> +		    __u8 dirty:1; /* 1 - cache is dirty, 0 - clean */
>> +		    __u8 nvc_health:2;
>> +		    __u8 expansion_bytes:5;
>> +		} nvCache;
>> +	};
> 
> This sets off alarm bells here - you declare a union of a u8 and a
> matching bitfield, but do not handle bit endian bitfields. If someone
> tried to use this on a big endian system this could get messy.

Those fields are not used in the code at all, the only thing added to
this structure that is used is 'rwh_policy'. The rest is to fill the
gaps between IMSM format in UEFI/Windows.

> 
>> @@ -7565,12 +7594,15 @@ mark_checkpoint:
>>  
>>  skip_mark_checkpoint:
>>  	/* mark dirty / clean */
>> -	if (dev->vol.dirty != !consistent) {
>> +	if ((dev->vol.dirty & RAIDVOL_DIRTY) != !consistent) {
> 
> This part makes my head spin (to be honest, the original code did
> too). I had to go write a small snipped of C to figure out what the
> compiler does with !x given x > 0, since consistent can be 0, 1, and 2
> here.
> 
> Basically for RAIDVOL_CLEAN and consistent = 0, and RAIDVOL_DIRTY and
> consistent = 1 and 2, this statement triggers. Maybe I am just terrible
> dense when it comes to reading obfuscated C, but could we change this
> round to a construct that is a little easier to read?

Yes, I admit it is confusing. Does this look better?

-       if (dev->vol.dirty != !consistent) {
+       if (((dev->vol.dirty & RAIDVOL_DIRTY) && consistent) ||
+           (!(dev->vol.dirty & RAIDVOL_DIRTY) && !consistent)) {

Thanks,
Artur

