From: Artur Wojcik <artur.wojcik@intel.com>
Subject: Re: [mdadm PATCH] Move symbol definitions from source files to
 Makefile.
Date: Fri, 29 Jan 2010 16:05:58 +0100
Message-ID: <1264777558.2788.37.camel@awojcik-linux>
References: <20100128154745.31726.15500.stgit@awojcik-linux>
	 <20100129204524.08a1d27a@notabene>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100129204524.08a1d27a@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

On Fri, 2010-01-29 at 09:45 +0000, Neil Brown wrote:
> On Thu, 28 Jan 2010 16:47:45 +0100
> Artur Wojcik <artur.wojcik@intel.com> wrote:
> 
> > This patch will move _GNU_SOURCE and _FILE_OFFSET_BITS=64 from
> > various source files to Makefile.
> 
> Why?
> 

The reason is to clean up the code. The new files will appear soon and I
want this two definitions to be set globally instead of per source file.

There's the plan to use GNU autotools to simply the build process, too.

Thanks,
Artur


