From: Brian McKee <brian@soulspark.org>
Subject: Re: Raid5 Array stopped suddenly, no apparent error messages.
Date: Thu, 10 May 2012 08:50:48 -0700
Message-ID: <4FABE3D8.1060403@soulspark.org>
References: <4FAAB2B8.6090403@soulspark.org> <4FAB93F6.2030700@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FAB93F6.2030700@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

John,

Your intuition was right on. The log shows that the ESATA link went down
around 2:40 PM. The kernel brought it back up, had problems, slowed it
to 1.5Gb/sec and then started chasing its own tail. I got a few Temp
Celsius and read error rate change messages during the ordeal.

mdadm -A --force /dev/md1 followed by fsck.ext4 /dev/md1 totally worked
and there were only two inode count wrong error messages.

Thanks much for taking the time to help me! I really appreciate it.

Brian

On 05/10/2012 03:09 AM, John Robinson wrote:
> On 09/05/2012 19:08, Brian McKee wrote:
>> If this is not a good place to ask for help, please point me to where I
>> can ask. Sorry if I offend.
>>
>> TL;DR: My question is this: is it safe to run mdadm --create
>> --assume-clean on an existing array? And by safe I mean: is it
>> guaranteed that the existing ext4 partition's data will not be lost when
>> I run the command?
>
> Any --create --assume-clean will only rewrite the metadata. You would
> need to get the command exactly right, specifying the chunk size,
> metadata type and member partitions in the right order in order to be
> able to see your filesystem. However...
>
> [...]
>> For more details you can read this gentoo thread:
>> http://forums.gentoo.org/viewtopic-p-7033578.html
>>
>> Summary: The three drives won't assemble because they are not fresh.
>
> I don't think you are seeing the recent kernel bug; you can see all
> the correct metadata on all your drives.
>
> The problem you have is that your member partitions have different
> event counts. You can force the assembly, ignoring the different event
> counts, with --assemble --force. You should then run a fsck as there
> may already be some corruption which occurred when the event counts
> got out of sync.
>
> You should also try to track down what caused the issue in the first
> place. Check your logs for ata errors.
>
> Cheers,
>
> John.
>

