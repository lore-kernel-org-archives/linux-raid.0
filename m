From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Raid5 over sbp2 : sbp2 command abort
Date: Mon, 30 Jan 2006 21:00:19 +0100
Message-ID: <43DE7053.1030706@s5r6.in-berlin.de>
References: <fd8d0180601300550k7316bb14t@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <linux1394-devel-admin@lists.sourceforge.net>
In-Reply-To: <fd8d0180601300550k7316bb14t@mail.gmail.com>
Sender: linux1394-devel-admin@lists.sourceforge.net
Errors-To: linux1394-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux1394-devel>
To: Francois Barre <francois.barre@gmail.com>
Cc: linux1394-devel@lists.sourceforge.net, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Francois Barre wrote:
> This is a cross-post (sorry for that), but I don't know where it comes =
from yet.

Alas we get similar reports about software RAID over SBP-2 now and then=20
on linux1394-devel or -user. I very much suspect sbp2 to be the culprit.

One person reported different results with different software RAID=20
levels but I am too lazy right now to dig for the post in the list archiv=
e.

Question to the linux-raid folks: Does md support disks on different=20
SCSI host adapters to be in the same RAID set?

> A. The setup
> VIA EPIA 10k Nehemiah, OHCI with VIA
> 4 sbp2 250Go IDE drives

Are these drives' bridges based on a Proflific chip? If yes, check if=20
you could get a firmware update.

> Vanilla 2.6.15.1 kernel, mdadm 2.2, superblock 0.90
> ohci1394+sbp2 in kernel (default params : serialize_io=3D1, ...), raid5
> as a module.

I recommend to build the FireWire drivers as modules. This enables you=20
to unload and reload them e.g. to recover from some failures or to try=20
different parameters. However, static linking or building them as=20
modules does not have an effect on reliability during data transfers.

> B. The tests
> Test0 : Creating a 4-drive raid5 with 1 drive missing, copying the 4th
> drive content to the raid5, works great.
> Stress-testing multiple drive copy seems to be ok (Test0 + various
> tests), very responsive, absolutely no error, but Test1 has a lot of
> 'command abort' errors, which blocks io for seconds, then starts
> again.
>=20
> Test1 : Building from scratch the raid5 with 4 drives (i.e. none
> missing), causes 'sbp2 : command abort' messages.

Are there any other suspicious messages from sbp2, ieee1394, or ohci1394?

> At the end of Test1, raid5 is not created : one drive is set faulty.
>=20
> C. The questions :
> How could I run a parano=EFd/degraded bandwidth mode ? I tried playing
> with /proc/sys/dev/raid/speed_limit_max, reducing to far away from
> highest bandwidth, but it did not have the expected behaviour : io
> runs to highest bw for seconds, then stops, then runs again at highest
> rate, ...

What about sbp2's max_speed parameter?

> Is there a way to avoid write back at sbp2 level ? I could not find
> any way to do so...

What do you mean by that?

> What kernel version should I rather use ? Seems like scsi on 2.6.15.x
> is not really trustworthy, should I run 2.6.14.x ?

"aborting sbp2 command" issues have been reported for quite a long time=20
now. Especially for Linux 2.6, although 2.4's sbp2 isn't fundamentally=20
different. I don't think 2.6.14.x would make a difference to 2.6.15.x=20
with this particular problem.

BTW, I'm hoping to get some spare time in February in order to work on=20
this particular problem. I never used software RAID over sbp2 myself and=20
don't intend to do so any time soon, but I get what I suspect to be the=20
same type of failures with a 1394a disk and with a 1394b JBOD device (or=20
hardware "R"AID-0) myself.

In case of my 1394a disk, the failures vanish either with serialize_io=3D=
1=20
(this was not required with an older kernel; I don't remember which one)=20
or --- curiously enough --- with "gap count optimization". As I wrote an=20
hour ago on linux1394-user, gap count optimization is a performance=20
tuning of the FireWire bus and is not yet implemented in the kernel. You=20
can get gap count optimization manually with "echo p 0x00450000 |=20
1394commander" for a single external device or "echo p 0x004a0000 |=20
1394commander" if 4 external devices are daisy-chained. Run the command=20
after all disks were connected and switched on, otherwise the command=20
may inhibit access to newly added devices. www.linux1394.org has a link=20
to 1394commander.
--=20
Stefan Richter
-=3D=3D=3D=3D=3D-=3D-=3D=3D- ---=3D =3D=3D=3D=3D-
http://arcgraph.de/sr/


-------------------------------------------------------
This SF.net email is sponsored by: Splunk Inc. Do you grep through log files
for problems?  Stop!  Download the new AJAX search engine that makes
searching your log files as easy as surfing the  web.  DOWNLOAD SPLUNK!
http://sel.as-us.falkag.net/sel?cmd=lnk&kid=103432&bid=230486&dat=121642
