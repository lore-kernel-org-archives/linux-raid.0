From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 03/27] imsm: Prepare reshape_update in mdadm
Date: Thu, 9 Dec 2010 09:05:58 +1100
Message-ID: <20101209090558.32f48daa@notabene.brown>
References: <20101206131821.21125.65217.stgit@gklab-170-024.igk.intel.com>
	<20101206132108.21125.54920.stgit@gklab-170-024.igk.intel.com>
	<20101208141016.437dfd2d@notabene.brown>
	<905EDD02F158D948B186911EB64DB3D17676EAED@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <905EDD02F158D948B186911EB64DB3D17676EAED@irsmsx503.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Kwolek, Adam" <adam.kwolek@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

On Wed, 8 Dec 2010 13:51:27 +0000 "Kwolek, Adam" <adam.kwolek@intel.com>
wrote:

> I didn't describe those functions, because I've realized that it has to be changed after your email.
> I've planned to do this before I send patches, but unfortunately this "thread" was missed before sending ;).
> Here is current state.
> 
> Functions: 
> 	- path2devnum() (Translates path (or symbolic link) to md device given by user to device number.)
> 	- find_array_minor() (returns device minor for given array name, it uses maps to find names with additions (i.e. "_0") from assebbly)
> 	- find_array_minor2() (as find_array_minor() but works for frozen arrays also)
> 
> Will be removed and replaced by:
> 
> int find_array_minor_by_subdev(int subdev, int container, int *minor)
> {
> 	char text_version[PATH_MAX];
> 	char path[PATH_MAX];
> 	int i;
> 	struct stat s;
> 
> 	sprintf(text_version, "md%i/%i", container, subdev);
> 	for (i = 127; i >= 0; i--) {
> 		char buf[PATH_MAX];
> 
> 		snprintf(path, PATH_MAX, "/sys/block/md%d/md/", i);
> 		if (stat(path, &s) != -1) {
> 			char *version;
> 
> 			strcat(path, "metadata_version");
> 			if (load_sys(path, buf))
> 				continue;
> 			version = strchr(buf, ':');
> 			/* compare without first letter
> 			 * it could be marked as frozen with '-'
> 			 */
> 			if (!version || strcmp(version + 2, text_version))
> 				continue;
> 			*minor = i;
> 			return 0;
> 		}
> 	}
> 
> 	return -1;
> }
> 
> This is a little part of find_array_minor() with changed input.
> 
> This function searches given container for subdev and returns it minor id.
> i.e.: for input parameters 0 and 127 it creates search string i.e. "md127/0" and for such device returns minor (~126).
> For success 0 is returned, and -1 for failure (and passed minor variable remains untouched). 
> It searches all devices from 127 to 0. 
> I think it is simpler now (as you raised this issue), and mdadm doesn't make decisions based on array name/string/ now.
> 
> Please let me know how do you find this change. 

Yes much simpler and better.  And I understand easily what you are trying to
do which is also good!

There are two problems:
1/ it assumes that subdevs have a number.  I would prefer that generic code
  assumed that a subdev has a name - if that happens to always be a numeric
  name, that is up to the metadata handler.
2/ searching from 127 to 0 is wrong because md number can be much bigger than
  127 if you have enough devices.  It would be better to use readdir to get a
  list of the /sys/block/mdXX that actually exist.

However I would rather not uses sysfs at all, but mdstat as that is easy to
read and search quickly.
Have a look at mdstat_by_component.  Write something similar which is given a
container and subarray name and returns the corresponding mdstat_ent.

That would be much cleaner and even simpler.


> 
> I've replaced open() with open_dev() in this patch (and in a few next one: 0003, 0007, 0012, 0019, 0021)
> 
> If it is ok, please let me know if you want fresh series or you'll apply current one and I'll send patches for above changes then.
> In future patches, I'll address problem with lines longer than 80 characters also.

Please always send a series of patches against what you pull from my
devel-3.2 branch.  I'll fix up any conflicts against anything I might have
committed since you pulled.
It is probably best to send smallish sets of patches  - maybe about 10 at a
time.  If they are accepted, you can send the next batch.  If there are
issues, you can revise subsequent patches before you send them.

NeilBrown


> 
> Please note also that implementation of searching spare devices for reshape is not final. 
> It requires better integration with auto-rebuild searching spares mechanism.
> This task is in my nearest plans (I'm hoping to post fixes instead of whole series again ;))
> 
> 
> BR
> Adam
> 
