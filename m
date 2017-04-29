From: Ram Ramesh <rramesh2400@gmail.com>
Subject: Re: How important is SCTERC?
Date: Sat, 29 Apr 2017 18:45:38 -0500
Message-ID: <64b80fbc-8ee9-c137-3da5-fffc563a7a6d@gmail.com>
References: <48135126-cd8e-6321-77e6-06ae349ecc03@gmail.com>
 <22787.16039.574815.87299@tree.ty.sabi.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <22787.16039.574815.87299@tree.ty.sabi.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Grandi <pg@lxra2.for.sabi.co.UK>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 04/28/2017 08:07 AM, Peter Grandi wrote:
>> [ ... ] I do run tler.sh that sets 180s timeout for drives
>> that do not have scterc from /etc/rc.local. Am I putting my
>> data in serious danger?
> No.
>
>> I only have videos and tv recordings in this md
> The problem with SCT/ERC absence is that the 2-3 minutes of
> retries suspend IO for that long, and for people running
> interactive applications (usually LAMP-style web applications)
> that is a bad idea, but in your case you seem to have just a
> personal archive of entertainment files.
>
> For interactive "enterprise" applications the common practice is
> to reduce the error timeout to 1-2 seconds, so the failing drive
> drops out of the MD set quickly and can be replaced, minimizing
> delays.
Interestingly, the drives did not pass SMART test and mkfs.ext4 -c -c  
checks. So, I returned them. I plan to buy WD gold (the other extreme in 
price point :-)
>
>> which can be replaced with significant effort (about 12TB of
>> movies and tv shows will take some time to copy from my
>> DVDs/BDs)
> Backups are very important, and RAID is not an alternative to
> backups. You can buy and use SMR disk drives as if they were
> tapes (or with a filesystem like NILFS2) to do that backup, and
> they are quite cheap.
I am using my actual DVDs as backup. For TV shows they are available in 
Netflix, if I really want to watch them again.
However, your point is well taken. I will think about backup as my 
collection has grown over the years and it will be really a pain to go 
back to DVDs to populate my media server.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


