From: NeilBrown <neilb@suse.de>
Subject: Re: Reshape restart questions.
Date: Mon, 7 Mar 2011 09:01:52 +1100
Message-ID: <20110307090152.71187c5e@notabene.brown>
References: <905EDD02F158D948B186911EB64DB3D17A822106@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <905EDD02F158D948B186911EB64DB3D17A822106@irsmsx503.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Kwolek, Adam" <adam.kwolek@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids

On Fri, 4 Mar 2011 15:22:45 +0000 "Kwolek, Adam" <adam.kwolek@intel.com>
wrote:

> Hi Neil,
> 
> I have problem with backup file concept during assembly when array reshape is in progress.
> There can be 2 purposes of passing backup file to mdadm for assembly:
> 1. restore critical section before restart from checkpoint
> 2. use backup file for reshape continuation

My first thought is that - for IMSM at least - I understand that the plan is
to (eventually) use a 'backup' method which is compatible with the windows
driver and so will not use a separate file.
In that case, we probably don't want to put too much effort into getting
management of the backup-file 100% perfect.  near-enough might be
good-enough...

> 
> For first reason, it is difficult to pass backup file name in mdadm-assembly-scan mode, because we cannot point array that it should be used with. This is blocked in mdadm input parameters parsing.

Yes.  I consider restarting a reshape, particularly with a backup file, to be
a rare case that may well need human interaction.  So I'm happy for
auto-assembly modes to not support it at all.

> Second reason is a different case. Backup file can be used by many reshapes and have to be used (even in scan mode). When reshaped is single container, reshapes cannot be parallel, but in whole system this cannot be guaranteed. (i.e. one reshape was run in particular system and second array with reshape in progress is attached to system)
> Due to those facts I think that:
> 1. mdadm should accept backup file name for second reason
> 2. final backup file name has to be additionally customized. For passed 'backupfilename' (i.e. bakName.bak) we can generate:
> 	- for native metadata: devicename_backupfilename (i.e. md126_bakName.bak)
> 	- for external metadata: containername_backupfilename (i.e. md127_bakName.bak)
> 3. used backup file name has to be printed out to let user know about chosen name

I think this is making things more complicated rather than less.  Names like
'md126_bakName.bak' are not good as there is no guarantee that the 'md126'
bit is stable from one restart to the next.

We could possibly just have a directory containing backup files and mdadm
searches through it for a matching one, but I don't think I really like that..

> 
> or
> 
> If mdadm.conf could be extended to specify backup file connected to array (i.e. via UUID), we can give ability to connect backup file name with particular array and restore data
> For reshape continuation even in scan mode. For this purposes grow should store backup file name (connected to proper UUID) when backup file handle is opened and remove it when handle is closed.
> Assemble can use this information. If automatic modification of mdadm.conf is a problem, special reshape conf file can be used instead (i.e. mdadm_reshape.conf).
> This file name can be also used for other volumes in particular container (container operation) when first reshape is finished.
> 
> Tell me what you are thinking about such idea.

I think I want to simply disallow auto-assembly of arrays that need a backup
file.  Instead we should focus on implementing reshape so that a backup file
is not needed.  i.e. use some space on the device(s).

> 
> 
> Second thing I want to signal is restoring from checkpoint '0'. Md refuses to start raid5 array when reshape position is set to 0.
> Md gives information (raid5.c (run()):5058):
> 	"... reshape_position too early for auto-recovery - aborting"
> 
> In md (raid5.c/run()) variables here_old == here_new == 0 (because of reshape_position == 0).
> After normal system shut down this situation shouldn't happened (mdadm should not allow for this).
> Fix/workaround seems to be easy (change '>=' to '>' or add '0' case of reshape_new), but it is possible that I've missed something and check should test something more,
> or this case should be treated/ignored as : it will never happened/small possibility.

This certainly never needs to happen.

If no re-arrangement of data has happened - i.e. sync_max was always 0 - then
the  reshape really hasn't started.  So we shouldn't tell the kernel that the
array is in the middle of reshaping and it is up to '0'.  Rather we should
tell it that the array is still the old shape, then start the array, then
start the reshape.  So possibly sysfs_set_array should check both
reshape_active and reshape_progress before setting up then new shape of the
array.

Alternately if some little bit of reshape has already started, then allowing
the array to start with 'reshape_position' would be wrong.  We need to load
dasta from backup to make sure everything is consistent, and restart from the
correct starting point.



As you probably noticed I haven't had much time for mdadm lately.  However I
plan to spend the rest of this week (from Tuesday) on mdadm, so I'll review
your patches then and look at sorting out some of these issues.

Thanks,
NeilBrown
