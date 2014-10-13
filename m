From: Ram Ramesh <rramesh2400@gmail.com>
Subject: Re: mdadm --grow with --backup-file does not create backupfile?
Date: Sun, 12 Oct 2014 20:49:21 -0500
Message-ID: <543B2FA1.4030106@gmail.com>
References: <543B2A2D.9080407@gmail.com> <20141013123914.04b960ed@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20141013123914.04b960ed@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Good to know. Thanks.

Ramesh

On 10/12/2014 08:39 PM, NeilBrown wrote:
> On Sun, 12 Oct 2014 20:26:05 -0500 Ram Ramesh <rramesh2400@gmail.com> wrote:
>
>> I added a new disk and grew my raid6 md0 with the following command line
>>
>>      sudo mdadm --grow --raid-devices=5
>>      --backup-file=/root/grow_md0.bkp_file --layout=normalise /dev/md0
>>
>> I got a response that stated that mdadm needed to backup 384K of data.
>> However, when I checked after about 5min there was no backup file. Is
>> this expected?
> Yes.
>
> When increasing the size of an array, the backup file is needed  for a tiny
> fraction of a second at the start.
> When decreasing the size it is needed  for a tiny fraction if a second at the
> end.
> When the size isn't changed it is needed for the entire time.
>
> ... unless you have a new kernel and a new mdadm, and then the backup file
> isn't needed.
>
> NeilBrown
>
>
>
>>      386 > sudo ls /root
>>      <no files. so no output>
>>      387 > sudo ls /root/grow_md0.bkp_file
>>      ls: cannot access /root/grow_md0.bkp_file: No such file or directory
>>
>> Ramesh
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

