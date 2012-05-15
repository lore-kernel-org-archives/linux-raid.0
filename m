From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [mdadm PATCH] bcache: add bcache superblock
Date: Tue, 15 May 2012 09:59:20 -0700
Message-ID: <CABE8wwu_TXJckRXg1eSny8TnciJ6GOM_Vy7FNW1FX84YT6QZzQ@mail.gmail.com>
References: <20120511203835.26301.1937.stgit@dwillia2-linux.jf.intel.com>
	<alpine.LNX.2.01.1205150042200.12473@stax.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LNX.2.01.1205150042200.12473-4jfXtw+jRJ582hYKe6nXyg@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Hills <mark-UrrBsZIrrsb10XsdtD+oqA@public.gmane.org>
Cc: neilb-l3A5Bk7waGM@public.gmane.org, koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-raid.ids

On Mon, May 14, 2012 at 5:04 PM, Mark Hills <mark-UrrBsZIrrsb10XsdtD+oqA@public.gmane.org> wrote:
> On Fri, 11 May 2012, Dan Williams wrote:
>
>> This is a hybrid proposal for supporting bcache as a md device.
>> Somewhat similar to the v1.x metadata format, where array assembly i=
s
>> handled in userspace, but managed in the kernel. =A0In the bcache ca=
se it
>> is an "external" metadata format, but then the expectation is that t=
he
>> kernel "bcache" personality takes over runtime maintenance of the
>> metadata.
>
> I am having some trouble with this, can you clarify (perhaps by examp=
le)
> how to create a pairing of a cache and backing device?
>
> I tried creating directly:
>
> =A0# mdadm --create /dev/md0 --level=3D11 --raid-devices=3D2 /dev/sdb=
 /dev/sdc
> =A0mdadm: unknown level 11
>
> But as the code in Assemble.c is patched (and not Create.c), I had a =
hunch
> to format the devices as before then assemble the array:

Yeah, "create" support is not there yet.

> =A0# make-bcache -C /dev/sdb
> =A0# make-bcache -B /dev/sdc
> =A0# mdadm -A /dev/md0 /dev/sdb /dev/sdc
> =A0mdadm: Cannot assemble mbr metadata on /dev/sdb

I should have been more explicit in the changelog.  This current patch
was only tested to assemble an existing bcache configuration.  I.e. it
assumes the backing device has been attached to the cache set at least
once.  By default make-bcache always creates a new cache-set id per
invocation.  So in the above example it won't find sdb and sdc belong
to the same md device because the cache-set id's differ.  You can
verify this with mdadm -E.

[..]
>
> Maybe I missed something basic here, but I'm afraid can't see what? I=
f
> not, hopefully this information is useful.
>
> I use bcache v13 patches and the MD conversion, and this patch to mda=
dm.

=46or reference:

[root@fedora-virt ~]# mdadm -E /dev/vd[bc]
/dev/vdb:
       Magic : <bcache>
     Version : 3
        Role : cache
    Set UUID : e8670bc3:974b489c:aeb68ea1:d1adf6d1
  Cache Devs : 1
 Device UUID : a1b25e26:5a4c4db6:2716c1aa:eba44ec7
       Flags : sync
      Policy : lru
       Label :
 Device Size : 16776192 (8.00 GiB 8.59 GB)
 Bucket Size : 1024
 Num Buckets : 16384
    this dev : 0
=46irst Bucket : 1
    Checksum : 45fa97cda53b0b6 correct
/dev/vdc:
       Magic : <bcache>
     Version : 1
        Role : backing-device
    Set UUID : e8670bc3:974b489c:aeb68ea1:d1adf6d1
  Cache Devs : 1
 Device UUID : 7045ff87:aa4b13c4:670d8bb2:0b4ad628
       Flags : sync
       State : clean
        Mode : writeback
       Label :
 Device Size : 16776192 (8.00 GiB 8.59 GB)
 Bucket Size : 1024
 Num Buckets : 16384
    this dev : 0
=46irst Bucket : 1
    Checksum : f36910e51451d91c correct
[root@fedora-virt ~]# mdadm -Avvv /dev/md/bcache /dev/vd[bc]
mdadm: looking for devices for /dev/md/bcache
mdadm: /dev/vdb is identified as a member of /dev/md/bcache, slot 0.
mdadm: /dev/vdc is identified as a member of /dev/md/bcache, slot 1.
mdadm: added /dev/vdb to /dev/md/bcache as 0
mdadm: added /dev/vdc to /dev/md/bcache as 1
mdadm: Container /dev/md/bcache has been assembled with 2 drives
[root@fedora-virt ~]# cat /proc/mdstat
Personalities : [bcache]
md126 : active bcache vdb[1] vdc[0]
      8388096 blocks super external:/md127/0 8388096k cache-blocks

md127 : inactive vdc[1](S) vdb[0](S)
      16 blocks super external:bcache

unused devices: <none>
