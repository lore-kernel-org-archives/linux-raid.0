From: Neil Brown <neilb@suse.de>
Subject: Re: md as module cannot be reloaded.
Date: Thu, 2 Dec 2010 08:57:23 +1100
Message-ID: <20101202085723.59a5694e@notabene.brown>
References: <66C59AD0932712458090B447266D638C0109FF2E8A@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <66C59AD0932712458090B447266D638C0109FF2E8A@irsmsx504.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Czarnowska, Anna" <anna.czarnowska@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

On Wed, 1 Dec 2010 14:23:14 +0000 "Hawrylewicz Czarnowski, Przemyslaw"
<przemyslaw.hawrylewicz.czarnowski@intel.com> wrote:

> Hi,
> 
> I have found an annoying problem with md module. If it is compiled as loadable module it is impossible to reload module if unloaded once.
> 
> Eg.
> # mdadm -Ss
> # modprobe -r raid1 && modprobe -r md-mod
> # cat /proc/modules | grep md_mod || echo Unloaded
> Unloaded
> # cat /proc/mdstat
> cat /proc/mdstat: Invalid arguments

I cannot reproduce this.  That this point I get 

cat: /proc/mdstat: No such file or directory


> # modprobe md-mod
> # cat /proc/mdstat
> cat /proc/mdstat: Invalid argument
> # cat /proc/modules | grep md_mod || echo Unloaded
> md_mod 94178 0 - Live 0xf857a000
> 
> Some functionalities seem to work, but nothing is able to read /proc/mdstat.
> 
> If have tried few kernels from 2.6.27 to 2.6.37-rc3, openSUSE 11.x/RHEL6, doesn't matter, still the same result. What can be wrong?

openSUSE doesn't compile md as a module, it is compiled in to the kernel.
But presumably you are compiling your own kernel with md as a module?  Is
that right?  You aren't compiling a module and loading it into a kernel which
already has md in it are you?  I don't think that would work anyway...

And you give a full sequence of commands from loading to unload that reliably
produces this error for you?

NeilBrown

