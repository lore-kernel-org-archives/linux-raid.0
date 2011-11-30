From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: RE: [PATCH] md: Add ability for disable bad block management
Date: Wed, 30 Nov 2011 08:17:32 +0000
Message-ID: <79556383A0E1384DB3A3903742AAC04A054C28@IRSMSX101.ger.corp.intel.com>
References: <20111124121953.5509.28118.stgit@gklab-128-013.igk.intel.com>
 <20111130111403.7efd3875@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111130111403.7efd3875@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>
List-Id: linux-raid.ids



> -----Original Message-----
> From: NeilBrown [mailto:neilb@suse.de]
> Sent: Wednesday, November 30, 2011 1:14 AM
> To: Kwolek, Adam
> Cc: linux-raid@vger.kernel.org; Ciechanowski, Ed; Labun, Marcin; Williams,
> Dan J
> Subject: Re: [PATCH] md: Add ability for disable bad block management
> 
> On Thu, 24 Nov 2011 13:19:53 +0100 Adam Kwolek
> <adam.kwolek@intel.com> wrote:
> 
> > When external metadata doesn't support BBM, mdadm cannot answer
> > correctly for BBM requests. It causes reshape process being stopped.
> >
> > Add ability for external metadata /mdadm/ to disable BBM via sysfs.
> > md will ignore bad blocks as it is for metadata v0.90.
> 
> This should not be necessary.
> 
> The intention is that a device with a bad block looks exactly like a device with
> a failed device.  i.e. 'faulty' and 'blocked' appear in the 'state'
> file.
> 
> If the metadata doesn't support a bad-block list, it will record that the device
> has failed and will unblock the device.  At that point the failure is forced.
> If the metadata does support a bad block list it will just record the bad blocks
> and acknowledge them, and the unblock the device.  At that point the device
> won't be failed, the 'faulty' state will disappear, and it will continue to be
> used with the known bad blocks.
> 
> What exactly is going wrong that makes you think you need this patch?


When degradation occurs during migration BBM is signaled to mdmon and mdmon /monitor.c/ tries to mark disk  '-blocked'
This operation fails. Momon goes in to loop, and nothing can be done /I cannot make it using sysfs/ to signal or remove device.
In sysfs device is present in /sys/block/mdXXX/md but entry /sys/block/mdXXX/md/dev-sdX/~block is missing /disk was pulled out/.

From the kernel perspective when BBM event occurs md_do_sync() thread should finish and md should reinitialize process with new disks set.
This occurs when BBM is disabled for metadata 0.9 and using my patches for imsm.
Without BBM being blocked md_do_sync() blocks and doesn't end. Whole process is being stopped.
If I've made md_do_sync() to finish the second one is not started as for BBM disabled case.

From user space device is being visible as device that cannot be umounted /this is not strange as kernel thread waits forever/
Normal reboot is not possible also.

If you don't want the last patch that disables BBM support  /at this moment?/, please consider the rest of patches.
This will add ability to restart migration when array degradation occurs when array was offline /someone "borrows" disk ;)/.

If you have any more questions please let me know.

BR
Adam

> 
> NeilBrown
> 

