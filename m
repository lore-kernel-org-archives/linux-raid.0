From: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Subject: New disk in active container
Date: Mon, 30 Oct 2017 11:58:04 +0100
Message-ID: <20171030105804.GA31198@proton.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com
List-Id: linux-raid.ids

Hi all,

I'm looking what happens to the disk when it's added to active container
(mdmon already running).

In mdadm in add_disk_to_container there is this piece of code:

	if (st2->ss->load_super(st2, dfd, NULL) == 0) {
		st2->ss->getinfo_super(st2, &info, NULL);
		if (st->ss->compare_super(st, st2) == 0 &&
		    info.disk.raid_disk >= 0) {
			/* Looks like a good member of array.
			 * Just accept it.
			 * mdadm will incorporate any parts into
			 * active arrays.
			 */
			st2->ss->free_super(st2);
			return;
		}
	}

A change has been recently introduced to IMSM code (changeset 20dc76d15b40
imsm: Set disk slot number) which sets raid_disk in getinfo_super. Prior to
this change this code had had no effect on IMSM. Now if out-of-date disk
(e.g. removed with mdadm -If some time ago) appears in the system, the code
above tries to bring it back to the array. compare_super doesn't check if
metadata on the disk is out-of-date (it just checks uuid, family number and
basic parameters, not disk state). The metadata on new disk doesn't indicate
it's out-out-date. The disk is added to container. I don't think it's
correct behaviour as such disk is not "a good member of array".

I wonder how it could be fixed. I have had a look at compare_super for
native metadata and it doesn't check disk state so I'm not sure if it should
be introduced there. I think we should not trust new disk regarding its
state (the fact it believes it belongs to array is not enough) but rely on
the disk state in the metadata of the container.

What are your thoughts?

Tomek

