From: NeilBrown <neilb@suse.de>
Subject: Something wrong with __prep_thunderdome in super-intel.c
Date: Tue, 22 Mar 2011 13:23:07 +1100
Message-ID: <20110322132307.34e9bb3b@notabene.brown>
References: <20110314140052.20478.45664.stgit@gklab-128-013.igk.intel.com>
	<20110315085346.3bf9feb7@notabene.brown>
	<905EDD02F158D948B186911EB64DB3D17A9910DD@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <905EDD02F158D948B186911EB64DB3D17A9910DD@irsmsx503.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "Kwolek, Adam" <adam.kwolek@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids


Hi Dan,

 I think you were the original author of imsm_thunderdome and
 __prep_thunderdome - yes?

 I found a case (thank to the test suite) where it isn't working correctly,

 If I have a container with 2 devices, and the second one is failed, then
 imsm_thunderdome returns NULL.

 __prep_thunderdome sees the first and adds it to the table of superblocks.
 Then it sees the second notices the family_num and checksum are the same, and
 so replaces the first with the second in the table.

 Then in imsm_thunderdome, d->serial is full of 'nul', so disk_list_get
 doesn't find anything so the super_table becomes empty and nothing works.

 So it could be:
    load_and_parse_mpb is wrong for putting the nul serial in there
    __prep_thunderdome is wrong for thinking the two are equivalent
    imsm_thunderdome is wrong for giving up when just one device isn't found

 and I really don't know which.

You can easily reproduce with

  ./mdadm -CR /dev/md/imsm -e imsm -n 2 /dev/loop[01]
  ./mdadm -CR /dev/md/r1 -l1 -n2 /dev/md/imsm
  ./mdadm /dev/md/r1 -f /dev/loop1
  ./mdadm -E /dev/md/imsm

and notice that nothing gets printed.
If you fail loop0 instead, it works properly.

Thanks,
NeilBrown
