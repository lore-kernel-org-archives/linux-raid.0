From: rrk <rrk@prairie.lakes.com>
Subject: md0 larger than physical  block size with mdadm
Date: Mon, 17 May 2004 20:13:08 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40A96324.7040407@prairie.lakes.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

i have been trying to build a raid 1 array -- everything looks prefect
until i try to boot then i get an error msg to effect that md0 is larger
than the physical block size (md0 2560351 vs pb 2560320) this is consistent
across md0 thru md3 not the exact block count but close. kernel is 24.26
mdadm is 1.5  quick summary  built  debian system tested it  used sfdisk
to partion hdc verified both disks matched used mkfs.ext3 to format partions
copied dta over set fd auto detect partion type both drives created it 
let it mirror verified
superblocks (mdadm -E /dev/hda1 ) all looked fine.  Any idea's ?
md's where build from mepis -- used as a bootable CD ? something goofy 
with mepis?
can someone reccommed a different 'bootable' ? or is that not an issue?

