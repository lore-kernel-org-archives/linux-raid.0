From: Brian Candler <b.candler@pobox.com>
Subject: Re: Using mdadm instead of dmraid for BIOS-RAID root volume
Date: Thu, 10 Oct 2013 09:11:02 +0100
Message-ID: <52566116.5020604@pobox.com>
References: <5253F7C2.2030401@pobox.com> <52541473.4020005@pobox.com> <52545092.1040001@arcor.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52545092.1040001@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Wilck <mwilck@arcor.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 08/10/2013 19:36, Martin Wilck wrote:
> On 10/08/2013 04:19 PM, Brian Candler wrote:
>>   > Anyway, I'm not so worried about having broken this machine, as it
>> needed a reinstall anyway, but I do wonder what would have been the
>> correct way to get mdraid instead of dmraid at boot time for this root
>> volume?
>>
>> After some more searching, it looks like the udev rules were nobbled to
>> disable this in
>> https://bugs.launchpad.net/ubuntu/+source/mdadm/+bug/1030292
>>
>> A possible way to re-enable is here:
>> https://bugs.launchpad.net/ubuntu/+source/mdadm/+bug/1054948/comments/9
>>
>> I'm a bit concerned about the issues around clean shutdown, and hence
>> whether is really production-ready yet.
> In general, this works. I have seen it work with CentOS, Fedora, and
> various SUSE distributions. It may require some work on Ubuntu's side.
>
>   1 The udev rules for incremental mdadm autoassembly need to be in
> place. The upstream rules should be fine. They can normally coexist with
> the rules for dmraid.
>   2 For shutdown, the distro must take care not to kill mdmon before file
> systems are unmounted, and to run mdadm --wait-clean after any write
> access to file systems is finished.
Details of what I tried for ubuntu, and the results, are at
https://bugs.launchpad.net/ubuntu/+source/mdadm/+bug/1054948/comments/16

Although it kind-of works, there are a lot of rough edges: most 
seriously, locking up during a shutdown. This isn't ready for production 
unfortunately.

Also, I tried booting Ubuntu 13.10beta2, and it is still using dmraid:
https://bugs.launchpad.net/ubuntu/+source/mdadm/+bug/1054948/comments/17

Regards,

Brian.

