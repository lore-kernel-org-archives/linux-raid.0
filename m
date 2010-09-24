From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: How to remove non-existant device
Date: Fri, 24 Sep 2010 03:18:47 +0100
Message-ID: <4C9C0A87.6020406@anonymous.org.uk>
References: <20100923073029.GD19538@scavenger.homeip.net>	<4C9B5323.3020201@anonymous.org.uk> <20100924075449.26c7e59d@notabene>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100924075449.26c7e59d@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 23/09/2010 22:54, Neil Brown wrote:
> On Thu, 23 Sep 2010 14:16:19 +0100
> John Robinson<john.robinson@anonymous.org.uk>  wrote:
>> On 23/09/2010 08:30, Benjamin Schieder wrote:
[...]
>>> But now I can't remove the sda partitions from the RAID:
>>> kblhbe101:~ # mdadm /dev/md0 -r /dev/sda5
>>> mdadm: cannot find /dev/sda5: No such file or directory
>>> kblhbe101:~ # mdadm /dev/md0 -r sda5
>>> mdadm: cannot find sda5: No such file or directory
>>>
>>> What am I doing wrong here?
>>> kblhbe101:~ # mdadm --version
>>> mdadm - v2.6 - 21 December 2006
>>
>> Try `mdadm /dev/md0 -r missing`.
>
> Close.  "missing" is only meaningful with --re-add.
> You really want  "-r faileded" or "-r detached"

Bah. I knew it was something like that.

Cheers,

John.
