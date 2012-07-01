From: Jonathan Tripathy <jonnyt@abpni.co.uk>
Subject: Re: Resync Every Sunday
Date: Sun, 01 Jul 2012 21:44:34 +0100
Message-ID: <4FF0B6B2.1080808@abpni.co.uk>
References: <4FF0328B.5080103@abpni.co.uk> <58p6c9xfag.ln2@goaway.wombat.san-francisco.ca.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <58p6c9xfag.ln2@goaway.wombat.san-francisco.ca.us>
Sender: linux-raid-owner@vger.kernel.org
To: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On 01/07/2012 21:41, Keith Keller wrote:
> On 2012-07-01, Jonathan Tripathy<jonnyt@abpni.co.uk>  wrote:
>> What's going on? Am I missing something here? Is data on the arrays at
>> risk? We're using CentOS 5 with mdadm v2.6.9. Kernel version is
>> 2.6.18-274.18.1.el5
> As you are running CentOS, check /etc/sysconfig/raid-check.  Someone may
> have configured certain arrays not to be checked.
>
There is nothing in that file that suggests that some arrays should be 
skipped.

ENABLED=yes
CHECK=check
# To check devs /dev/md0 and /dev/md3, use "md0 md3"
CHECK_DEVS=""
REPAIR_DEVS=""
SKIP_DEVS=""

Thanks
