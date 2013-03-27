From: Martin Wilck <mwilck@arcor.de>
Subject: DDF test fails if default udev rules are active
Date: Wed, 27 Mar 2013 21:44:21 +0100
Message-ID: <51535A25.1040501@arcor.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

Hi Neil,

with my latest patch set, the DDF test case (10-ddf-create) succeeds
reliably for me, with one caveat: It works only if I disable the rule
that runs "mdadm -I" on a newly discovered container. On my system
(Centos 6.3) it is in /lib/udev/65-md-incremental.rules, and the rule is

SUBSYSTEM="block", ACTION="add|change", KERNEL="md*", \
  ENV{MD_LEVEL}=="container", RUN+="/sbin/mdadm -I $env{DEVNAME}"

The reason is that the DDF test case runs mdadm -Asc after writing the
conf file defining the container and 3 arrays.

mdadm -Asc will first create the container. When it starts tries to
create the member arrays, these have already been started by the udev
rule above, causing the assembly to fail with the error message "member
/dev/md127/1 in /dev/md127 is already assembled".

I have done my testing with the above udev rule commented out, and all
goes fine. But I am not sure if "mdadm -Asc /var/tmp/mdadm.conf" failing
indicates a problem with the DDF code, or if it's really just a problem
with the test case. Personally, I'd rather have a test case that
succeeds by default on a system with standard configuration (which means
the above udev rule should be active).

What do you think?
Martin
