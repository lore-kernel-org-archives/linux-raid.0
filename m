From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Unable to grow RAID 6 array
Date: Wed, 18 May 2011 08:58:28 +0100
Message-ID: <4DD37C24.6040307@anonymous.org.uk>
References: <20110518092327.airaicao@trusted.unix-scripts.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110518092327.airaicao@trusted.unix-scripts.info>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
Cc: Laurent CARON <lcaron@unix-scripts.info>
List-Id: linux-raid.ids

On 18/05/2011 08:31, Laurent CARON wrote:
> Hi,
>
> I'm basically trying to grow a RAID-6 array (5 disks).
>
> I did change the disks one by one (change, rebuild, ...).
>
> I finally did delete the last partition (the one I wanted to enlarge and
> recreated it with the exactly same start but different end).
>
> When I try to grow the array, I get:
>
> # mdadm --grow --size max /dev/md2
> mdadm: component size of /dev/md2 has been set to 732458496K
[...]
>
> If any of you can help me to sort this out It would be nice.

You need to tell mdadm the underlying devices have grown; do this by 
stopping the array then assembling it again with --update=devicesize. 
Then when you --grow --size max you will get the result you are looking for.

Cheers,

John.

