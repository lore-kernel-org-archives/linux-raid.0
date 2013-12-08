From: "David C. Rankin" <drankinatty@suddenlinkmail.com>
Subject: Re: Raid1 where Event Count off my 1 cannot assemble --force
Date: Sun, 08 Dec 2013 11:57:37 -0600
Message-ID: <52A4B311.6040204@suddenlinkmail.com>
References: <52A44778.8040502@suddenlinkmail.com> <alpine.DEB.2.02.1312081157100.24602@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1312081157100.24602@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 12/08/2013 04:57 AM, Mikael Abrahamsson wrote:
> On Sun, 8 Dec 2013, David C. Rankin wrote:
> 
>> Guys,
>>
>>  I have an older box that is a fax server where the Event Count for /dev/md1 is
>> off by 1, but the array cannot be reassembled with --assemble --force /dev/dm1
>> /dev/sda5 /dev/sdb5.
> 
> What are the messages displayed in "dmesg" when you try to use this command?
> 

Mikael,

  Following the commands:

# mdadm --stop /dev/md1
# mdadm --assemble --force /dev/dm1 /dev/sd[ab]5

  The messages captured in the logs are:

Rescue Kernel: md: md1: stopped.
Rescue Kernel: md: unbind<sda5>
Rescue Kernel: md: export_rdev(sda5)
Rescue Kernel: md: unbind<sdb5>
Rescue Kernel: md: export_rdev(sdb5)
Rescue Kernel: md: md1: stopped.
Rescue Kernel: md: md1 raid array is not clean -- starting background reconstruction
Rescue Kernel: md: raid1: raid set md1 active with 2 out of 2 mirrors
Rescue Kernel: md1: bitmap file is out of date (148 < 149) -- forcing full recovery
Rescue Kernel: md1: bitmap file is out of date, doing full recovery
Rescue Kernel: md1: bitmap initialisation failed: -5
Rescue Kernel: md1: failed to create bitmap (-5)


  That's it for the log, then on the command line I have:

mdadm: failed to RUN_ARRAY /dev/md1: Input/Output error

  What should I try next? Don't hesitate to ask if you need any additional
information, I'll provide whatever is necessary. Thanks.

-- 
David C. Rankin, J.D.,P.E.
