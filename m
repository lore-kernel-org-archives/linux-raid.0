From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: Re: [PATCH v3 3/6] imsm: PPL support
Date: Mon, 20 Mar 2017 09:07:27 +0100
Message-ID: <b63748c5-0cdc-d332-e4d1-601f7c86ff80@intel.com>
References: <20170316210948.21093-1-artur.paszkiewicz@intel.com>
 <20170316210948.21093-4-artur.paszkiewicz@intel.com>
 <wrfj4lyrk6je.fsf@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <wrfj4lyrk6je.fsf@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: jes.sorensen@gmail.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 03/17/2017 09:11 PM, jes.sorensen@gmail.com wrote:
> Artur Paszkiewicz <artur.paszkiewicz@intel.com> writes:
>> Enable creating and assembling IMSM raid5 arrays with PPL. Update the
>> IMSM metadata format to include new fields used for PPL.
>>
>> Add structures for PPL metadata. They are used also by super1 and shared
>> with the kernel, so put them in md_p.h.
>>
>> Write the initial empty PPL header when creating an array. When
>> assembling an array with PPL, validate the PPL header and in case it is
>> not correct allow to overwrite it if --force was provided.
>>
>> Write the PPL location and size for a device to the new rdev sysfs
>> attributes 'ppl_sector' and 'ppl_size'. Enable PPL in the kernel by
>> writing to 'consistency_policy' before the array is activated.
>>
>> Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
>> ---
>>  Assemble.c    |  49 +++++++++++
>>  Makefile      |   5 +-
>>  md_p.h        |  25 ++++++
>>  mdadm.h       |   6 ++
>>  super-intel.c | 274 +++++++++++++++++++++++++++++++++++++++++++++++++++++-----
>>  sysfs.c       |  14 +++
>>  6 files changed, 349 insertions(+), 24 deletions(-)
>>
>> diff --git a/Assemble.c b/Assemble.c
>> index 3da09033..8e55b49f 100644
>> --- a/Assemble.c
>> +++ b/Assemble.c
>> @@ -1942,6 +1942,55 @@ int assemble_container_content(struct supertype *st, int mdfd,
>>  	map_update(NULL, fd2devnm(mdfd), content->text_version,
>>  		   content->uuid, chosen_name);
>>  
>> +	if (content->consistency_policy == CONSISTENCY_POLICY_PPL &&
>> +	    st->ss->validate_ppl) {
>> +		content->array.state |= 1;
>> +		err = 0;
>> +
>> +		for (dev = content->devs; dev; dev = dev->next) {
>> +			int dfd;
>> +			char *devpath;
>> +			int ret;
>> +
>> +			ret = st->ss->validate_ppl(st, content, dev);
>> +			if (ret == 0)
>> +				continue;
>> +
>> +			if (ret < 0) {
>> +				err = 1;
>> +				break;
>> +			}
>> +
>> +			if (!c->force) {
>> +				pr_err("%s contains invalid PPL - consider --force or --update-subarray with --update=no-ppl\n",
>> +					chosen_name);
>> +				content->array.state &= ~1;
>> +				avail[dev->disk.raid_disk] = 0;
>> +				break;
>> +			}
>> +
>> +			/* have --force - overwrite the invalid ppl */
>> +			devpath = map_dev(dev->disk.major, dev->disk.minor, 0);
>> +			dfd = dev_open(devpath, O_RDWR);
>> +			if (dfd < 0) {
>> +				pr_err("Failed to open %s\n", devpath);
>> +				err = 1;
>> +				break;
>> +			}
>> +
>> +			err = st->ss->write_init_ppl(st, content, dfd);
>> +			close(dfd);
>> +
>> +			if (err)
>> +				break;
>> +		}
>> +
>> +		if (err) {
>> +			free(avail);
>> +			return err;
>> +		}
>> +	}
>> +
>>  	if (enough(content->array.level, content->array.raid_disks,
>>  		   content->array.layout, content->array.state & 1, avail) == 0) {
>>  		if (c->export && result)
>> diff --git a/Makefile b/Makefile
>> index a6f464c3..49da491f 100644
>> --- a/Makefile
>> +++ b/Makefile
>> @@ -146,7 +146,7 @@ MON_OBJS = mdmon.o monitor.o managemon.o util.o maps.o mdstat.o sysfs.o \
>>  	Kill.o sg_io.o dlink.o ReadMe.o super-intel.o \
>>  	super-mbr.o super-gpt.o \
>>  	super-ddf.o sha1.o crc32.o msg.o bitmap.o xmalloc.o \
>> -	platform-intel.o probe_roms.o
>> +	platform-intel.o probe_roms.o crc32c.o
>>  
>>  MON_SRCS = $(patsubst %.o,%.c,$(MON_OBJS))
>>  
>> @@ -156,7 +156,8 @@ STATICOBJS = pwgr.o
>>  ASSEMBLE_SRCS := mdassemble.c Assemble.c Manage.c config.c policy.c dlink.c util.c \
>>  	maps.c lib.c xmalloc.c \
>>  	super0.c super1.c super-ddf.c super-intel.c sha1.c crc32.c sg_io.c mdstat.c \
>> -	platform-intel.c probe_roms.c sysfs.c super-mbr.c super-gpt.c mapfile.c
>> +	platform-intel.c probe_roms.c sysfs.c super-mbr.c super-gpt.c mapfile.c \
>> +	crc32c.o
> 
> Hi Artur,
> 
> This looks odd - sure you don't mean crc32c.c ?

Of course this is a mistake, it should be crc32c.c. Sorry for that. But
surprisingly it builds correctly.

Thanks,
Artur
