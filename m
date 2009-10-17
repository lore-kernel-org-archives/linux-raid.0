From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: best practice when using removable drives and USB enclosure?
Date: Sun, 18 Oct 2009 07:50:32 +1300
Message-ID: <4ADA11F8.90000@sauce.co.nz>
References: <2267211f0910162234s60f52e0pbf29b93bf7141da1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2267211f0910162234s60f52e0pbf29b93bf7141da1@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tim Bostrom <tbostrom@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Tim Bostrom wrote:

> SO..... I don't anticipate changing drives in and out of the last two
> open slots of my USB enclosure, but what would be the best practice
> for making sure md1 comes up at boot all the time without having to
> manually go into mdadm.conf and modify it back to /dev/sdh1 and
> /dev/sdi1 when I put a drive in the open drive slots?

Just remove the devices= entry; it is redundent when you are using UUID's.

mdadm.conf

ARRAY   /dev/md0 level=raid5 num-devices=4
UUID=cdaba8bd:80943c6a:ab2fedca:3ef56cfb
ARRAY   /dev/md1 level=raid1 num-devices=2
UUID=649526d8:828a57b4:ab2fedca:3ef56cfb


Regards,

Richard
