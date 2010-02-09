From: Dawning Sky <the.dawning.sky@gmail.com>
Subject: Re: Disk I/O error while rebuilding an md raid-5 array
Date: Tue, 9 Feb 2010 09:43:17 -0800
Message-ID: <adf93d751002090943x697cb222x3b80b53bae0a0f0a@mail.gmail.com>
References: <adf93d751002081523y1b9de656kdbba276b3dbc6af4@mail.gmail.com>
	 <87f94c371002081604g37984161h2ba65bd193714780@mail.gmail.com>
	 <4B714D92.2090802@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B714D92.2090802@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks to everyone for the good advices.  Currently I plan to build a
5x500GB raid-6 from new drives and restore the data from the backup.
I'm keeping the original set of 4 offline just in case I need to
recover anything from it.

I still have a couple of questions I hope someone can help me with.

1. Can I still add the original sde back to the raid-5?  While I was
doing rebuilding, I believe some files were modified by the OS and the
old sde would be out of sync.

2. Quite a few people talked about "scrubbing" the raid, can someone
point me to somewhere I can read more about it?  I'm new to the list.
I tried googling and reading the list wiki and had a hard time finding
a tutorial for setting this up.

Regards,

DS
