From: Nigel Croxon <ncroxon@redhat.com>
Subject: Re: [PATCH V2] allow RAID5 to grow to RAID6 with a backup_file
Date: Fri, 8 May 2020 10:50:46 -0400
Message-ID: <2b7c4bbd-8bfd-e33b-ca52-0cb3385d46f1@redhat.com>
References: <20200505183545.26291-1-ncroxon@redhat.com>
 <8a30b584-753c-abff-634a-7dda8a2e3e27@trained-monkey.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8a30b584-753c-abff-634a-7dda8a2e3e27@trained-monkey.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <jes@trained-monkey.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On 5/8/20 10:01 AM, Jes Sorensen wrote:
> On 5/5/20 2:35 PM, Nigel Croxon wrote:
>> This problem came in, as the user did not specify a full path with
>> the backup_file option when growing an RAID5 array to RAID6.
>> When the full path is specified, the symbolic link is created
>> properly (/run/mdadm/backup_file-mdX). But the code did not support
>> the symbolic link when looking for the backup_file. Added two
>> checks for symlink.
>>
>> This addresses https://www.spinics.net/lists/raid/msg48910.html
>> and numerous customer reported problems.
>>
>> V2:
>> - Removed unneeded break; in both case-statements
>> - Returned the error checking on call to lstat
>>
>> Signed-off-by: Nigel Croxon <ncroxon@redhat.com>
>> ---
>>   Grow.c | 21 +++++++++++++++++++--
>>   1 file changed, 19 insertions(+), 2 deletions(-)
>>
>> diff --git a/Grow.c b/Grow.c
>> index 764374f..53245d7 100644
>> --- a/Grow.c
>> +++ b/Grow.c
>> @@ -1135,6 +1135,15 @@ int reshape_open_backup_file(char *backup_file,
>>   	unsigned int dev;
>>   	int i;
>>   
>> +	if (lstat(backup_file, &stb) != -1) {
>> +		switch (stb.st_mode & S_IFMT) {
>> +		case S_IFLNK:
>> +			return 1;
>> +		default:
>> +			break;
>> +		}
>> +	}
>> +
> Sorry for being a pita on this, but in this case you do the thing if the
> lstat completes correctly, but what if it fails? In that case we should
> error out rather than just continuing.
>
> Jes
>
There are two processes running in the reshape_array routine, the 
original, where the user entered the mdadm grow parameter. And the 
second, forked to call systemd mdadm-grow-continue@service.  It's in the 
original call we want the code to continue rather than fail. It needs to 
create the backup_file in the FS before the systemd thread runs.

-Nigel
