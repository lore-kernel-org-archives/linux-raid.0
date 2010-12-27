From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: RE: [PATCH 00/29] OLCE, migrations and raid10 takeover
Date: Mon, 27 Dec 2010 14:56:05 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D176C65EA1@irsmsx503.ger.corp.intel.com>
References: <20101209150352.26876.33974.stgit@gklab-170-024.igk.intel.com>
	<20101216222058.03132812@notabene.brown>
	<BE2BFE91933D1B4089447C644860408066B84342@irsmsx503.ger.corp.intel.com>
 <20101221233714.61b29ad9@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101221233714.61b29ad9@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>, "Wojcik, Krzysztof" <krzysztof.wojcik@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids

Hi,

Please find below my few comments for current grow/reshape code on devel 3.2.

In super-intel.c, update_reshape_container_disk update is defined.
It is intended to send for container only and operates on all devices /arrays/ in container in one shot. 
This is IMSM incompatible way. IMSM updates disks list in metadata and first device information during first array reshape.
During second array reshape, device is updated only (using disk information updated during first reshape)
As it I am showing above. Container operation is in fact set of single array operations. This is due to single migration area (per container),
where backup is stored. It is related to currently reshaped device and we can have single array in reshape state only.

This drives to conclusion that update should be issued per array and should have device id (dev minor or subdev).

Considering above current implementation of update_reshape_container_disk is not compatible with imsm.

This is driven by current reshape_container() implementation in Grow.c.
The flow goes as follow:
1. reshape_container()
  - metadata update for container (+ sync_metadata)
  - call in loop reshape_array() for each array in container

2. reshape_array()
   - adds disks for each device in container - but it should add disks to this particular array it is called for (loop is on reshape_container() already)
   - reshape_array() - currently doesn't update metadata, if so - in line 1891 sync_metadata() seems to be not necessary /no reshape_super() call/
   - currently reshape_array() assumes that metadata is ready for all devices in container - this is not imsm compatible /as described above/

How mdadm should work to be imsm compatible:
1. container operation is set of array operations (not atomic/single container update)
2. for every array the same disk set should be used (it is covered in current devel 3.2 code but not in imsm compatible way)
3. there is not metadata update after reshape_super() call for container.
4. first array update should update disk list in metadata
6. second array update should reuse (+verify) used disk list present in metadata already
7. reshape cannot be run in parallel

Main code changes I'm proposing?
Problem 1.
	Main code in Grow.c cannot assume when whole metadata /all arrays in container/ will be updated for particular external meta
	during reshape_super() in reshape_container(). It can issue no update to container/arrays/ due to compatibility reason.
Resolution 1.
	reshape_super() has to be called for container and for every array in reshape_array() (i.e.) before new disks will be added to array (and after monitor is running).
	We can distinguish calls by comparing (as currently), st->container_dev and st->devnum.
	This causes that in reshape_array(), spares cannot be added to all arrays in container at one time (based on metadata information), 
	but for current array only (all arrays will be covered by loop in reshape_container()).
	This means also, that disks cannot be added based on metadata information without adding additional reshape_suped() call in reshape_array(),
	as it cannot be assumed that all arrays in container are updated at this moment without this call.

Problem 2.
	As reshape_container() performs action for all arrays in container probably we should allow for code reuse from Grow.c by external meta.
Resolution 2.
	In my implementation, I've did it by moving manage_reshape() call to the end of reshape processing. In this function I've manage array size and backward takeover to raid0 /optionally/
  	I think that this would be correct for imsm, but to have flexibility manage_reshape() call should not be changed. In such situation additional function can be added:
	i.e. finalize_reshape() for purposes I've pointed above (after wait_reshape() and before level change action, Grow.c:2045).
	Action after manage_reshape() should be based on manage_reshape() on condition if it exists and is yes, on return code form this call.
	This allows metadata specific code decide to reuse or not /or for some cases/ as much as it is possible of main reshape code.

Problem 3.
	After manage_reshape() call we are returning to main reshape_container() code, I assume that manage_reshape() should execute at some point fork() and return,
	as code in Grow.c does. This can cause running parallel reshapes using i.e. single backup file.
Resolution 3. 
	Resolution will depend on particular metadata implementation, but as it is single backup_file used, I can assume that intention is sequential reshapes run.
	This can be handled in reshape_super() by waiting for all arrays to be in idle state. This entry condition should be checked in reshape_super() called in reshape_container()
	without waiting for state change, and in reshape_super() called in reshape_array() with waiting for idle state.


Considering all above I think that container reshape should work as follow (using current devel 3.2 code):

reshape_container()
{
  a) reshape_super(container context)
	- check reshape condition and exit with error when any array is not ready for reshape
	  Checking condition here makes us safe that we can wait for required condition during reshape_super() call in array context later
	- leaving this call here makes possible to implement container update also if metadata requires this
  b) fork() if reshape_super() call succeed (+).
	For multi-array container this is required to return to console for sequential work on arrays. 
	When we want to procced for second array, we have to wait until first reshape is finished. 
	This would block console.
  c) call in loop for all devices reshape_array()
	1. analyse_change()
	2. change level and start monitor (if required)
	3. reshape_super(array context) (+)
		- check reshape condition, if any array is in reshape state in container this time wait for reshape end.
		- send metadata update and allow for reshape processing
	4. load metadata (container_content()) and based on this information add disks to md for single array (currently processed)
	5. set other array parameters to md (including raid_disks)
	6. start_reshape()
	7. manage_reshape()(+) -> if metadata requires take ownership of process or ...
	8. control reshape by Grow.c code using fork() 
	   (possible that fork usage can be optional for container, as it is forked already)
		- child_XXX()
		- wait reshape
		- finalize_reshape(for external metadata)(+) - we can handle size change in common code usage case
		- backward takeover
	9. return to reshape_container() and process next array (c.) if any
}

Things added to your current design (marked above with (+)):
	1. additional fork()
	2. additional reshape_super() in reshape_array()
	3. change in call to manage_reshape() to allow processing in main code for external metadata
		Depends on:
			- if manage_reshape() exists
			- manage_reshape() return code
	4. added finalize_reshape()


Above flow gives possibility to:
1. run reshapes in sequence or
2. run reshapes in parallel 
3. reuse Grow.c code (we can use manage_reshape, finalize_reshape, code in Grow.c or any reasonable combination)

	and all this is up to metadata specific code (reshape_super()/manage_reshape()/finalize_reshape()).

Please let me know what do you think about this. If you like it, I'll start work on code changes.

BR
Adam



> -----Original Message-----
> From: Neil Brown [mailto:neilb@suse.de]
> Sent: Tuesday, December 21, 2010 1:37 PM
> To: Wojcik, Krzysztof
> Cc: Kwolek, Adam; linux-raid@vger.kernel.org; Williams, Dan J;
> Ciechanowski, Ed; Neubauer, Wojciech
> Subject: Re: [PATCH 00/29] OLCE, migrations and raid10 takeover
> 
> On Mon, 20 Dec 2010 08:27:38 +0000 "Wojcik, Krzysztof"
> <krzysztof.wojcik@intel.com> wrote:
> 
> > Neil,
> >
> > How we can help you to speed up your work?
> >
> 
> An update:
> 
>  I got the code to a state where the shape of what I'm trying to do
> should be
>  clear, though the code to do it isn't quite complete yet.
>  The last commit in my devel-3.2 tree contains some incomplete code,
> some
>  enhanced documentation for how it is supposed to work, and a to-do
> list
>  to remind me what I should be doing next.
> 
>  If any of your people have time to look at it and possibly fill in
> some of
>  the gaps that would be great.  I am on leave for the next 2 weeks but
> I'll
>  be reading email and will try to respond to any question or small
> patches
>  that arise (I won't be reviewing any long patch series though).
> 
>  Probably the most useful next step would be to fit the migration
> checkpoint
>  patches into the new approach - that should be fairly straight
> forward.
>  Then probably look at reshape_super and make sure it is doing the
> right
>  thing according to the new rules.
>  manage_reshape will probably need to wait until the new code has
> stablised a
>  bit.
> 
> Thanks,
> 
> NeilBrown

