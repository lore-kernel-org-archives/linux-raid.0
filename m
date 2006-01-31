From: Jason Lunz <lunz@falooley.org>
Subject: Re: 2.6.15: mdrun, udev -- who creates nodes?
Date: Tue, 31 Jan 2006 15:52:03 -0500
Message-ID: <20060131205202.GD27268@knob.reflex>
References: <43DCA9CA.5020505@bl.com> <20060129123532.GA6158@wonderland.linux.it> <43DCD614.20705@pobox.com> <20060130204231.GP19465@austin.ibm.com> <20060130204743.GA13902@wonderland.linux.it> <dro3ue$ntb$1@sea.gmane.org> <20060131192643.GU19465@austin.ibm.com> <62b0912f0601311219x78cbb29dof3768c1449bc8349@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-hotplug-devel-admin@lists.sourceforge.net>
In-Reply-To: <62b0912f0601311219x78cbb29dof3768c1449bc8349@mail.gmail.com>
Content-Disposition: inline
Sender: linux-hotplug-devel-admin@lists.sourceforge.net
Errors-To: linux-hotplug-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel>,
	<mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux-hotplug-devel@lists.sourceforge.net>
List-Help: <mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel>,
	<mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-hotplug-devel>
To: Molle Bestefich <molle.bestefich@gmail.com>
Cc: linas <linas@austin.ibm.com>, neilb@suse.de, linux-hotplug-devel@lists.sourceforge.net, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jan 31, 2006 at 09:19:16PM +0100, Molle Bestefich wrote:
> I *think* that "the raid developers" may be, for once, choosing words
> not-so-wisely when talking about "deprecating autoassembly".

You're right, I should be careful not to imply anything Neil didn't
actually say. What he said was:

> From: Neil Brown <neilb <at> suse.de>
...
> And if other partition styles wanted to add support for raid auto
> detect, tell them "no". It is perfectly possible and even preferable
> to live without autodetect.   We should support legacy usage (those
> above) but should discourage any new usage.

which is a far cry from officially deprecating anything. My point was
that the outlined solution for having udev create /dev/md* nodes could
not work on all platforms because it required raid autodetect, and it
looks unlikely that raid autodetect will be universally supported.

Jason


-------------------------------------------------------
This SF.net email is sponsored by: Splunk Inc. Do you grep through log files
for problems?  Stop!  Download the new AJAX search engine that makes
searching your log files as easy as surfing the  web.  DOWNLOAD SPLUNK!
http://sel.as-us.falkag.net/sel?cmd=lnk&kid=103432&bid=230486&dat=121642
