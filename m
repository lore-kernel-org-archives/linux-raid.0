From: NeilBrown <neilb@suse.de>
Subject: Re: What the heck happened to my array?
Date: Tue, 5 Apr 2011 16:10:43 +1000
Message-ID: <20110405161043.00d54901@notabene.brown>
References: <4D9876E4.6080501@fnarfbargle.com>
	<AANLkTi=2GNYdySbCDXmaDC8-8vF8GU9V3Uoy1qByNq58@mail.gmail.com>
	<4D995E27.3060800@fnarfbargle.com>
	<BANLkTi=prv_vzfJr2JJt3LLhdB0GFSMy4w@mail.gmail.com>
	<4D9A6694.4040606@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D9A6694.4040606@fnarfbargle.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <lists2009@fnarfbargle.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 05 Apr 2011 08:47:16 +0800 Brad Campbell <lists2009@fnarfbargle=
=2Ecom>
wrote:

> On 05/04/11 00:49, Roberto Spadim wrote:
> > i don=B4t know but this happened with me on a hp server, with linux
> > 2,6,37 i changed kernel to a older release and the problem ended,
> > check with neil and others md guys what=B4s the real problem
> > maybe realtime module and others changes inside kernel are the
> > problem, maybe not...
> > just a quick solution idea: try a older kernel
> >
>=20
> Quick precis:
> - Started reshape 512k to 64k chunk size.
> - sdd got bad sector and was kicked.
> - Array froze all IO.

That .... shouldn't happen.  But I know why it did.

mdadm forks and runs in the back ground monitoring the reshape.
It suspends IO to a region of the array, backs up the data, then lets t=
he
reshape progress over that region, then invalidates the backup and allo=
ws IO
to resume, then moves on to the next region (it actually have two regio=
ns in
different states at the same time, but you get the idea).

If the device failed the reshape in the kernel aborted and then restart=
ed.
It is meant to do this - restore to a known state, then decide if there=
 is
anything useful to do.  It restarts exactly where it left off so all sh=
ould
be fine.

mdadm periodically checks the value in 'sync_completed' to see how far =
the
reshape has progressed to know if it can move on.
If it checks while the reshape is temporarily aborted it sees 'none', w=
hich
is not a number, so it aborts.  That should be fixed.
It aborts with IO to a region still suspended so it is very possible fo=
r IO
to freeze if anything is destined for that region.

> - Reboot required to get system back.
> - Restarted reshape with 9 drives.
> - sdl suffered IO error and was kicked

Very sad.

> - Array froze all IO.

Same thing...

> - Reboot required to get system back.
> - Array will no longer mount with 8/10 drives.
> - Mdadm 3.1.5 segfaults when trying to start reshape.

Don't know why it would have done that... I cannot reproduce it easily.


>    Naively tried to run it under gdb to get a backtrace but was unabl=
e=20
> to stop it forking

Yes, tricky .... an "strace -o /tmp/file -f mdadm ...." might have been
enough, but to late to worry about that now.

> - Got array started with mdadm 3.2.1
> - Attempted to re-add sdd/sdl (now marked as spares)

Hmm... it isn't meant to do that any more.  I thought I fixed it so tha=
t it
if a device looked like part of the array it wouldn't add it as a spare=
=2E..
Obviously that didn't work.  I'd better look in to it again.


> [  304.393245] mdadm[5940]: segfault at 7f2000 ip 00000000004480d2 sp=
=20
> 00007fffa04777b8 error 4 in mdadm[400000+64000]
>=20

If you have the exact mdadm binary that caused this segfault we should =
be
able to figure out what instruction was at 0004480d2.   If you don't fe=
el up
to it, could you please email me the file privately and I'll have a loo=
k.


> root@srv:~/mdadm-3.1.5# uname -a
> Linux srv 2.6.38 #19 SMP Wed Mar 23 09:57:05 WST 2011 x86_64 GNU/Linu=
x
>=20
> Now. The array restarted with mdadm 3.2.1, but of course its now=20
> reshaping 8 out of 10 disks, has no redundancy and is going at 600k/s=
=20
> which will take over 10 days. Is there anything I can do to give it s=
ome=20
> redundancy while it completes or am I better to copy the data off, bl=
ow=20
> it away and start again? All the important stuff is backed up anyway,=
 I=20
> just wanted to avoid restoring 8TB from backup if I could.

No, you cannot give it extra redundancy.
I would suggest:
  copy anything that you need off, just in case - if you can.

  Kill the mdadm that is running in the back ground.  This will mean th=
at
  if the machine crashes your array will be corrupted, but you are thin=
king
  of rebuilding it any, so that isn't the end of the world.
  In /sys/block/md0/md
     cat suspend_hi > suspend_lo
     cat component_size > sync_max

  That will allow the reshape to continue without any backup.  It will =
be
  much faster (but less safe, as I said).

  If the reshape completes without incident, it will start recovering t=
o the
  two 'spares' - and then you will have a happy array again.

  If something goes wrong, you will need to scrap the array, recreate i=
t, and
  copy data back from where-ever you copied it to (or backups).

If anything there doesn't make sense, or doesn't seem to work - please =
ask.

Thanks for the report.  I'll try to get those mdadm issues addressed -
particularly if you can get me the mdadm file which caused the segfault=
=2E

NeilBrown
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
