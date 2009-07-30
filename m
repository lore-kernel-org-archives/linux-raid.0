From: Andy Bailey <andy@hazlorealidad.com>
Subject: Re: sdb failure - mdadm: no devices found for /dev/md0
Date: Wed, 29 Jul 2009 22:21:32 -0500
Message-ID: <1248924092.13147.241.camel@localhost.localdomain>
References: <1248711579.13147.75.camel@localhost.localdomain>
	 <1248786336.13147.172.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1248786336.13147.172.camel@localhost.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Please, can anyone help out with this problem.

Can anyone think of a possible reason why the UUID changed?

No command was run that I can imagine would change the UUID.
The only thing that I could see that possibly could change the UUID is
adding a partition that had previously been part of another partition,
without zeroing the superblock first. 

Also can anyone see why the system wouldnt boot without the
original /dev/sdb?

The /dev/sdb that replaced it had no partitions created on it, it was
brand new. Could that cause a problem?

And then why it then wouldnt boot with the original /dev/sdb?

Any guess, hypothesis will do, I need some ideas to investigate and find
out what happened and I have drawn a blank.

Or am I asking in the wrong mailing list, if so can somebody tell me the
correct mailing list to use.

Thanks

Andy Bailey 

