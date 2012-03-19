From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: How to update homehost of an existing raid component
Date: Mon, 19 Mar 2012 16:46:14 +0000
Message-ID: <4F6762D6.7040602@anonymous.org.uk>
References: <4F670361.6090902@ivitera.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F670361.6090902@ivitera.com>
Sender: linux-raid-owner@vger.kernel.org
To: Pavel Hofman <pavel.hofman@ivitera.com>
Cc: linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 19/03/2012 09:58, Pavel Hofman wrote:
> Hi,
>
> Please is there a way to update a homehost value for a specific raid
> component?

I don't think you need to.

[...]
> mdadm --verbose -A /dev/md7 --update=homehost --scan
>
> with no difference. Unfortunately I was not able to find how to change
> the homehost of md6 to be local to orfeus. I do not want to force adding
> md6 to the array and go through the whole rebuild since the data
> themselves are OK.

I don't think --assemble --scan will include /dev/md6 if the homehost 
doesn't match :-(

Try mdadm --verbose --assemble /dev/md7 --update=homehost /dev/md5 /dev/md6

And if that doesn't do the business, specify --homehost=orfeus

Cheers,

John.

