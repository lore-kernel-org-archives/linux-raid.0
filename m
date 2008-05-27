From: Dexter Filmore <Dexter.Filmore@gmx.de>
Subject: Re: How to force stopping an array`
Date: Tue, 27 May 2008 12:49:35 +0200
Message-ID: <200805271249.35965.Dexter.Filmore@gmx.de>
References: <200805262343.20626.Dexter.Filmore@gmx.de> <200805270102.15029.Dexter.Filmore@gmx.de> <40275.192.168.1.70.1211846736.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <40275.192.168.1.70.1211846736.squirrel@neil.brown.name>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Am Dienstag, 27. Mai 2008 02:05:36 schrieb NeilBrown:
> On Tue, May 27, 2008 9:02 am, Dexter Filmore wrote:
> > Am Dienstag, 27. Mai 2008 00:30:26 schrieb Justin Piszcz:
> >> On Tue, 27 May 2008, Dexter Filmore wrote:
> >> > Am Dienstag, 27. Mai 2008 00:06:57 schrieb Justin Piszcz:
> >> >> On Mon, 26 May 2008, Dexter Filmore wrote:
> >> >>> So I have a filesystem on an array I cannot unmount, hence I cannot
> >> >>> stop the array.
> >> >>> Any way to force it?
> >> >>>
> >> >>> Dex
> >> >>
> >> >> What is using it?
> >> >>
> >> >> lsof | grep /mount_point
> >> >> lsof | grep /dev/mdX
> >> >
> >> > A defunct java process that died from a mem heap error. I can't kill
> >>
> >> the
> >>
> >> > process, not even -9, leaves a <defunct>.
> >>
> >> Other than rebooting I am not sure..  You could try making / re-mounting
> >> it as read-only but if the java process is still reading from the FS it
> >> probably will not be of any help.
> >>
> >> Justin.
> >
> > Exactly. reboot pretty much deosn't do any good, afterwars the raid
> > resyncs,
> > which takes full 7h here.
>
> There shouldn't be a resync.  Presumably nothing is writing to the
> array, and moments after the last write, the array will have been
> flagged as 'clean' and will not require a resync after a reboot.

Well, that's what I thought. Actually the "shutdown" didn't work at all, it 
got stuck and wouldn't finish so I had to resort to Alt-SysRq-S/U/B to 
reboot.
S/U should have ensured the file systems are in sync, but I don't know how the 
array takes to such measures. After the reboot the mdstat looks...
>
> > What happens there anyway? it resyncs, but mdstats say [UUUUU], all fine.
>
> I don't understand this question.
>

...like this:

# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active raid5 sde1[0] sdb1[4] sdd1[3] sda1[2] sdc1[1]
      1953503488 blocks level 5, 64k chunk, algorithm 2 [5/5] [UUUUU]
      [>....................]  resync =  2.9% (14600832/488375872) 
finish=360.6min speed=21896K/sec

unused devices: <none>



-- 
-----BEGIN GEEK CODE BLOCK-----
Version: 3.12
GCS d--(+)@ s-:+ a- C++++ UL++ P+>++ L+++>++++ E-- W++ N o? K-
w--(---) !O M+ V- PS+ PE Y++ PGP t++(---)@ 5 X+(++) R+(++) tv--(+)@ 
b++(+++) DI+++ D- G++ e* h>++ r* y?
------END GEEK CODE BLOCK------

http://www.vorratsdatenspeicherung.de
