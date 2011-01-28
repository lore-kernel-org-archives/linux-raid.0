From: "Labun, Marcin" <Marcin.Labun@intel.com>
Subject: [native] Bug report -cannot create a native raid on devel-3.2
Date: Fri, 28 Jan 2011 15:30:23 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D17701BD41@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "neilb@suse.de" <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Kwolek, Adam" <adam.kwolek@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>
List-Id: linux-raid.ids

Hi Neil,
Creation of a native raid fails:
mdadm -CR /dev/md/aaa -n 2 -l 1 /dev/sdb /dev/sdc
mdadm: ADD_NEW_DISK for /dev/sdb failed: Invalid argument.
In /var/log/messages:
md: sdb does not have a valid v1.2 superblock, not importing!


This on top on devel-3.2.
The bug is probably connected with fix 1cc7f4feb9a979 "Don't close fds in write_init_super".
In the call to get_dev_size from write_init_super1 the di->fd descriptor is zero and get_dev_size returns with error.
One of the first steps in load_super1 is call  free_super1(st). free_super1 releases st->info pointer and closes(di->fd);

The sequence in write_init_super1:
for (di = st->info; di && ! rv ; di = di->next) {
....

1060                 if (load_super1(&refst, di->fd, NULL)==0) {
1076 
  <..cut..>
1077                 if (!get_dev_size(di->fd, NULL, &dsize))
1078                         return 1;
< ...cut ... >
}


Thanks,
Marcin Labun





