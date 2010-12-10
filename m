From: "Hawrylewicz Czarnowski, Przemyslaw"
	<przemyslaw.hawrylewicz.czarnowski@intel.com>
Subject: RE: md as module cannot be reloaded.
Date: Fri, 10 Dec 2010 11:57:51 +0000
Message-ID: <66C59AD0932712458090B447266D638C010C0E5B1C@irsmsx504.ger.corp.intel.com>
References: <66C59AD0932712458090B447266D638C0109FF2E8A@irsmsx504.ger.corp.intel.com>
 <20101202085723.59a5694e@notabene.brown>
 <66C59AD0932712458090B447266D638C0109FF332F@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <66C59AD0932712458090B447266D638C0109FF332F@irsmsx504.ger.corp.intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Hawrylewicz Czarnowski, Przemyslaw
> Sent: Thursday, December 02, 2010 12:42 AM
> To: Neil Brown
> Cc: linux-raid@vger.kernel.org; Labun, Marcin; Czarnowska, Anna; Neubauer,
> Wojciech; Williams, Dan J; Ciechanowski, Ed
> Subject: RE: md as module cannot be reloaded.
> 
> > -----Original Message-----
> > From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> > owner@vger.kernel.org] On Behalf Of Neil Brown
> > Sent: Wednesday, December 01, 2010 10:57 PM
> > To: Hawrylewicz Czarnowski, Przemyslaw
> > Cc: linux-raid@vger.kernel.org; Labun, Marcin; Czarnowska, Anna;
> Neubauer,
> > Wojciech; Williams, Dan J; Ciechanowski, Ed
> > Subject: Re: md as module cannot be reloaded.
> >
> > On Wed, 1 Dec 2010 14:23:14 +0000 "Hawrylewicz Czarnowski, Przemyslaw"
> > <przemyslaw.hawrylewicz.czarnowski@intel.com> wrote:
> >
> > > Hi,
> > >
> > > I have found an annoying problem with md module. If it is compiled as
> > loadable module it is impossible to reload module if unloaded once.
> > >
> > > Eg.
> > > # mdadm -Ss
> > > # modprobe -r raid1 && modprobe -r md-mod
> > > # cat /proc/modules | grep md_mod || echo Unloaded
> > > Unloaded
> > > # cat /proc/mdstat
> > > cat /proc/mdstat: Invalid arguments
> >
> > I cannot reproduce this.  That this point I get
> >
> > cat: /proc/mdstat: No such file or directory
> >
> >
> > > # modprobe md-mod
> > > # cat /proc/mdstat
> > > cat /proc/mdstat: Invalid argument
> > > # cat /proc/modules | grep md_mod || echo Unloaded
> > > md_mod 94178 0 - Live 0xf857a000
> > >
> > > Some functionalities seem to work, but nothing is able to read
> > /proc/mdstat.
> > >
> > > If have tried few kernels from 2.6.27 to 2.6.37-rc3, openSUSE
> 11.x/RHEL6,
> > doesn't matter, still the same result. What can be wrong?
> >
> > openSUSE doesn't compile md as a module, it is compiled in to the kernel.
> > But presumably you are compiling your own kernel with md as a module?  Is
> > that right?  You aren't compiling a module and loading it into a kernel
> > which
> > already has md in it are you?  I don't think that would work anyway...
> Yes, I have recompiled kernel with MD as module.
> 
> >
> > And you give a full sequence of commands from loading to unload that
> > reliably
> > produces this error for you?
> Ok, here you are:
> * Original opensuse config updated to new kernel with defaults
> * Changed CONFIG_BLK_DEV_MD=y->m
> * Added prefix -mdadm
> 
> make
> su
> make modules_install
> make install
> mdadm -Ss
> mdadm --zero-superblock /dev/sd[b-g]
> reboot
> ...
> localhost:~ # uname -r
> 2.6.37-rc3-pae-mdadm
> localhost:~ # cat /proc/mdstat
> cat: /proc/mdstat: No such file or directory
> localhost:~ # cat /proc/modules | grep md_mod
> localhost:~ # modprobe md_mod
> localhost:~ # ll /proc/mdstat
> -r--r--r-- 1 root root 0 Dec  2 00:14 /proc/mdstat
> localhost:~ # cat /proc/mdstat
> Personalities :
> unused devices: <none>
> localhost:~ # modprobe -r md_mod
> localhost:~ # ll /proc/mdstat
> -r--r--r-- 1 root root 0 Dec  2 00:14 /proc/mdstat
> localhost:~ # cat /proc/mdstat
> cat: /proc/mdstat: Invalid argument
> localhost:~ # modprobe -r md_mod
Here is just "modprobe md_mod" of course...
> localhost:~ # ll /proc/mdstat
> -r--r--r-- 1 root root 0 Dec  2 00:14 /proc/mdstat
> localhost:~ # cat /proc/mdstat
> cat: /proc/mdstat: Invalid argument
> 
> that's all.
And another scenario - it might put some new light at this problem:

[system right after restart]

localhost:~ # mdadm -Ss
mdadm: stopped /dev/md126
mdadm: stopped /dev/md127
localhost:~ # cat /proc/mdstat
Personalities : [raid1]
unused devices: <none>
localhost:~ # modprobe -r raid1
localhost:~ # ll /proc/mdstat
-r--r--r-- 1 root root 0 Dec  9 16:52 /proc/mdstat
localhost:~ # cat /proc/mdstat
cat: /proc/mdstat: Invalid argument

One more thing... For some time everything worked perfectly. And problem appeared again after few days.
I do not remember any unusual activity which may change this behavior.

> 
> >
> > NeilBrown
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
