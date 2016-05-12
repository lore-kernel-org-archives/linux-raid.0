From: Phil Turmel <philip@turmel.org>
Subject: Re: recovering failed and unrecognizable RAID5 during mdadm --grow
 without backup
Date: Thu, 12 May 2016 16:23:19 -0400
Message-ID: <5734E637.6030307@turmel.org>
References: <1b26650f-0b2c-2485-f781-e3fd26340741@misalpina.net>
 <5734D23D.6030400@turmel.org>
 <f06998d6-8e1e-c8ea-a22c-1307935092c3@misalpina.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f06998d6-8e1e-c8ea-a22c-1307935092c3@misalpina.net>
Sender: linux-raid-owner@vger.kernel.org
To: Claudiu Rad-Lohanel <jazzman@misalpina.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 05/12/2016 04:09 PM, Claudiu Rad-Lohanel wrote:
> 
> 
> On 5/12/2016 9:58 PM, Phil Turmel wrote:
>> Please show the examine for the individual partitions of the raid5:
>>
>> mdadm --examine /dev/sd[a-d]3
>>
> 
> root@rescue ~ # mdadm --examine /dev/sd[a-d]3
> /dev/sda3:

Ok.  Nothing outlandish.

>> You will need to manually assemble (not create !) your array with a
>> backup file outside the raid5, and the --invalid-backup option to
>> abandon the backup file you can't get to.  You will likely have some
>> unavoidable corruption at the reshape position due to this.
> 
> i am waiting for your input on this and how to continue. it seems that i
> actually set new chunk size to 64K not 128K as i was remembering.
> clearly i wasn't with a clear mind when i did all this..
> should i be worried that reshape position is so at the beginning of the
> volume? maybe LVM vg0 metadata lost? (i am just assuming, don't know
> much about how and where LVM stores info about its volumes).

It just didn't get very far.

> the backup file is there, inside the array, if i could reach it somehow
> i could feed it to mdadm and would probably go well afterwards.

No way to get to it without assembling, and you can't assemble
error-free without it.  Sorry.

> anyway, if just data is lost, i don't care, what are really important
> are some LVM volumes probably placed much further inside the array.

They are likely to be fine, then.

> thank you phil!

You're welcome.

You should mount your /boot array somewhere convenient, then:

mdadm -Av /dev/md3 --invalid-backup \
  --backup-file=/mount/path/to/boot/newbackupfile \
  /dev/sd[a-d]3

If that fails, repeat with the --force option included.  If that fails,
show us everything it prints out.

If it succeeds, the reshape will be continuing in the background.  While
that is going on, you may mount the array and grab backups of the most
critical content.  Just in case :-)

It will probably take a very long time.  Look at /proc/mdstat to check
the progress.

Phil

