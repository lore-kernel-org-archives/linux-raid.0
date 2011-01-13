From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: open_dev_excl in reshape_container() fails
Date: Thu, 13 Jan 2011 09:27:34 -0800
Message-ID: <AANLkTinKyBbX7S-yaM_FG=HU0ABuAzw+FxaUgdZPzy0Q@mail.gmail.com>
References: <905EDD02F158D948B186911EB64DB3D176E5A1BC@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <905EDD02F158D948B186911EB64DB3D176E5A1BC@irsmsx503.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Kwolek, Adam" <adam.kwolek@intel.com>
Cc: "neilb@suse.de" <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

2011/1/13 Kwolek, Adam <adam.kwolek@intel.com>:
> Hi,
>
> I've got a problem using open_dev_excl() in reshape_container(), it fails. This functions goes down
> and calls open() with flags O_DIRECT| O_RDWR| O_EXCL.
> It fails in reshape_container(), ealier in Grow_reshape() exactly the same test call to open_dev_excl() succeed.
> Between test open and open in reshape_container() there is no other open() performed (or other i/o operation that can cause problem).
> It not depends on mdmon action because it is the same for raid5 and raid0.
> Function open_dev() works, and I'm using it as workaround.
>
> In man pages for open() is told that O_EXCL flag should be used with O_CREAT flag only.
> I've read in manual for open() also: "If O_EXCL is set and O_CREAT is not set, the result is undefined"

Right, it is undefined with respect to Posix, but for Linux O_EXCL on
a block device without O_CREAT is defined to bd_claim the block
device.

http://www.kernel.org/doc/man-pages/online/pages/man2/open.2.html

The second call to open_dev_excl is a bug, by definition you can't
exclusive open twice.  Can you reuse the fd established in
Grow_reshape?

--
Dan
