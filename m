From: "Christian Pernegger" <pernegger@gmail.com>
Subject: Re: Problem with 3xRAID1 to RAID 0
Date: Wed, 12 Jul 2006 11:56:42 +0200
Message-ID: <bb145bd20607120256h3f67f3fcv4d04073a83ab4ca8@mail.gmail.com>
References: <44B3562B.7040801@vladoportos.sk>
	 <273427381.20060712120643@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <273427381.20060712120643@2ka.mipt.ru>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Are there any actual bonuses to making RAIDs on whole raw disks?

Not if you're using regular md devices.

For partitionable md arrays using partitions seems a little strange to
me, since you then have partitions on a partition. That'd probably
make it difficult to just mount a single member of a mirror for data
recovery, etc ...

And Neil seems to favour initrd over kernel auto-detection / assembly anyhow.

FWIW, I use whole disks and limit the space used per disk to exactly
the rated capacity, i. e. floor ( ( GB * 10^9 ) / 1024 ) blocks with
the --size parameter.

Regards,

C.
