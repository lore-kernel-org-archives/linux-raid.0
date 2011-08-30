From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 9/9] mdadm: 'dump' support
Date: Tue, 30 Aug 2011 12:58:03 +1000
Message-ID: <20110830125803.19ad660b@notabene.brown>
References: <20110826020908.28015.52384.stgit@localhost6.localdomain6>
	<20110826021445.28015.63357.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110826021445.28015.63357.stgit@localhost6.localdomain6>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org, marcin.labun@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

On Thu, 25 Aug 2011 19:14:45 -0700 Dan Williams <dan.j.williams@intel.com>
wrote:

>   mdadm -E /dev/sda --dump=foo
> 
> Creates a sparse file image of /dev/sda named foo with a copy of the
> metadata instance found by -E.
> 
> When used in the opposite direction:
> 
>   mdadm -E foo --dump=/dev/sda
> 
> ...can restore metadata to a given block device, assuming it is
> identical size to the dump file.


I like this functionality - I've thought about doing something like this
before but never quite done it.

I'm not convinced of the interface yet - especially the lack of checks.  If
it can be misused it will be misused and we should try to avoid that.

Using a sparse file is probably a good idea - it removes the need to try to
invent a format for storing non-consecutive metadata and recording the offset.

dmraid has a --dump-metadata (-D) option which creates a directory and stores
one file per device there.  I like that as it make it easy to get everything
in the right place.

Maybe the arg to --dump could be a directory name to store dump files in ...
but then we lose the pleasing symmetry of using the same command to dump and
restore.  But is that symmetry only pleasing to us and would it be confusing
to new users?

Suppose we did have a separate 'restore' function - what would it look like?
An option to create?

  mdadm --create --restore=some-directory /dev/sda /dev/sdb

Then the names of the dump files would need to indicate which array and which
position in the array...  And this would make it hard to restore the metadata
to a single device.

So probably just
  mdadm -E /dev/sda --restore=some-file
would restore the metadata then report it??  Maybe keeping the old metadata
as a backup.
Or maybe drop the -E and just have '--dump' and '--restore' as top-level
Misc options.

It would be good if --restore would create a backup of the in-disk metadata
if there is any - to "some-file.bak" maybe ??

So how about this:

 - allow --examine to work on a file.
 - new misc option --dump=foo will create directory foo and store an image of
   any metadata on each device listed - filename matches basename of device.
 - new misc option --restore=bar.  For each device listed restore metadata
   from bar (if it is a file, in which case only one device) or bar/basename
   (if it is a directory).  In either case if there is metadata on the device,
   save it to the file + ".bak".  If ".bak" exists and there is metadata -
   abort.

Does that seem reasonable?

Thanks,
NeilBrown

