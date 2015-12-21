From: Xiao Ni <xni@redhat.com>
Subject: Re: [PATCH] mdadm: check bitmap first when reshape raid1 to raid0
Date: Mon, 21 Dec 2015 14:00:58 +0800
Message-ID: <5677959A.3030107@redhat.com>
References: <1446510328-22917-1-git-send-email-xni@redhat.com>
 <87y4co4ixe.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87y4co4ixe.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <nfbrown@novell.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 12/21/2015 10:47 AM, NeilBrown wrote:
> On Tue, Nov 03 2015, Xiao Ni wrote:
>
>> One raid1 with bitmap is composed by 4 disks. It'll fail when rashape
>> to raid0 and lose 3 disks. It should check bitmap first when reshape
>> raid1 to raid0.
>>
>> And need to free subarray, close cfd in Grow_reshape.
>>
>> It can't remove bitmap in Grow_reshape, because it's already frozen. I
>> think it should not unfreeze in the process of the function. So I just
>> test the bitmap.
> I don't find this acceptable, sorry.
> If mdadm it asked the change the level from raid1 to raid0 it should do
> that, unless it is dangerous or impossible.
> Removing a bitmap is neither dangerous nor impossible.  To just do it.
>
> I would probably put a test in before freezing the array.
>   if array has a bitmap and a request was made to change the level to
>   raid0, then remove the bitmap.
>
> It that so hard?

I focused my attention on the codes nearby the place where I modified.
It's easy to do this and I'll re-send it.
>
> Also you patch does multiple different things, some of which weren't
> explained at all in the comment above.

I'll give more comments for them.
>
> In particlar, the change to mdadm.c is completely pointless.
> It seems to just be adding a 'close' call before 'exit'.
> As 'exit' implicitly closes all file descriptors there is nothing to be
> gained by closing anything immediately before calling exit.

Hmm, I know this. I just thought it maybe better to call close in pairs
with open. Yes, as you said, it's really pointless.
>
> Thanks,
> NeilBrown
>
>
>> Signed-off-by: Xiao Ni <xni@redhat.com>
>> ---
>>   Grow.c  | 45 ++++++++++++++++++++++++++++-----------------
>>   mdadm.c | 16 ++++++++++++----
>>   2 files changed, 40 insertions(+), 21 deletions(-)
>>
>> diff --git a/Grow.c b/Grow.c
>> index 80d7b22..c4ea2a5 100644
>> --- a/Grow.c
>> +++ b/Grow.c
>> @@ -1600,15 +1600,14 @@ int Grow_reshape(char *devname, int fd,
>>   			cfd = open_dev_excl(st->container_devnm);
>>   		} else {
>>   			container = st->devnm;
>> -			close(fd);
>>   			cfd = open_dev_excl(st->devnm);
>>   			fd = cfd;
>>   		}
>>   		if (cfd < 0) {
>>   			pr_err("Unable to open container for %s\n",
>>   				devname);
>> -			free(subarray);
>> -			return 1;
>> +			rv = 1;
>> +			goto release;
>>   		}
>>   
>>   		rv = st->ss->load_container(st, cfd, NULL);
>> @@ -1616,8 +1615,8 @@ int Grow_reshape(char *devname, int fd,
>>   		if (rv) {
>>   			pr_err("Cannot read superblock for %s\n",
>>   				devname);
>> -			free(subarray);
>> -			return 1;
>> +			rv = 1;
>> +			goto release;
>>   		}
>>   
>>   		/* check if operation is supported for metadata handler */
>> @@ -1641,8 +1640,8 @@ int Grow_reshape(char *devname, int fd,
>>   					pr_err("cannot reshape arrays in container with unsupported metadata: %s(%s)\n",
>>   					       devname, container);
>>   					sysfs_free(cc);
>> -					free(subarray);
>> -					return 1;
>> +					rv = 1;
>> +					goto release;
>>   				}
>>   			}
>>   			sysfs_free(cc);
>> @@ -1662,7 +1661,8 @@ int Grow_reshape(char *devname, int fd,
>>   		       s->raiddisks - array.raid_disks,
>>   		       s->raiddisks - array.raid_disks == 1 ? "" : "s",
>>   		       array.spare_disks + added_disks);
>> -		return 1;
>> +		rv = 1;
>> +		goto release;
>>   	}
>>   
>>   	sra = sysfs_read(fd, NULL, GET_LEVEL | GET_DISKS | GET_DEVS
>> @@ -1675,17 +1675,18 @@ int Grow_reshape(char *devname, int fd,
>>   	} else {
>>   		pr_err("failed to read sysfs parameters for %s\n",
>>   			devname);
>> -		return 1;
>> +		rv = 1;
>> +		goto release;
>>   	}
>>   	frozen = freeze(st);
>>   	if (frozen < -1) {
>>   		/* freeze() already spewed the reason */
>> -		sysfs_free(sra);
>> -		return 1;
>> +		rv = 1;
>> +		goto release;
>>   	} else if (frozen < 0) {
>>   		pr_err("%s is performing resync/recovery and cannot be reshaped\n", devname);
>> -		sysfs_free(sra);
>> -		return 1;
>> +		rv = 1;
>> +		goto release;
>>   	}
>>   
>>   	/* ========= set size =============== */
>> @@ -1898,11 +1899,16 @@ size_change_error:
>>   	     array.layout == ((1 << 8) + 2) && !(array.raid_disks & 1)) ||
>>   	    (s->level == 0 && array.level == 1 && sra)) {
>>   		int err;
>> +		
>> +		if (array.state & (1<<MD_SB_BITMAP_PRESENT)) {
>> +		        pr_err("Bitmap must be removed before level can be changed\n");
>> +		        rv = 1;
>> +		        goto release;
>> +		}
>> +
>>   		err = remove_disks_for_takeover(st, sra, array.layout);
>>   		if (err) {
>> -			dprintf("Array cannot be reshaped\n");
>> -			if (cfd > -1)
>> -				close(cfd);
>> +			pr_err("Array cannot be reshaped\n");
>>   			rv = 1;
>>   			goto release;
>>   		}
>> @@ -2078,9 +2084,14 @@ size_change_error:
>>   		frozen = 0;
>>   	}
>>   release:
>> -	sysfs_free(sra);
>>   	if (frozen > 0)
>>   		unfreeze(st);
>> +	if (sra)
>> +		sysfs_free(sra);
>> +	if (cfd > -1)
>> +		close(cfd);
>> +	if (subarray)
>> +		free(subarray);
>>   	return rv;
>>   }
>>   
>> diff --git a/mdadm.c b/mdadm.c
>> index f56a8cf..95db2a0 100644
>> --- a/mdadm.c
>> +++ b/mdadm.c
>> @@ -1299,7 +1299,8 @@ int main(int argc, char *argv[])
>>   			pr_err("'1' is an unusual number of drives for an array, so it is probably\n"
>>   				"     a mistake.  If you really mean it you will need to specify --force before\n"
>>   				"     setting the number of drives.\n");
>> -			exit(2);
>> +			rv = 2;
>> +			goto release;
>>   		}
>>   	}
>>   
>> @@ -1326,13 +1327,15 @@ int main(int argc, char *argv[])
>>   			rv = get_cluster_name(&c.homecluster);
>>   		if (rv) {
>>   			pr_err("The md can't get cluster name\n");
>> -			exit(1);
>> +			rv = 1;
>> +			goto release;
>>   		}
>>   	}
>>   
>>   	if (c.backup_file && data_offset != INVALID_SECTORS) {
>>   		pr_err("--backup-file and --data-offset are incompatible\n");
>> -		exit(2);
>> +		rv = 2;
>> +		goto release;
>>   	}
>>   
>>   	if ((mode == MISC && devmode == 'E')
>> @@ -1340,7 +1343,8 @@ int main(int argc, char *argv[])
>>   		/* Anyone may try this */;
>>   	else if (geteuid() != 0) {
>>   		pr_err("must be super-user to perform this action\n");
>> -		exit(1);
>> +		rv = 1;
>> +		goto release;
>>   	}
>>   
>>   	ident.autof = c.autof;
>> @@ -1640,6 +1644,10 @@ int main(int argc, char *argv[])
>>   		autodetect();
>>   		break;
>>   	}
>> +
>> +release:
>> +	if (mdfd > -1)
>> +		close(mdfd);
>>   	exit(rv);
>>   }
>>   
>> -- 
>> 1.8.3.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

