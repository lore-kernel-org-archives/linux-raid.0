From: Neil Brown <neilb@suse.de>
Subject: Re: [mdadm PATCH] Move symbol definitions from source files to
 Makefile.
Date: Sat, 30 Jan 2010 08:54:38 +1100
Message-ID: <20100130085438.41956bb5@notabene>
References: <20100128154745.31726.15500.stgit@awojcik-linux>
	<20100129204524.08a1d27a@notabene>
	<1264777558.2788.37.camel@awojcik-linux>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1264777558.2788.37.camel@awojcik-linux>
Sender: linux-raid-owner@vger.kernel.org
To: Artur Wojcik <artur.wojcik@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

On Fri, 29 Jan 2010 16:05:58 +0100
Artur Wojcik <artur.wojcik@intel.com> wrote:

> On Fri, 2010-01-29 at 09:45 +0000, Neil Brown wrote:
> > On Thu, 28 Jan 2010 16:47:45 +0100
> > Artur Wojcik <artur.wojcik@intel.com> wrote:
> > 
> > > This patch will move _GNU_SOURCE and _FILE_OFFSET_BITS=64 from
> > > various source files to Makefile.
> > 
> > Why?
> > 
> 
> The reason is to clean up the code. The new files will appear soon and I
> want this two definitions to be set globally instead of per source file.

Personally, I prefer them to be set just where they are needed.  You could
possibly convince me to put them in mdadm.h, but not in Makefile.

> 
> There's the plan to use GNU autotools to simply the build process, too.

That plan should be dropped immediately.  It won't happen.

NeilBrown
