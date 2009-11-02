From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: md[adm] device names
Date: Mon, 02 Nov 2009 14:14:53 +0300
Message-ID: <4AEEBF2D.4010107@msgid.tls.msk.ru>
References: <4AEC33A2.6050408@msgid.tls.msk.ru> <19182.16585.929763.745870@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <19182.16585.929763.745870@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>, martin f krafft <madduck@madduck.net>
List-Id: linux-raid.ids

Neil Brown wrote:
> On Saturday October 31, mjt@tls.msk.ru wrote:
>> Hello.
>>
>> Mdadm 3.x introduced a subdirectory for all md-related
>> deice nodes, /dev/md/.  (To be exact, that directory were
>> introduced earlier, but starting with 3.x it's the default
>> location).
> 
> sort of...
> Devices still get created as '/dev/mdXX', but symlinks are created
> with more meaningful names in /dev/md/, and those names are preferred.

Aha.  This is, in fact, _exactly_ what's needed, I think.
To keep ol'good mdNN in /dev and all the rest in /dev/md/.
I'll look at it all again - I think I misunderstand it
somehow.

>> The question is, the short form: can we get the naming back?
>> Or, at least, some plan for migration (with a justification
>> as of _why_ the move)?
> 
> Numbers are meaningless.  I would much rather have "/dev/md/home" or
> "/dev/md/backup" or whatever.  But as I said, old names should still
> work.

Up until now, md device NUMBERS were stable.

They aren't meaningful at all, as long as I know that my root is on
/dev/md1 and home is on /dev/md5, and fsck and mount all knows it too.

It was like this since the beginning.  Before md there were hda..hdc,
sda and the like, that were stable too, but not anymore.  Md device
numbers were always stable thanks to the preferredMinor field in the
superblock and mdadm honouring that.

It's even more.  Back at days (about 5 years or so ago), when I did
conversion from hdX to sdX on our machines, I (temporarily) used md
"arrays" consisting of single member, and used root=/dev/mdX instead
of /dev/hdX or /dev/sdX, because I knew mdN always refers to the same
thing.  (I don't remember why but LABEL=xx didn't work at that time
for me).

>> I tried new mdadm package on a Debian system.  And what
>> I ended up is a complete mess.
> 
> That is unfortunate.  Hopefully we can sort it out.
> 
>> The system boots with root=UUID=xyz parameter, even if
>> my /etc/fstab lists /dev/md1p1 as root device.
> 
> I don't understand what "even if" means here... it seems to imply a
> cause and an effect, but I don't see where either cause of effect is
> in the statement.  Please help me understand.

Well.  It's a good topic by its own (apparently not everyone agrees
here), and it has nothing to do with mdadm really.

In short: I for one prefer to have consistent parameters for root
filesystem in all relevant places.  If I used root=/dev/md1 in
fstab, I expect the same device is used in initramfs at least.
Apparently Debian initramfs package changes this behind the scenes
to be UUID=whatever instead.  If I wanted that, I'd used that in
fstab too, but I don't, I explicitly used /dev/mdN (or anything
else of this sort).  I understand where it all comes from initially,
I understand good and bad sides of this behind-the-back change, but
I still think it's a wrong place to fix.  In any way it has nothing
to do with mdadm as I already mentioned.

>> When it boots (during initramfs), the array gets assembled in
>> /dev/md/d1, even if mdadm.conf lists /dev/md1.  So the
>> mount(8) command lists root on /dev/md/d1p1.
> 
> /dev/md/d1 and /dev/md1 a definitely differ, not just different names
> for the same thing.
> /dev/md1 (which can also be named /dev/md/1) has a major number of 9
> and cannot be partitioned before 2.6.28.
> /dev/md/d1 (or /dev/md_d1) has a major number of around 253 and has
> always been partitionable.  Normally mdadm will prefer the first style
> and will only create the 'partitionable' style if explicitly asked to
> by e.g "--auto=part" or "CREATE part=yes" in mdadm.conf, or something
> similar.

Err.. no.  It actually was /dev/md/1, not /dev/md/d1.  The device
which got created and mounted in initramfs is /dev/md/1.

That just shows up the great confusion.  I'm with md since about 10
years, I even wrote my own tiny utility back in raidtools days to
help assemble the arrays during boot (initrd). I followed development
of mdadm.  But even I still make such mistakes as above...

> Is there a 'CREATE' line in your mdadm.conf?

No.  But Debian's initramfs thing might explicitly add these.
I'm not familiar with debian kernel/boot stuff (I always used
home-grown, and I'm sure that mine works and is consistent.
The issue happens when I tried to reproduce a bug in mdadm
(debian bugreport) and needed a native debian system).  I'll
take more closer look at this.

(In any way, since kernel is 2.6.30, all md devices are
partitionable).

>> When udevd is re-scanning device nodes from real root, it
>> creates /dev/md1 and not /dev/md/d1.
> 
> So the device must have a major number of 9.... something strange
> there.

No, see above.  The diff is /dev/md/1 or /dev/md1 - the former
gets created during initramfs stage and mounted as root fs,
the latter gets created when udevd scans existing device nodes
while on real root.

That's what bothered me and prompted me to write this whole
email to start with.  This is the main question really.

I _thought_ that mdadm moved mdN devices to md/N (which you
said it is not).  That'd explain everything I see here:
when mdadm _creates_ devices initially in initramfs, they
gets created in _new_ place (/dev/md/1) and gets mounted
from there (due to UUID=x instead of /dev/md1 conversion).
Next, when in real root, udevd scans the device tree it
finds md1 and creates /dev/md1 as kernel has, NOT /dev/md/1.

But apparently this is NOT the case and mdadm did NOT move
/dev/md1 to /dev/md/1.  At least according to your words.

This is my main complain.  Or was.

And for now, please hold on, I'll double check everything,
including debian changes to mdadm and debian's initramfs
thing.  Because the rest becomes moot if the move didn't
occur.

>> When update-initramfs script runs, mdadm-related parts
>> complains that there's no definition found for array
>> /dev/md/1_0.
> 
> /dev/md/1_0 would be a name that might be assigned to an array that
> was auto assembled in mdadm couldn't be sure that it belonged to
> 'this' host....

Well, with v0.9 superblocks it's not really easy to know.

And this is, in fact, yet another discussion topic by its
own.  I don't want to go into details right here.  The
qeustion occurs when creating arrays for different system,
and when using disks (and arrays) from different system.

> It would probably help a lot if you could report the contents of 
> /etc/mdadm/mdadm.conf, and the result of
>   mdadm -Evvs
> 
>> I understand that some of that are Debian-specific, probably
>> broken workarounds for the name change.  But the root cause
>> is the renaming, it looks like.
>>
>> So the question is, the long form:
>>
>>   Why the rename to start with?  The kernel already knows
>>   its devices by name, and uses _plain_ naming, without any
>>   subdirectory: like /sys/block/md1, /proc/partitions and
>>   so on.  I expect to find the names which are used by
>>   kernel in /dev as-is.  Other tools expexts the same,
>>   and some even complains and errors out if they can't
>>   (notable lilo).  If we want subdirectory, how about
>>   renaming them in the kernel?  But there aren't that
>>   many md devices to justify the subdirectory, IMHO.
>>
>>   I understand about symbolic names (home, volume0,
>>   backup etc) - those may go to /dev/md/home and so
>>   on.  But can we please, pretty please, make these
>>   a sumlinks to the real device nodes as kernel sees
>>   them?  Like all the /dev/disk/by-xx/* symlinks are?
>>   Since these are really just _aliases_ for the kernel
>>   device names...
> 
> They should be symlinks to the real devices...
> Maybe if you also report:
>   ls -l /dev/md*

Sure.  I'll do that and will examine other parts of the
puzzle too.

Thank you!

/mjt
