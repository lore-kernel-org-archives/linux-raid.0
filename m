From: John Robinson <john.robinson@yuiop.co.uk>
Subject: Re: Cannot auto assemble a raid1 array on boot
Date: Tue, 23 Oct 2012 19:44:12 +0100
Message-ID: <5086E57C.5020407@yuiop.co.uk>
References: <CAG9W8wBsh_i_jtqKFhEVywCk92hef41T0t+6J9saZD3CFT7V9A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAG9W8wBsh_i_jtqKFhEVywCk92hef41T0t+6J9saZD3CFT7V9A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jivko Sabev <jsabev@nicmus.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 18/10/2012 03:35, Jivko Sabev wrote:
> Greetings,
>
> I have a RAID1 array setup of the following
>
> /dev/md0 [linear raid array consisting of two 500GB SATA drives]
> /dev/md1  [RAID1 array consisting of /dev/md0 and one 1TB SATA drive]
>
> here is my /proc/mdstat
>
> --------
>
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
> [raid4] [raid10]
> md1 : active raid1 md0[0] sde1[2]
>        976639296 blocks super 1.2 [2/2] [UU]
>
> md0 : active linear sdb1[0] sdc1[1]
>        976770537 blocks super 1.2 0k rounding
>
> unused devices: <none>
>
>
> --------
>
> However, on every reboot, the md1 array is in degraded mode and I get
> dumped to a intramfs shell. I can then assemble the said array - i.e.
> mdadm --assemble /dev/md1 /dev/md0 /dev/sde1 and everything is fine.
> Is it possible to have such an array auto assembled and how?

I'm wondering why the slots for md1 are [0] and [2], and what happened 
to [1]?

It's possible you may need your mdadm.conf to mention
   DEVICE /dev/sd* /dev/md*

or something like that to make it work.

Also, your shutdown process perhaps needs to stop md1 and then md0 in 
that order, and your startup process needs to start md0 and then md1 in 
that order, i.e. you may need additional mdadm invocations to start and 
stop one array on top of another, and I'm not sure what distro, init 
scripts, udev scripts etc you have and whether they will do it all for you.

Cheers,

John.

-- 
John Robinson, yuiop IT services
0131 557 9577 / 07771 784 058
46/12 Broughton Road, Edinburgh EH7 4EE
