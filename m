From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: Reshape restart questions.
Date: Fri, 4 Mar 2011 15:22:45 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D17A822106@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids

Hi Neil,

I have problem with backup file concept during assembly when array reshape is in progress.
There can be 2 purposes of passing backup file to mdadm for assembly:
1. restore critical section before restart from checkpoint
2. use backup file for reshape continuation

For first reason, it is difficult to pass backup file name in mdadm-assembly-scan mode, because we cannot point array that it should be used with. This is blocked in mdadm input parameters parsing.
Second reason is a different case. Backup file can be used by many reshapes and have to be used (even in scan mode). When reshaped is single container, reshapes cannot be parallel, but in whole system this cannot be guaranteed. (i.e. one reshape was run in particular system and second array with reshape in progress is attached to system)
Due to those facts I think that:
1. mdadm should accept backup file name for second reason
2. final backup file name has to be additionally customized. For passed 'backupfilename' (i.e. bakName.bak) we can generate:
	- for native metadata: devicename_backupfilename (i.e. md126_bakName.bak)
	- for external metadata: containername_backupfilename (i.e. md127_bakName.bak)
3. used backup file name has to be printed out to let user know about chosen name

or

If mdadm.conf could be extended to specify backup file connected to array (i.e. via UUID), we can give ability to connect backup file name with particular array and restore data
For reshape continuation even in scan mode. For this purposes grow should store backup file name (connected to proper UUID) when backup file handle is opened and remove it when handle is closed.
Assemble can use this information. If automatic modification of mdadm.conf is a problem, special reshape conf file can be used instead (i.e. mdadm_reshape.conf).
This file name can be also used for other volumes in particular container (container operation) when first reshape is finished.

Tell me what you are thinking about such idea.


Second thing I want to signal is restoring from checkpoint '0'. Md refuses to start raid5 array when reshape position is set to 0.
Md gives information (raid5.c (run()):5058):
	"... reshape_position too early for auto-recovery - aborting"

In md (raid5.c/run()) variables here_old == here_new == 0 (because of reshape_position == 0).
After normal system shut down this situation shouldn't happened (mdadm should not allow for this).
Fix/workaround seems to be easy (change '>=' to '>' or add '0' case of reshape_new), but it is possible that I've missed something and check should test something more,
or this case should be treated/ignored as : it will never happened/small possibility.

BR
Adam
