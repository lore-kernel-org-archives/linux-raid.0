From: Ray Van Dolson <rayvd@digitalpath.net>
Subject: Loading i2o_proc and dpt_i2o at the same time?
Date: Tue, 24 Aug 2004 20:13:34 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040825031334.GA1235@digitalpath.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a running system using the dpt_i2o driver (loaded as a module) used in
tandem with an Adaptec 2100S SCSI RAID card.  I want to use the raidutils
package that apparently makes use of the i2o drivers available from
http://i2o.shadowconnect.com/  

I downloaded the raidutils RPM from the site and installed it (OS is Red Hat
8.0) but raidutil gives me the following error:

[root@pop adaptec]# raidutil -L array
osdIOrequest : File /dev/dpti17 Could Not Be Opened
Engine connect failed: COMPATIBILITY number

Googling around, it seems I need to have the i2o_config module loaded.

[root@pop adaptec]# /sbin/lsmod | grep i2o
dpt_i2o                29920   6
scsi_mod              106968   2  [dpt_i2o sd_mod]

So, my question is, what will happen if I do an /sbin/modprobe i2o_config? :)
It appears there are other modules available as well... i2o_proc, o2o_block,
o2o_core.  Would I need to load any of these modules as well?  Or will
i2o_config load them automatically?

I just want to avoid loading the module and having the system go down.

Thanks.
