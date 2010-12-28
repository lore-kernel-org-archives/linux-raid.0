From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 00/29] OLCE, migrations and raid10 takeover
Date: Tue, 28 Dec 2010 13:24:25 +1100
Message-ID: <20101228132425.5bebf1ae@notabene.brown>
References: <20101209150352.26876.33974.stgit@gklab-170-024.igk.intel.com>
	<20101216222058.03132812@notabene.brown>
	<BE2BFE91933D1B4089447C644860408066B84342@irsmsx503.ger.corp.intel.com>
	<20101221233714.61b29ad9@notabene.brown>
	<905EDD02F158D948B186911EB64DB3D176C65EA1@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <905EDD02F158D948B186911EB64DB3D176C65EA1@irsmsx503.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Kwolek, Adam" <adam.kwolek@intel.com>
Cc: "Wojcik, Krzysztof" <krzysztof.wojcik@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids

On Mon, 27 Dec 2010 14:56:05 +0000 "Kwolek, Adam" <adam.kwolek@intel.com>
wrote:

> Hi,
> 
> Please find below my few comments for current grow/reshape code on devel 3.2.
> 
> In super-intel.c, update_reshape_container_disk update is defined.
> It is intended to send for container only and operates on all devices /arrays/ in container in one shot. 
> This is IMSM incompatible way. IMSM updates disks list in metadata and first device information during first array reshape.
> During second array reshape, device is updated only (using disk information updated during first reshape)
> As it I am showing above. Container operation is in fact set of single array operations. This is due to single migration area (per container),
> where backup is stored. It is related to currently reshaped device and we can have single array in reshape state only.
> 
> This drives to conclusion that update should be issued per array and should have device id (dev minor or subdev).
> 
> Considering above current implementation of update_reshape_container_disk is not compatible with imsm.
> 
> This is driven by current reshape_container() implementation in Grow.c.
> The flow goes as follow:
> 1. reshape_container()
>   - metadata update for container (+ sync_metadata)
>   - call in loop reshape_array() for each array in container
> 
> 2. reshape_array()
>    - adds disks for each device in container - but it should add disks to this particular array it is called for (loop is on reshape_container() already)
>    - reshape_array() - currently doesn't update metadata, if so - in line 1891 sync_metadata() seems to be not necessary /no reshape_super() call/
>    - currently reshape_array() assumes that metadata is ready for all devices in container - this is not imsm compatible /as described above/
> 
> How mdadm should work to be imsm compatible:
> 1. container operation is set of array operations (not atomic/single container update)
> 2. for every array the same disk set should be used (it is covered in current devel 3.2 code but not in imsm compatible way)
> 3. there is not metadata update after reshape_super() call for container.
> 4. first array update should update disk list in metadata
> 6. second array update should reuse (+verify) used disk list present in metadata already
> 7. reshape cannot be run in parallel
> 
> Main code changes I'm proposing?
> Problem 1.
> 	Main code in Grow.c cannot assume when whole metadata /all arrays in container/ will be updated for particular external meta
> 	during reshape_super() in reshape_container(). It can issue no update to container/arrays/ due to compatibility reason.
> Resolution 1.
> 	reshape_super() has to be called for container and for every array in reshape_array() (i.e.) before new disks will be added to array (and after monitor is running).
> 	We can distinguish calls by comparing (as currently), st->container_dev and st->devnum.
> 	This causes that in reshape_array(), spares cannot be added to all arrays in container at one time (based on metadata information), 
> 	but for current array only (all arrays will be covered by loop in reshape_container()).
> 	This means also, that disks cannot be added based on metadata information without adding additional reshape_suped() call in reshape_array(),
> 	as it cannot be assumed that all arrays in container are updated at this moment without this call.
> 
> Problem 2.
> 	As reshape_container() performs action for all arrays in container probably we should allow for code reuse from Grow.c by external meta.
> Resolution 2.
> 	In my implementation, I've did it by moving manage_reshape() call to the end of reshape processing. In this function I've manage array size and backward takeover to raid0 /optionally/
>   	I think that this would be correct for imsm, but to have flexibility manage_reshape() call should not be changed. In such situation additional function can be added:
> 	i.e. finalize_reshape() for purposes I've pointed above (after wait_reshape() and before level change action, Grow.c:2045).
> 	Action after manage_reshape() should be based on manage_reshape() on condition if it exists and is yes, on return code form this call.
> 	This allows metadata specific code decide to reuse or not /or for some cases/ as much as it is possible of main reshape code.
> 
> Problem 3.
> 	After manage_reshape() call we are returning to main reshape_container() code, I assume that manage_reshape() should execute at some point fork() and return,
> 	as code in Grow.c does. This can cause running parallel reshapes using i.e. single backup file.
> Resolution 3. 
> 	Resolution will depend on particular metadata implementation, but as it is single backup_file used, I can assume that intention is sequential reshapes run.
> 	This can be handled in reshape_super() by waiting for all arrays to be in idle state. This entry condition should be checked in reshape_super() called in reshape_container()
> 	without waiting for state change, and in reshape_super() called in reshape_array() with waiting for idle state.
> 
> 
> Considering all above I think that container reshape should work as follow (using current devel 3.2 code):
> 
> reshape_container()
> {
>   a) reshape_super(container context)
> 	- check reshape condition and exit with error when any array is not ready for reshape
> 	  Checking condition here makes us safe that we can wait for required condition during reshape_super() call in array context later
> 	- leaving this call here makes possible to implement container update also if metadata requires this
>   b) fork() if reshape_super() call succeed (+).
> 	For multi-array container this is required to return to console for sequential work on arrays. 
> 	When we want to procced for second array, we have to wait until first reshape is finished. 
> 	This would block console.
>   c) call in loop for all devices reshape_array()
> 	1. analyse_change()
> 	2. change level and start monitor (if required)
> 	3. reshape_super(array context) (+)
> 		- check reshape condition, if any array is in reshape state in container this time wait for reshape end.
> 		- send metadata update and allow for reshape processing
> 	4. load metadata (container_content()) and based on this information add disks to md for single array (currently processed)
> 	5. set other array parameters to md (including raid_disks)
> 	6. start_reshape()
> 	7. manage_reshape()(+) -> if metadata requires take ownership of process or ...
> 	8. control reshape by Grow.c code using fork() 
> 	   (possible that fork usage can be optional for container, as it is forked already)
> 		- child_XXX()
> 		- wait reshape
> 		- finalize_reshape(for external metadata)(+) - we can handle size change in common code usage case
> 		- backward takeover
> 	9. return to reshape_container() and process next array (c.) if any
> }
> 
> Things added to your current design (marked above with (+)):
> 	1. additional fork()
> 	2. additional reshape_super() in reshape_array()
> 	3. change in call to manage_reshape() to allow processing in main code for external metadata
> 		Depends on:
> 			- if manage_reshape() exists
> 			- manage_reshape() return code
> 	4. added finalize_reshape()
> 
> 
> Above flow gives possibility to:
> 1. run reshapes in sequence or
> 2. run reshapes in parallel 
> 3. reuse Grow.c code (we can use manage_reshape, finalize_reshape, code in Grow.c or any reasonable combination)
> 
> 	and all this is up to metadata specific code (reshape_super()/manage_reshape()/finalize_reshape()).
> 
> Please let me know what do you think about this. If you like it, I'll start work on code changes.
> 
> BR
> Adam
> 


Hi Adam,
 thanks for you comments and the obvious effort you have put into
 understanding the new structure.

 I agree that my code is making some assumption that don't fit quite right
 with IMSM.  However I think they can be resolved with relatively small
 changes.

 I don't think we should support parallel reshaping at all.  md doesn't allow
 multiple arrays that share a device to be reshaped at the same time anyway,
 and running parallel reshapes would result in horrible performance.  So we
 should only support multiple reshapes in series.  Therefore on a single
 'fork' call is needed.  The forked child then handles all of the reshaping.

 I only want one call to ->reshape_super.  It essentially tells the metadata
 handler that the user has requested a reshape, and as the user only made one
 request, only one call to ->reshape_super should be made.

 I had assume that the one call would update the metadata for all of the
 arrays, but you say that is incorrect for IMSM. In that case it should just
 update the metadata for the first array.  When that reshape completes, the
 metadata will be told (in ->set_array_state) and it should at that point
 update the metadata to reflect that the second array is undergoing reshape.

 This requires slightly different behaviour in reshape_container.  Instead of
 calling ->container_content just once and then reshaping each array it should
 repeatedly:
    - load the metadata
    - call ->container_content, find the first array which is ready for
      reshape
    - process that reshape so that it completes
    - ping_monitor to ensure that the metadata is updated
 That should be quite general and compatible with IMSM.

 I am not entirely sure that you wanted finalize_reshape to do.  If it was to
 update the metadata to show that the reshape was complete, then that should
 be done in ->set_array_state.  If it was to e.g. convert a RAID4 back to
 RAID0, that is already done towards the end of reshape_array.

Thanks,
NeilBrown

