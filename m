From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Exporting which partitions to md-configure
Date: Mon, 30 Jan 2006 16:52:08 -0800
Message-ID: <43DEB4B8.5040607@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: klibc list <klibc@zytor.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm putting the final touches on kinit, which is the user-space 
replacement (based on klibc) for the whole in-kernel root-mount complex. 
   Pretty much the one thing remaining -- other than lots of testing -- 
is to handle automatically mounted md devices.  In order to do that, 
without adding userspace versions of all the paritition code (which may 
be a future change, but a pretty big one) it would be good if the 
partition flag to auto-configure RAID was available in userspace, 
presumably through sysfs.

Any feeling how best to do that?  My current thinking is to export a 
"flags" entry in addition to the current ones, presumably based on 
"struct parsed_partitions->parts[].flags" (fs/partitions/check.h), which 
seems to be what causes md_autodetect_dev() to be called.

Note that this should be available even if md isn't compiled into the 
kernel, thus making it possible to load md as a module before running 
kinit, or to make the equivalent of the kernel mounting sequence from a 
totally runtime user tool.

	-hpa
