From: David Greaves <david@dgreaves.com>
Subject: Re: RAID5 - 2nd drive died whilst waiting for RMA
Date: Fri, 12 Nov 2004 18:13:31 +0000
Message-ID: <4194FD4B.60306@dgreaves.com>
References: <200411121749.iACHnKN01022@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200411121749.iACHnKN01022@www.watkins-home.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guy <bugzilla@watkins-home.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks Guy :)

Nothing at all.
I haven't rebooted; I haven't attempted any dd's

The only think I've done is stop the monitor:
  /etc/init.d/mdadm stop

and see what's up
  cat /proc/mdstat
and run
  mdadm --display /dev/md0

I'm preparing linux-2.6.9 (currently running 2.6.6).

I've ordered another 250Gb disk and a basic Sil-Img 2xSATA controller 
that should be here in the morning so I'm not planning on doing anything 
until then.

I've been reading up on dd_rescue and dd_rhelp too.
They're now installed and waiting.

David


Guy wrote:

>Let me know what you have done so far.
>
>Guy
>
>-----Original Message-----
>From: linux-raid-owner@vger.kernel.org
>[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of David Greaves
>Sent: Friday, November 12, 2004 12:32 PM
>To: Dick Streefland
>Cc: linux-raid@vger.kernel.org
>Subject: Re: RAID5 - 2nd drive died whilst waiting for RMA
>
>Dick Streefland wrote:
>
>  
>
>>David Greaves <david@dgreaves.com> wrote:
>>| so, the plan in order to try and extract data:
>>| * insert new drive as /dev/sdd1
>>| * dd if=/dev/sda1 of=/dev/sdd1
>>| * mdadm /dev/md0 --remove /dev/sda1
>>| * physically swap /dev/sda and /dev/sdd so /dev/sdd
>>| * mdadm /dev/md0 --add /dev/sda1
>>| * fsck filesystem and expect to lose files where there were bad blocks
>>| * wait for new drive (special delivery - tomorrow morning)
>>| * insert new drive as /dev/sdd
>>| * mdadm /dev/md0 --add /dev/sdd1
>>
>>You might want to check out "ddrescue", which is a version of "dd"
>>that is designed to read from a disk with bad sectors.
>> 
>>
>>    
>>
>That was it - thanks :)
>
>I was googling 'dd recover' and various 'badblocks' etc... not 'dd rescue'
>
>Also found dd_rhelp which looks sensible.
>
>fingers crossed that it works...
>
>David
>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>  
>

