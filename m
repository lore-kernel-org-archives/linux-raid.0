From: Nix <nix@esperi.org.uk>
Subject: Re: A random initramfs script
Date: Fri, 17 Mar 2006 00:41:17 +0000
Message-ID: <87r751q4wi.fsf@hades.wkstn.nix>
References: <87u0a0so6w.fsf@hades.wkstn.nix>
	<20060315002527.GO27173@skl-net.de> <87lkvcrtzu.fsf@hades.wkstn.nix>
	<20060315185750.GP27173@skl-net.de> <87hd5zs9zm.fsf@hades.wkstn.nix>
	<20060316002330.GT27173@skl-net.de> <87zmjqq14r.fsf@hades.wkstn.nix>
	<20060316234613.GX27173@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060316234613.GX27173@skl-net.de> (Andre Noll's message of
 "Fri, 17 Mar 2006 00:46:13 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 17 Mar 2006, Andre Noll stated:
> On 07:50, Nix wrote:
>> If / was a ramfs (as rootfs is), you'd run out of memory...
> 
> Yes, it's an additional piece of rope, and I already used it to shoot
> myself in the foot by doing a backup with "rsync -a /home /mnt" without
> mounting /mnt. First the machine went slow, then the OOM killer kicked
> in and killed everything. Finally the system was totally unresponsible
> and I had to use the "so everything is unusual - boot" thing.

Oops!

> But only root can write to /mnt, and there are much simpler ways for
> root to halt the system..

True. I guess I'm a traditionalist: I'd like / to be a real filesystem
if possible. Both ways work: TMTOWTDI :)

>> Well, there's some extra stuff, but it's mostly on the iptables side:
>> the advanced routing has mostly been stable since not just 2.4 but 2.2!
> 
> So I downloaded iproute2-2.4.7-now-ss020116-try.tar.gz, but there
> seems to be a problem with errno.h:

Holy meatballs that's ancient.

Try <http://developer.osdl.org/dev/iproute2/download/iproute2-2.6.15-060110.tar.gz>
for a rather newer and more capable copy. :)

>> You don't need an mdev.conf at all; by default mdev creates a /dev with
>> the KERNEL= names. All it's needed for is putting things in strange
>> places or fiddling permissions, and that's not necessary for a boot
>> initramfs :)
> 
> Nice, and works like a charm. I just removed udev* from the initramfs.

For those places that are still using udev, if you're running 2.6.15+,
you can soon ditch udevstart, as distros are doing the moral equivalent
of this nowadays:

,----
| udevd --daemon
|
| list=$(echo /sys/bus/*/devices/*/uevent /sys/class/*/*/uevent)
| list=$(echo $list /sys/block/*/uevent /sys/block/*/*/uevent)
| 
| for file in $list; do
|   case "$file" in
|     */device/uevent) ;;        # skip followed device symlinks
|     */\*/*) ;;
|     *" "*) ;;
| 
|     */class/mem/*)             # for /dev/null
|       first="$first $file" ;;
| 
|     */block/md[0-9]*)
|       last="$last $file" ;;
| 
|     *)
|       default="$default $file" ;;
|   esac
| done
| 
| for file in $first $default $last; do
|   echo 'add' > $file
| done
`----

Yes, the initial population of /dev is done by firing messages at udevd
*from a shell script*. It's gone all the way from devfs's kernel-space
hardwiring to something sufficiently extensible that a shell script can
do all the neessary stuff to populate /dev :)

(This is also much faster than udevstart; <1s to populate a crowded /dev
on my P233...)

>> (I'd recommend managing the *real* /dev with udev, still; it's vastly
>> more flexible... 
> 
> Yes, and it's needed for hotplugable devices anyway.

mdev can handle hotplugging: leave the -s off. But yes, udev is probably
preferable on non-space-constrained systems, for much the same reason
that glibc is preferable to uClibc in those situations.

>> but of course it's also about fifty times larger at a
>> horrifying 50K plus 70K of rules...
>  
> No need for such a huge rules file:
> 
> # find  /etc/udev/ -type f -printf '%f %s\n'
> udev.conf 768
> udev.rules 5200
> scsi-model.sh 1326
> ide-model.sh 1201

Er, true. Actually I goofed: I du -s'd the directory and forgot that I
was keeping it in subversion... I'm actually using 10K of rules. Not
a very accurate estimate on my part, that.

[uClibc]
>> Yep. Of course the SVN release has broken binary compatibility, so you
>> need to rebuild everything that depends on it (probably the
>> cross-toolchain too, for safety). I scripted this long ago, of course,
>> because it's a bit annoying otherwise...
> 
> I tried to built the cross-compilation toolchain with Buildroot,
> but it didn't even start building because it couldn't download gcc
> from mirrors.rcn.net which appears to be down ATM. Isn't it possible
> to change the gcc mirror? I did not find a config option for that.

I wouldn't know: I don't use buildroot. Bugging the buildroot author
(who also happens to be the uClibc author) might be a good idea.

Alternatively, just suck down GCC from, say, svn://gcc.gnu.org/svn/gcc/tags/gcc_3_4_5_release,
or ftp.gnu.org, or somewhere, and point buildroot at that. (I hope
you can do that: like I say, I've never done more than suck buildroot
down to pull the uClibc patches out of it and apply them to the
dev trees of binutils and GCC that I already had...)

-- 
`Come now, you should know that whenever you plan the duration of your
 unplanned downtime, you should add in padding for random management
 freakouts.'
