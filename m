From: "Mike Garey" <random51k@gmail.com>
Subject: Re: Can't mount /dev/md0 after stopping a synchronization
Date: Sat, 8 Apr 2006 11:45:03 -0400
Message-ID: <c79e949d0604080845m720f2bard3a140486155c006@mail.gmail.com>
References: <c79e949d0604042045w2fb901c2rfb4c00984f6b8761@mail.gmail.com>
	 <4433E073.8040502@fnuck.dk>
	 <c79e949d0604050839k2287fefdm53f6abb08dfcae89@mail.gmail.com>
	 <5b170a7d0604050920p674e10a9u9e26a52fcf3933c1@mail.gmail.com>
	 <c79e949d0604050959o6feb6badx5f854a937a337a1d@mail.gmail.com>
	 <5b170a7d0604070617s304b3366i4573e97b4fbe6650@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5b170a7d0604070617s304b3366i4573e97b4fbe6650@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> On 4/5/06, Jim Klimov <klimov@2ka.mipt.ru> wrote:
> > I'm afraid I haven't seen your first messages in detail. Sorry, if I
> > repeat the lines you already know by heart ;)
> >
> > Nevertheless, do you by chance have the ability to rebuild your
> > kernel, or are you keen on making MD work from initrd and some stock
> > kernel?
>
> right now I'm using a custom built kernel with md and raid1 built into
> it and it works fine (although I get the same EXT2-fs warning as with
> the initramfs image early on in the boot process, but it seems to end
> up being mounted as ext3 when the system finally boots).  As I
> mentioned above, I'm now trying to get the initramfs version working,
> since it'd be nice to have a solution that works with the standard
> prepackaged kernel.

Well, I figured out why I was getting the EXT2-fs warning: I had
forgotten to build ext3 support into the kernel..  I don't think I
damaged my disk though, cause it mounts the system as read-only at
first, and by the time it mounts it read-write, the ext3 module is
loaded.

I've also finally managed to get /dev/md0 mounted while booted from an
initramfs image.  I used the stock debian mkinitramfs script and for
some reason it decided to start working.  I really can't figure out
why I had so much trouble with it in the beginning, but it seemed to
start working after I had manually entered the command "mdadm
-Acpartitions --super-minor=0 --auto=part /dev/mda" after being
dropped into busybox - perhaps this changed the superblocks on
/dev/hdc1 or something that I'm not aware of..

On 4/7/06, Tuomas Leikola <tuomas.leikola@gmail.com> wrote:
> BTW, if you're still having problems with sync speed, try fiddling around with
>
> /proc/sys/dev/raid/speed_limit_min
>
> as the md sync speed detection code is not foolproof (at least lvms as
> component devices has fooled it on occasion).

I ended up changing the number in /proc/sys/dev/raid/speed_limit_min to
150000.  I also disconnected the CDROM from the secondary IDE channel,
replaced the 40 conductor cable with an 80 conductor cable and enabled
UDMA mode 5 on both my hard drives.  I now get the following when
syncing:

[12:44AM][mike@asterisk]% cat /proc/mdstat
Personalities : [raid1]
md0 : active raid1 hda1[2] hdc1[1]
  158577472 blocks [2/1] [_U]
  [>....................]  recovery =  0.2% (469056/158577472)
finish=78.6min speed=33504K/sec

So it seems I managed to get the sync time down from 25 hours to 78,
which of course is much more reasonable ;)

I have one last question though.. When I update /boot/grub/menu.lst
while booted from /dev/md0 with both disks available, does this file
get written to the MBR on both disks, or do I have to do this
manually?

Just wanted to say thanks to everybody that helped and offered advice,
I'm really glad that I finally managed to resolve this problem - even
with a backup, I still get very worried about messing with my data.

Mike
