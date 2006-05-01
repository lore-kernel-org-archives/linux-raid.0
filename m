From: NeilBrown <neilb@suse.de>
Subject: [PATCH 000 of 11] md: Introduction - assort md enhancements for 2.6.18
Date: Mon, 1 May 2006 15:29:56 +1000
Message-ID: <20060501152229.18367.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
List-Id: linux-raid.ids

The follow 11 patch are assorted tidy-ups and functionality
enhancements suitable for 2.6.18 when that opens up.

More interesting patches are:
 5 - merge raid5 and raid6 code into a single module.  There is a lot
      of common code here, and there are advantages in uniting it all.
 8 - allow a linear array to be expanded while online by adding an
     extra drive.
 10- A new flavour of 'raid10' which matches one of the layouts
     supported by 'DDF' - an industry standard raid metadata format
     which might be supported one day.  This will need an updated
     mdadm to experiment with.

Thanks,
NeilBrown




 [PATCH 001 of 11] md: Reformat code in raid1_end_write_request to avoid goto
 [PATCH 002 of 11] md: Remove arbitrary limit on chunk size.
 [PATCH 003 of 11] md: Remove useless ioctl warning.
 [PATCH 004 of 11] md: Increase the delay before marking metadata clean, and make it configurable.
 [PATCH 005 of 11] md: Merge raid5 and raid6 code
 [PATCH 006 of 11] md: Remove nuisance message at shutdown
 [PATCH 007 of 11] md: Allow checkpoint of recovery with version-1 superblock.
 [PATCH 008 of 11] md: Allow a linear array to have drives added while active.
 [PATCH 009 of 11] md: Support stripe/offset mode in raid10
 [PATCH 010 of 11] md: make md_print_devices() static
 [PATCH 011 of 11] md: Split reshape portion of raid5 sync_request into a separate function.
