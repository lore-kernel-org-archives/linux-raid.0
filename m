From: "Filipe Maia" <fmaia@gmx.net>
Subject: Re: proactive raid5 related bug
Date: Thu, 12 Jan 2006 15:43:53 +0100
Message-ID: <op.s29sjfimi22er4@xray.bmc.uu.se>
References: <op.s29qvnb9i22er4@xray.bmc.uu.se>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <op.s29qvnb9i22er4@xray.bmc.uu.se>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Also if i do something like:

# grow bad blocks as ma*tor does :)
mdadm --grow -l faulty -p rp454 /dev/md2
mdadm --grow -l faulty -p rp738 /dev/md3

# add a spare
mdadm -a /dev/md5 /dev/ram5

mdadm -f /dev/md5 /dev/md2 && mdadm -f /dev/md5 /dev/md2


After the initial reconstruction i get this:
mdadm: set /dev/md2 faulty in /dev/md5
Segmentation fault

And then the computer enters in some kind of loop that makes it almost
completely unresponsive

-- 
All generalizations are false, including this one.
          -- Mark Twain
