From: David Greaves <david@dgreaves.com>
Subject: Re: RAID5 - 2nd drive died whilst waiting for RMA
Date: Fri, 12 Nov 2004 17:31:58 +0000
Message-ID: <4194F38E.5060703@dgreaves.com>
References: <41948B65.3090504@dgreaves.com> <41948B65.3090504@dgreaves.com> <4194A9E9.70003@dgreaves.com> <6775.4194e357.6922c@altium.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6775.4194e357.6922c@altium.nl>
Sender: linux-raid-owner@vger.kernel.org
To: Dick Streefland <dick.streefland@altium.nl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dick Streefland wrote:

>David Greaves <david@dgreaves.com> wrote:
>| so, the plan in order to try and extract data:
>| * insert new drive as /dev/sdd1
>| * dd if=/dev/sda1 of=/dev/sdd1
>| * mdadm /dev/md0 --remove /dev/sda1
>| * physically swap /dev/sda and /dev/sdd so /dev/sdd
>| * mdadm /dev/md0 --add /dev/sda1
>| * fsck filesystem and expect to lose files where there were bad blocks
>| * wait for new drive (special delivery - tomorrow morning)
>| * insert new drive as /dev/sdd
>| * mdadm /dev/md0 --add /dev/sdd1
>
>You might want to check out "ddrescue", which is a version of "dd"
>that is designed to read from a disk with bad sectors.
>  
>
That was it - thanks :)

I was googling 'dd recover' and various 'badblocks' etc... not 'dd rescue'

Also found dd_rhelp which looks sensible.

fingers crossed that it works...

David

