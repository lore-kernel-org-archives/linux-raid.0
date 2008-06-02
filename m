From: "Jon Nelson" <jnelson-linux-raid@jamponi.net>
Subject: Re: Awful Raid10,f2 performance
Date: Mon, 2 Jun 2008 10:09:46 -0500
Message-ID: <cccedfc60806020809t73794ce6w539c6b0d247a264f@mail.gmail.com>
References: <cccedfc60806020711o39ccd321h5e410c963d8bf3b1@mail.gmail.com>
	 <48440953.3040004@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <48440953.3040004@wpkg.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: Linux-Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

i can't show you raw write values, but I can show you raw read values
(after dropping the caches):

From dstat, this shows disks sdb, sdc, and sdd values in read (space)
write format, with the total on the end.

Thus:

  70M    0 :  71M    0 :  72M    0 : 213M    0
  71M    0 :  70M    0 :  69M    0 : 210M    0
  71M    0 :  73M    0 :  74M    0 : 217M    0

shows that I'm getting 70+- MB/s on each disk, combined to 210 to 217MB/s.
These are read values.

I created a logical volume (50G), dropped the caches again, and issued:

dd if=/dev/zero of=/dev/raid/test bs=64k

and got from 100 to 150MB/s sustained write speeds.
NOTE: this is with a bitmap (internal)
Without a bitmap (removed for this test), I get a much more consistent
130-150MB/s.
dd reports a mere 70MB/s when complete.
When using oflag=direct, I get about 100MB/s combined, with a
"reported" speed of 51.9MB/s.
Since I'm using 3x drives, my total I/O is going to be about 2x what dd "sees".

Does that help?

-- 
Jon
