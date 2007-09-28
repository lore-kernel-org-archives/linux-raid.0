From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Backups w/ rsync
Date: Fri, 28 Sep 2007 12:50:43 -0400
Message-ID: <46FD30E3.7090809@tmr.com>
References: <20070928145718.7320C24769@gemini.denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070928145718.7320C24769@gemini.denx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Wolfgang Denk <wd@denx.de>
Cc: "Dean S. Messing" <deanm@sharplabs.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Wolfgang Denk wrote:
> Dear Bill,
>
> in message <46FD1442.70707@tmr.com> you wrote:
>   
>> Be aware that rsync is useful for making a *copy* of your files, which 
>> isn't always the best backup. If the goal is to preserve data and be 
>> able to recover in time of disaster, it's probably not optimal, while if 
>> you need frequent access to old or deleted files it's fine.
>>     
>
> If you want to do real backups you should use real tools, like bacula
> etc.
>
>   
>> Now you can do an incremental (since last full or incremental) or 
>> partial (since last full):
>>
>>     touch bkup_incr_new
>>     timestamp=$(date +%Y%m%d-%T)
>>     find /home -cnewer bkup_incr | cpio -o -Hcrc |
>>        gzip -3 >/mnt/USBbkup/incr-$timestamp &&
>>        mv -f bkup_incr_new bkup_incr
>>
>>     timestamp=$(date +%Y%m%d-%T)
>>     find /home -cnewer bkup_full  | cpio -o -Hcrc |
>>        gzip -3 >/mnt/USBbkup/part-$timestamp
>>     
>
> Now have Johnny Loser downloading some stuff, say:
>
> 	$ wget -N ftp://ftp.kernel.org/pub/linux/kernel/v2.6/linux-2.6.12.tar.gz
>
> Are you aware that this file will never be backed up by your script?
>
> Also, what about permission / owner changes etc.?
>   

Do note the use of -cnewer, which is *not* the same as the modified 
time, and which exactly addresses your points. Ownership changes, etc, 
will causes a backup of the contents as well, but they will be preserved.
> A backup tool should never work based on timestamps alone.
>   

Feel free to use a tool which does a checksum of every file if you feel 
it's needed on your system. I'm not trying to defend against people 
playing with ctime or system time of day, just protect normal day-to-day 
data.
> Best regards,
>
> Wolfgang Denk
>
>   
-- 

bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

