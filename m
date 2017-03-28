From: Liu Zhilong <zlliu@suse.com>
Subject: Re: [PATCH] mdadm/grow: reshape would be stuck from raid1 to raid5
Date: Tue, 28 Mar 2017 22:03:03 +0800
Message-ID: <f7244226-df7b-5a0c-855a-2e610ac113ed@suse.com>
References: <1489987229-22631-1-git-send-email-zlliu@suse.com>
 <wrfjk27aid6n.fsf@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <wrfjk27aid6n.fsf@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: jes.sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Harald Hoyer <harald@redhat.com>, shli@fb.com
List-Id: linux-raid.ids


On 03/28/2017 06:10 AM, jes.sorensen@gmail.com wrote:
> Zhilong Liu <zlliu@suse.com> writes:
>> it would be stuck at the beginning of reshape progress
>> when grows array from raid1 to raid5, correct the name
>> of mdadm-grow-continue@.service in continue_via_systemd.
>>
>> reproduce steps:
>> ./mdadm -CR /dev/md0 -l1 -b internal -n2 /dev/loop[0-1]
>> ./mdadm --grow /dev/md0 -l5 -n3 -a /dev/loop2
>>
>> Signed-off-by: Zhilong Liu <zlliu@suse.com>
>> ---
>>   Grow.c | 6 ++----
>>   1 file changed, 2 insertions(+), 4 deletions(-)
>>
>> diff --git a/Grow.c b/Grow.c
>> index 455c5f9..10c02a1 100755
>> --- a/Grow.c
>> +++ b/Grow.c
>> @@ -2808,13 +2808,11 @@ static int continue_via_systemd(char *devnm)
>>   		 */
>>   		close(2);
>>   		open("/dev/null", O_WRONLY);
>> -		snprintf(pathbuf, sizeof(pathbuf), "mdadm-grow-continue@%s.service",
>> -			 devnm);
>> +		snprintf(pathbuf, sizeof(pathbuf), "mdadm-grow-continue@.service");
> My memory is rusty here, isn't systemctl interpreting the device name in
> mdadm-grow-continue@<device>.service as an argument?

actually, the service started failed. paste the journalctl log here when 
reshape from mirror to raid5.

command: ./mdadm --grow /dev/md0 -l5 -n3 -a /dev/loop2

Mar 28 21:43:47 linux-g0sr kernel:  --- level:5 rd:3 wd:3
Mar 28 21:43:47 linux-g0sr kernel:  disk 0, o:1, dev:loop0
Mar 28 21:43:47 linux-g0sr kernel:  disk 1, o:1, dev:loop1
Mar 28 21:43:47 linux-g0sr kernel:  disk 2, o:1, dev:loop2
Mar 28 21:43:47 linux-g0sr kernel: md: reshape of RAID array md0
Mar 28 21:43:47 linux-g0sr kernel: md: minimum _guaranteed_  speed: 1000 
KB/sec/disk.
Mar 28 21:43:47 linux-g0sr kernel: md: using maximum available idle IO 
bandwidth (but not more than 2000 KB/sec) for reshape.
Mar 28 21:43:47 linux-g0sr kernel: md: using 128k window, over a total 
of 19968k.
Mar 28 21:43:47 linux-g0sr systemd[1]: Started Manage MD Reshape on 
/dev/md0.
Mar 28 21:43:47 linux-g0sr systemd[1]: mdadm-grow-continue@md0.service: 
Main process exited, code=exited, status=2/INVALIDARGUMENT
Mar 28 21:43:47 linux-g0sr systemd[1]: mdadm-grow-continue@md0.service: 
Unit entered failed state.
Mar 28 21:43:47 linux-g0sr systemd[1]: mdadm-grow-continue@md0.service: 
Failed with result 'exit-code'.
Mar 28 21:44:03 linux-g0sr kernel: md: md0: reshape interrupted.

>
>>   		status = execl("/usr/bin/systemctl", "systemctl",
>>   			       "start",
>>   			       pathbuf, NULL);
>> -		status = execl("/bin/systemctl", "systemctl", "start",
>> -			       pathbuf, NULL);
>> +		pr_err("/usr/bin/systemctl %s got failure\n", pathbuf);
>>   		exit(1);
> This assumes systemctl is location in /usr/bin only - you removed the
> fallback case for it being location in /bin.
>
> In addition, instead of saying 'got failure' lets do something with the
> errno value so the user gets a more descriptive error message.

I would continue to look at this issue, thanks for your time.

Thanks,
-Zhilong
> Cheers,
> Jes
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

