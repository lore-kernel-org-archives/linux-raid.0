From: Rusty Lynch <rusty@linux.co.intel.com>
Subject: Re: Re: ANNOUNCE: User-space System Device Enumation
	(uSDE)
Date: Wed, 29 Oct 2003 16:37:20 -0800
Sender: cgl_discussion-bounces@lists.osdl.org
Message-ID: <20031030003720.GA6000@penguin.co.intel.com>
References: <3ACA40606221794F80A5670F0AF15F840215DC2F@pdsmsx403.ccr.corp.intel.com>
	<20031029190421.GA4173@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <cgl_discussion-bounces@lists.osdl.org>
Content-Disposition: inline
In-Reply-To: <20031029190421.GA4173@kroah.com>
List-Unsubscribe: <http://lists.osdl.org/mailman/listinfo/cgl_discussion>,
	<mailto:cgl_discussion-request@lists.osdl.org?subject=unsubscribe>
List-Archive: <http://lists.osdl.org/pipermail/cgl_discussion>
List-Post: <mailto:cgl_discussion@lists.osdl.org>
List-Help: <mailto:cgl_discussion-request@lists.osdl.org?subject=help>
List-Subscribe: <http://lists.osdl.org/mailman/listinfo/cgl_discussion>,
	<mailto:cgl_discussion-request@lists.osdl.org?subject=subscribe>
Errors-To: cgl_discussion-bounces@lists.osdl.org
To: Greg KH <greg@kroah.com>
Cc: linux-raid@vger.kernel.org, linux-hotplug-devel@lists.sourceforge.net, Lars Marowsky-Bree <lmb@suse.de>, "Ling,
	Xiaofeng" <xiaofeng.ling@intel.com>, "Guo,
	Min" <min.guo@intel.com>, Mark Bellon <mbellon@mvista.com>, linux-kernel@vger.kernel.org, cgl_discussion@osdl.org, Steven Dake <sdake@mvista.com>
List-Id: linux-raid.ids

On Wed, Oct 29, 2003 at 11:04:21AM -0800, Greg KH wrote:
<huge snip>
> In the interest of full disclosure, Min is one of the SDE authors, and I
> am one of the udev authors.

man... I saw this thread and thought there is no way in hell I am jumping in
this bloody mess.  oh well...
 
...and I told Min to help out on usde. 

> 
> Min, maybe you can answer why Intel has spent effort on this project
> instead of offering to help udev, which has been public for a long time
> now?
> 

I have never believed that any one implementation of (in CGL speak) "persistent
device naming" would be palatable by everyone, and have no problem in donating
some resources toward udev.  

In the past we experimented with udev, and even did a little work on
sysfsutils (which I though udev was using, but looking at udev-005 I still
see the libsysfs directory.)

I see the the TODO list in udev-005.  Are all these items wide open, or have
people already spoken for some parts?  Maybe you have a couple of items you 
consider higher priority?

    --rustyl
