From: Dirk Jagdmann <jagdmann@gmail.com>
Subject: Re: Creating RAID1 with "missing" - mdadm 1.90
Date: Sun, 6 Mar 2005 14:29:01 +0100
Message-ID: <5d0f6099050306052950914bad@mail.gmail.com>
References: <422A2FD1.2010106@panix.com>
Reply-To: Dirk Jagdmann <jagdmann@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
In-Reply-To: <422A2FD1.2010106@panix.com>
Sender: linux-raid-owner@vger.kernel.org
To: berk walker <berk@panix.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have successfully set up a raid1 in degraded mode with this command line:

mdadm --create /dev/md0 --level=1 --raid-devices=2 missing /dev/hda2

I have experienced problems when the "missing" drive was the second
and the array would not initialize correctly when a real disk was
added later. When "missing" is the first I did not have any problems.
(Those problems were with linux 2.4 kernels, maybe this is solved with
2.6, but I did had the opportunity to check yet)

-- 
---> Dirk Jagdmann
----> http://cubic.org/~doj
-----> http://llg.cubic.org
