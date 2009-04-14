From: Neil Brown <neilb@suse.de>
Subject: Re: [mdadm git pull] Intel metadata updates and some general fixes
Date: Tue, 14 Apr 2009 11:19:24 +1000
Message-ID: <18915.58524.95857.14466@notabene.brown>
References: <1239525557.7433.49.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Dan Williams on Sunday April 12
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, Ed Ciechanowski <ed.ciechanowski@intel.com>, Jacek Danecki <jacek.danecki@intel.com>, Doug Ledford <dledford@redhat.com>
List-Id: linux-raid.ids

On Sunday April 12, dan.j.williams@intel.com wrote:
> Hi Neil,
> 
> This release includes a collection of metadata compatibility updates:
> 1/ Rounding down the array size at create and assemble.  mdadm will warn
> if an array requests a custom size but the md/array_size attribute is
> not found.
> 2/ Refusing to assemble arrays that are in an unsupported migration
> state.  Until proper support is ready we need to detect such arrays and
> tell the user to finish the migration (raid level change, capacity
> expansion, restripe etc...) before trying to assemble the array in
> Linux.
> 3/ Various other fixups to gain better compatibility with the Windows
> driver.

I love the 'ddf' flag that mysterious needs to be '1'.  I wonder what
that is about...

> 
> According to Jacek the 'MD_METADATA' key from
> export_examine_super_imsm() gives anaconda fits when the array is not a
> native md array.  I had a patch to remove it, but decided to leave it in
> for a few reasons:
> 1/ I strongly suspect it is an anaconda misunderstanding of how to
> handle 'container' devices.
> 2/ It is a simple hack that if needed can be added to the Fedora local
> version of mdadm.
> 3/ I see no other way for udev to detect imsm members and perform
> operations like 'mdadm --detail-platform -e $MD_METADATA' to verify that
> raid support is enabled in the BIOS.  At installation time I would think
> a user would want the option to ignore raid metadata on the drives if
> support is disabled in the BIOS.

That all sounds appropriate to me.  Thanks.

> 
> The remaining patches are just straightforward fixes.
> 
> Please pull.

Pulled, and pushed to git://neil.brown.name/mdadm.

Do you have anything else in the works that you want to be in
3.0-final?
My pending list is now:
  - some more ddf self-tests
  - think about Doug's opinion on 'homehost'
  - review and update man pages.

which is unlikely to be all done this week, but maybe next week.
If you (or anyone else) has things that can be done in that time frame
and you want in 3.0-final, a heads-up would be appreciated.

Thanks,
NeilBrown
