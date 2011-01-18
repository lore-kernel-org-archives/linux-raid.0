From: Wolfgang Denk <wd@denx.de>
Subject: Optimize RAID0 for max IOPS?
Date: Tue, 18 Jan 2011 22:01:12 +0100
Message-ID: <20110118210112.D13A236C@gemini.denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I'm going to replace a h/w based RAID system (3ware 9650SE) by a plain
s/w RAID0, because the existing system appears to be seriously limited
in terms of numbers of I/O operations per second.

Our workload is mixed read / write (something between 80% read / 20%
write and 50% / 50%), consisting of a very large number of usually
very small files.

There may be 20...50 millions of files, or more. 65% of the files are
smaller than 4 kB; 80% are smaller than 8 kB; 90% are smaller than 16
kB; 98.4% are smaller than 64 kB.

I will have 4 x 1 TB disks for this setup.

The plan is to build a RAID0 from the 4 devices, create a physical
volume and a volume group on the resulting /dev/md?, then create 2 or
3 logical volumes that will be used as XFS file systems.

My goal is to optimize for maximum number of I/O operations per
second. [I am aware that using SSDs would be a nice thing, but that
would be too expensive.]

Is this a reasonable approach for such a task?

Should I do anything different to acchive maximum performance?

What are the tunables in this setup?  [It seems the usual recipies are
more oriented in maximizing the data troughput for large, mostly
sequential accesses - I figure that things like increasing read-ahead
etc. will not help me much here?]

Thanks in advance.

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
Quote from a recent meeting:   "We are going to continue having these
meetings everyday until I find out why no work is getting done."
