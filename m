From: "Peter T. Breuer" <ptb@it.uc3m.es>
Subject: Fast (intelligent) raid1
Date: Thu, 23 Jan 2003 18:07:02 +0100 (MET)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200301231707.h0NH72U31504@oboe.it.uc3m.es>
Reply-To: ptb@it.uc3m.es
Mime-Version: 1.0
Content-Type: text/plain; charset=UNKNOWN-8BIT
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
To: mingo@redhat.com, neilb@cse.unsw.edu.au, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Ingo, Neil, ...

Apologies if you receive this twice.  I was going to write to you
individually, but when I scanned the kernel maintainers file, I saw the
linux-raid list mentioned, and it didn't seem fair to be secretive, so
I'm cc=EDng the list on it and you'll probably get this twice.

Sorry!

What I'm writing about is the driver I just put up on

   ftp://oboe.it.uc3m.es/pub/Programs/fr1-1.0.tgz

It's an "intelligent RAID1" driver. It only resyncs what's necessary
instead of resyncing the whole disk.

As you surely have experienced, it can take hours to resync a big
device, even if it's local.  In my case - as the author and maintainer
of ENBD, a network device - the mirror components are hardly ever local
and I don't get more than about 6MB/s across the net.  It takes me
quarter of an hour to resync an array that passes the 4GB mark, and
that's too long for testing.  There are people with arrays out there
approaching 2TB now, and they say they spend half a day resyncing.

So, in self-defence, I put intelligent mirroring into ENBD.  But the
result is too big too manage, code-wise.  So I spent the last month
separating it out again.  Now it's a separate module (2.5KLOC), and I
made it accept the kernels md ioctls, so it works under the raidtools2,
can be listed in raidtab, etc.  etc.

However, raidtools2 is hardcoded to use the md major of 9, and that I
can't use.  So I made the major of the module adjustable with a major=3D
parameter as you install it.  I also made the trivial patch to
raidtools2 available.  Plea: can somebody liberalize the tools?  There'=
s
no need to check for major 9, as if the device isn't 9, it won't
understand the ioctls anyway!

The alternative is to recast the fr1 module as a dependency of
the md module. I'd like to do that.

There I'd like to ask for somebody's help.  I'd like to do it.  But I
need to be told how the persistent superblock stuff works.  I already
emulated the version, arrayinfo information, and other bits and pieces,
but simply by reverse engineering what the raidtools used as calls.  I'=
d
really appreciate any help that could be offered.

I'll append the announcement I made on the ENBD mailing list a short
while ago. It contains some details of operation that may be helpful
in getting the picture. I'll explain more of what happens in further
mail if a conversation develops.

Please cc: me as I am not on the linux-raid list to my knowledge
(though I am on the kernel list, and many others, and the omission
is not particularly deliberate!).

The current code took its first working tests a couple of days ago,
and reached full functionality today.  I'm still not sure if it can
detect and react to underlying device errors appropriately (I gave
raidhotgenerateerror some real functiinality in order to test, thgough =
I
see it's nulled out in the kernel md code).  I am not sure if I have
made the buffer heads I send to the mirror components age fast enough,
or if I should wait for each request completion instead of firing and
forgetting.  I haven't throttled the resync but it should go slow enoug=
h
as I scheduled after every block.

The message below contains various snapshots that tell the tale.


I'll either move on to do intelligent raid4 now, or aim for the
integration with the md code.


Peter

----- Forwarded message from Peter T. Breuer -----

I separated the "intelligent raid1" code out from enbd-2.4.31 and
put it in a separate driver. It's now available as

   ftp://oboe.it.uc3m.es/pub/Programs/fr1-1.0.tgz

I've just got it up to working functionality. I haven't tried stressing
it. It runs under the standard raidtools if you load it with major=3D9.
You have to patch the tools to "liberalize" them if you use another
major. I included a patch.


I'll include the (hastily written in the train last night) README here.


Mmmph .. major limitation: it only has blocksize 1024, like the rest
of softraid. I'll fix that in parallel with other work. It's therefore
limited to 4TB in size, I think, as the block count is a u32. Maybe
even 2TB, as the sector count is a u32 too.


If anybody would like to make it into a proper md -dependent module,
I'd be very much obliged. That involves understanding the md devices
persistent superblock stuff. At the moment there is no permanent
superblock.



fr1 README (C) Peter T. Breuer Jan 2003.


This is the README for the intelligent fast RAID1 driver, "fr1".  It's
"intelligent" in that it doesn't blindly resynchronize a whole mirror
component when only a few blocks need resyncing.  That can save hours o=
f
resync time on a large device.

The driver keeps a bitmap of pending writes in memory, and writes them
to the mirror component that's just been repaired when it comes back on
line.  The bitmap is two-level and created pagewise on demand, so it's
not too expensive.  A terabyte sized device with blocks of 4K will cost
max 32MB of memory per mirror component, thus 64MB max for a two
component mirror.  The driver is tolerant wrt memory faults too.  It'll
still work if you run out of memory, just be a little less intelligent.

HOW TO MAKE THE MODULE

   Edit the Makefile in this directory, change LINUXDIR to point to the
   kernel source for your target kernel, and type "make".  Put the fr1.=
o
   module in the misc/ subdirectory of your kernel modules in
   /lib/modules/2.4.whatever/. Run /sbin/depmod -a.

HOW TO USE IT:

  0) Insert the module into the kernel with "insmod fr1.o".  Now, by
  default it will take major 240, and the raid tools won't work with
  that, so if you want to let it go ahead and use its default major,
  then you will have to patch the raidtools.  Do it like this ...

        i) Get the raidtools2 package
        ii) remove the 5 or 6 if clauses in the C code that test that t=
he
           major of the block device just stated is the MD_MAJOR (9).=20
        iii) compile ("make") and install ("make install") as usual.

Let me just remark that you now have a more tolerant set of raid tools,
and they'll work with fr1 whatever its major.  I'll include a patch for
raidtools2 in this directory (raidtools2-0.90.20010914.patch), and try
and persuade the authors to liberalize the base code, but the changes
are obvious.

If you don't want to patch the raid tools, then you will have to load
fr1 and make it use major 9, the md major. Like this:

  insmod fr1.o major=3D9

=46or that to work, the kernel md module must NOT be loaded.  You can t=
ell
if it's loaded by doing "cat /proc/devices" and seeing if block major 9
is listed already.  If it is, bad luck.  You maybe have md.o loaded, an=
d
can unload it with "rmmod md" (preceded by "rmmod raid1" and whatever
other modules are loaded on top of it).  Or it may be built in to the
kernel, in which case you're sorely out of luck.  Maybe there's a kerne=
l
boot paramter to disable md.  I don't know.  It would be "md=3Doff" if
anything. To continue ...

  Once you have the driver fr1 loaded, you should see it bound to its
  major when you do "cat /proc/devices". It'll be visible with lsmod
  too.

  To use it, you use the (maybe modified, as remarked above) raid
  tools.


  1) if you are using a non-md major, then you will have to make some
  nodes in /dev. Do (for example)

      mknod /dev/fr10 b 240 0
      mknod /dev/fr11 b 240 1
      mknod /dev/fr12 b 240 2
      mknod /dev/fr13 b 240 3

  otherwise, if using the md major, 9, make sure that /dev/md[0-3]
  are present and correct. If not, make them:

      mknod /dev/md0 b 9 0
      mknod /dev/md1 b 9 1
      mknod /dev/md2 b 9 2
      mknod /dev/md3 b 9 3

  2) edit /etc/raidtab and put in an entry for a typical raid1 mirror
  device for /dev/fr10 or /ev/md0, or whatever corresponds to the major
  you are using. Here's an example:


       raiddev /dev/fr10
           raid-level              1
           nr-raid-disks           2
           nr-spare-disks          0
           persistent-superblock   0
           chunk-size              4

           device                  /dev/loop0
           raid-disk               0

           device                  /dev/loop1
           raid-disk               1


That was for a two-way mirror with two loop devices as components. The
target is /dev/fr10.


  3) make the mirror in the usual way with the mkraid utility. For
  example:

    mkraid --dangerous-no-resync --force /dev/fr10


I don't see the point of NOT using --dangerous-no-resync. You can
always do it in a moment.

At this point you can "cat /proc/fr1stat" and see how things look.
Here is how they should look for the raidstat configuration detailed
above.

  Personalities : [raid1]=20
  read_ahead 4 sectors
  fr10 : active fr1 [dev 07:00][0] [dev 07:01][1]
        1024 blocks
     =20

  4) You can now manipulate the mirror with the raidsetfaulty,
  raidhotremove, and raidhotadd tools.  Raidstop and raidstart might
  also be useful.

  The only difference with respect to normal usage is that a raidhotadd
  will WORK after a raidsetfaulty. You don't have to do a raidhotremove
  first. If you do the raidhotadd after a raidsetfaulty, then ONLY THE
  BLOCKS NOT WRITTEN IN THE INTERVAL are resynced. Not the whole device=
=2E
  So you want to do this!

=46or example, to fault one mirror component:

  raidsetfaulty /dev/fr10 /dev/loop0

After this, the output from /proc/fr1stat will show a failed component.
It wont't be written to or read:

  Personalities : [raid1]=20
  read_ahead 4 sectors
  fr10 : active fr1 [dev 07:00][0] [dev 07:01][1](F)
        1024 blocks
     =20
Then to put the "failed" component back on line:

  raidhotadd /dev/fr10 /dev/loop0

and the situation will return to normal, immediately. Only a few
dirtied blocks will have been written to the newly added device.

  Personalities : [raid1]=20
  read_ahead 4 sectors
  fr10 : active fr1 [dev 07:00][0] [dev 07:01][1]
        1024 blocks


If you want to take the "failed" component fully offline, then you must
follow the raidsetfaulty with a

  raidhotremove /dev/fr10 /dev/loop0

After this, you can still put the component back with raidhotadd,
but the background resync will be total. You really want to avoid that.

Oh yes. You can now mkfs on the device, mount it, write files to it,
etc. To stop (and deconfigure) the device, do

  raidstop /dev/fr10

No, I don't know what raidstart is supposed to do on a non-persistent
array. It doesn't do anything on fr1.

If you fault one device, then write to the device, then hotadd the
faulted device back in, you should be able to see from the kernel
messages (use "dmesg") that the resync is intelligent.  Here's some
dmesg output:

  fr1 resync starts on device 0 component 1 for 1024 blocks
  fr1 resynced dirty blocks 0-9
  fr1 resync skipped clean blocks 10-1023
  fr1 resync terminates with 0 errs on device 0 component 1
  fr1 hotadd component 7.1[1] to device 0

This resync only copied across blocks 0-9, and skipped the rest.

While the resync is happening, /proc/fr1stat will show progress, like
so:

  Personalities : [raid1]=20
  read_ahead 4 sectors
  fr10 : active fr1 [dev 07:00][0] [dev 07:01][1](F)
        1024 blocks
         [=3D=3D=3D=3D=3D=3D=3D>.............]  resync=3D35.5% (364/102=
4)



Peter T. Breuer  (ptb@it.uc3m.es)  Jan 2003.

_______________________________________________
ENBD mailing list
ENBD@lists.community.tummy.com
http://lists.community.tummy.com/mailman/listinfo/enbd

----- End of forwarded message from Peter T. Breuer -----
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
