From: Roger Heflin <rogerheflin@gmail.com>
Subject: Bug#700975: RAID barely usable on my home machine
Date: Thu, 4 Apr 2013 19:08:13 -0500
Message-ID: <CAAMCDefBsfwNPwKJWFVDViBXh3ZgBwb0Uu1RZCst=aV78hM4pg@mail.gmail.com>
References: <CAO=zWDLfnBJBFgm4H67XEqsKPP=+Ayk3Jd4OUdEfmLXsvNGdog@mail.gmail.com>
Reply-To: Roger Heflin <rogerheflin@gmail.com>, 700975@bugs.debian.org
Mime-Version: 1.0
Content-Type: multipart/alternative; boundary=001a11c1b64850e9b204d991e39a
Return-path: <bounce-debian-bugs-dist=glddb-debian-bugs-dist=m.gmane.org@lists.debian.org>
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.700975.B700975.136512052217807@bugs.debian.org>
In-Reply-To: <CAO=zWDLfnBJBFgm4H67XEqsKPP=+Ayk3Jd4OUdEfmLXsvNGdog@mail.gmail.com>
List-URL: <http://lists.debian.org/debian-bugs-dist/>
List-Post: <mailto:debian-bugs-dist@lists.debian.org>
List-Help: <mailto:debian-bugs-dist-request@lists.debian.org?subject=help>
List-Subscribe: <mailto:debian-bugs-dist-request@lists.debian.org?subject=subscribe>
List-Unsubscribe: <mailto:debian-bugs-dist-request@lists.debian.org?subject=unsubscribe>
To: Maik Zumstrull <maik@zumstrull.net>
Cc: Linux RAID <linux-raid@vger.kernel.org>, linux-ide@vger.kernel.org, 700975@bugs.debian.org
List-Id: linux-raid.ids

--001a11c1b64850e9b204d991e39a
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

lspci look like this for the controller:
SATA controller: Marvell Technology Group Ltd. Device 9230 (rev 10)

4pt sata3.0 6gbit or is yours a different one?

I have the issue also, I have eliminated all smart hits against the disks
and no incidents since then.

It does appear to be load related, if the controller is being hit hard and
the smart command comes along sometimes the controller loses its mind and
all of the disks stop responding.

I have seagate 1.5tb drives on mine that had had the issues.

I am using 3.7.10...it also has the issue.

and reboot is the only thing that clears it, and I have got pretty good at
forcing the raid back online when this happens.




On Thu, Apr 4, 2013 at 3:13 PM, Maik Zumstrull <maik@zumstrull.net> wrote:

> Hello Linux RAID and ATA people,
>
> I've managed to find a configuration on my home desktop where a
> particular RAID array is barely usable.
>
> You can find my initial report at:
> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D700975
>
> In summary:
>
> - I create an array across four disks on a Marvell AHCI controller,
> which automatically goes into rebuild mode.
> - Somebody (e.g. smartd or udisks2 or me, testing) sends a SMART
> command to one of the disks.
> - The SMART command fails.
> - The ATA subsystems freaks out all over the place, until eventually
> none of the disks on that controller are responsive.
> - The array is dead until reboot. (Curiously, without data loss so
> far. Kudos on the RAID code, I guess.)
>
> I've found the issue to be highly reproducible so far. Things mostly
> work if the array is not under heavy load (not rebuilding, no big file
> copies going on) or I make completely sure nothing sends SMART
> commands. I currently do keep real files on that array, but backed-up
> ones, so I could wipe it for more tests if really necessary.
>
> I've tried various kernels from Debian (3.2, 3.7, and 3.8 series) and
> found them all affected.
>
> Here are some edited excerpts from the kernel log messages as found in
> the Debian bug, see unedited transcript there.
>
> Getting our RAID on:
>
> [  122.707833] md127: detected capacity change from 0 to 9001374842880
> [  122.707860] RAID conf printout:
> [  122.707865]  --- level:5 rd:4 wd:3
> [  122.707868]  disk 0, o:1, dev:sde
> [  122.707870]  disk 1, o:1, dev:sdf
> [  122.707872]  disk 2, o:1, dev:sdg
> [  122.707873]  disk 3, o:1, dev:sdh
> [  122.707965] md: recovery of RAID array md127
> [  122.707968] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
> [  122.707970] md: using maximum available idle IO bandwidth (but not
> more than 200000 KB/sec) for recovery.
> [  122.707973] md: using 128k window, over a total of 2930135040k.
>
> We see a SMART we don't like:
>
> [  180.531641] ata9.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
> frozen
> [  180.531648] ata9.00: failed command: SMART
> [  180.531655] ata9.00: cmd b0/d1:01:01:4f:c2/00:00:00:00:00/00 tag 0 pio
> 512 in
> [  180.531655]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
> 0x4 (timeout)
> [  180.531658] ata9.00: status: { DRDY }
>
> Woops, a non-critical command failed? Best shoot the controller in the
> face until it stops twitching:
>
> [  180.531666] ata9: hard resetting link
> [  185.887433] ata9: link is slow to respond, please be patient (ready=3D=
0)
> [  190.524871] ata9: COMRESET failed (errno=3D-16)
> [  190.524877] ata9: hard resetting link
> [  195.872694] ata9: link is slow to respond, please be patient (ready=3D=
0)
> [  200.510134] ata9: COMRESET failed (errno=3D-16)
> [  200.510141] ata9: hard resetting link
> [  205.857925] ata9: link is slow to respond, please be patient (ready=3D=
0)
> [  235.470518] ata9: COMRESET failed (errno=3D-16)
> [  235.470526] ata9: limiting SATA link speed to 3.0 Gbps
> [  235.470529] ata9: hard resetting link
> [  240.483102] ata9: COMRESET failed (errno=3D-16)
> [  240.483110] ata9: reset failed, giving up
> [  240.483112] ata9.00: disabled
> [  240.483134] ata9: EH complete
>
> So now other stuff goes wrong:
>
> [  301.216814] ata7.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
> frozen
> [  301.216818] ata7.00: failed command: FLUSH CACHE EXT
> [  301.216821] ata7.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
> [  301.216821]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
> 0x4 (timeout)
> [  301.216822] ata7.00: status: { DRDY }
> [  301.216827] ata7: hard resetting link
> [  301.216842] ata10.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
> frozen
> [  301.216845] ata10.00: failed command: FLUSH CACHE EXT
> [  301.216849] ata10.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
> [  301.216849]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
> 0x4 (timeout)
> [  301.216851] ata10.00: status: { DRDY }
> [  301.216855] ata10: hard resetting link
> [  301.216861] ata8.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
> frozen
> [  301.216864] ata8.00: failed command: FLUSH CACHE EXT
> [  301.216868] ata8.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
> [  301.216868]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
> 0x4 (timeout)
> [  301.216870] ata8.00: status: { DRDY }
>
> Until eventually, the patient's dead=E2=80=A6so let's report success:
>
> [  351.917459] md/raid:md127: Disk failure on sde, disabling device.
> [  351.917459] md/raid:md127: Operation continuing on 0 devices.
> [  351.921299] md: md127: recovery done.
>
> This is on a cheapo PCIe extension board with four internal SATA3
> ports. Chip is a "Marvell Technology Group Ltd. 88SE9230 PCIe SATA
> 6Gb/s Controller [1b4b:9230]" using the ahci driver.
>
> It would be really good to see this fixed. I see two issues:
> - That SMART command probably shouldn't fail. Weird drive firmware?
> Timeout too tight?
> - A failing SMART command should probably not trigger a breakdown of
> the whole controller. At least, not such a messy one.
>
> I'll make myself available, as time allows, to provide requested
> additional information.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

--001a11c1b64850e9b204d991e39a
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div><div><div>lspci look like this for the controlle=
r:<br>SATA controller: Marvell Technology Group Ltd. Device 9230 (rev 10)<b=
r><br></div>4pt sata3.0 6gbit or is yours a different one?<br><br></div>I h=
ave the issue also, I have eliminated all smart hits against the disks and =
no incidents since then.<br>

<br>It does appear to be load related, if the controller is being hit hard =
and the smart command comes along sometimes the controller loses its mind a=
nd all of the disks stop responding.<br><br></div><div>I have seagate 1.5tb=
 drives on mine that had had the issues.<br>

</div><div><br></div>I am using 3.7.10...it also has the issue.<br><br></di=
v>and reboot is the only thing that clears it, and I have got pretty good a=
t forcing the raid back online when this happens.<br><div><div><br><br>

</div></div></div><div class=3D"gmail_extra"><br><br><div class=3D"gmail_qu=
ote">On Thu, Apr 4, 2013 at 3:13 PM, Maik Zumstrull <span dir=3D"ltr">&lt;<=
a href=3D"mailto:maik@zumstrull.net" target=3D"_blank">maik@zumstrull.net</=
a>&gt;</span> wrote:<br>

<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">Hello Linux RAID and ATA people,<br>
<br>
I&#39;ve managed to find a configuration on my home desktop where a<br>
particular RAID array is barely usable.<br>
<br>
You can find my initial report at:<br>
<a href=3D"http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D700975" targe=
t=3D"_blank">http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D700975</a><=
br>
<br>
In summary:<br>
<br>
- I create an array across four disks on a Marvell AHCI controller,<br>
which automatically goes into rebuild mode.<br>
- Somebody (e.g. smartd or udisks2 or me, testing) sends a SMART<br>
command to one of the disks.<br>
- The SMART command fails.<br>
- The ATA subsystems freaks out all over the place, until eventually<br>
none of the disks on that controller are responsive.<br>
- The array is dead until reboot. (Curiously, without data loss so<br>
far. Kudos on the RAID code, I guess.)<br>
<br>
I&#39;ve found the issue to be highly reproducible so far. Things mostly<br=
>
work if the array is not under heavy load (not rebuilding, no big file<br>
copies going on) or I make completely sure nothing sends SMART<br>
commands. I currently do keep real files on that array, but backed-up<br>
ones, so I could wipe it for more tests if really necessary.<br>
<br>
I&#39;ve tried various kernels from Debian (3.2, 3.7, and 3.8 series) and<b=
r>
found them all affected.<br>
<br>
Here are some edited excerpts from the kernel log messages as found in<br>
the Debian bug, see unedited transcript there.<br>
<br>
Getting our RAID on:<br>
<br>
[ =C2=A0122.707833] md127: detected capacity change from 0 to 9001374842880=
<br>
[ =C2=A0122.707860] RAID conf printout:<br>
[ =C2=A0122.707865] =C2=A0--- level:5 rd:4 wd:3<br>
[ =C2=A0122.707868] =C2=A0disk 0, o:1, dev:sde<br>
[ =C2=A0122.707870] =C2=A0disk 1, o:1, dev:sdf<br>
[ =C2=A0122.707872] =C2=A0disk 2, o:1, dev:sdg<br>
[ =C2=A0122.707873] =C2=A0disk 3, o:1, dev:sdh<br>
[ =C2=A0122.707965] md: recovery of RAID array md127<br>
[ =C2=A0122.707968] md: minimum _guaranteed_ =C2=A0speed: 1000 KB/sec/disk.=
<br>
[ =C2=A0122.707970] md: using maximum available idle IO bandwidth (but not<=
br>
more than 200000 KB/sec) for recovery.<br>
[ =C2=A0122.707973] md: using 128k window, over a total of 2930135040k.<br>
<br>
We see a SMART we don&#39;t like:<br>
<br>
[ =C2=A0180.531641] ata9.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0=
x6 frozen<br>
[ =C2=A0180.531648] ata9.00: failed command: SMART<br>
[ =C2=A0180.531655] ata9.00: cmd b0/d1:01:01:4f:c2/00:00:00:00:00/00 tag 0 =
pio 512 in<br>
[ =C2=A0180.531655] =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0res 40/00:00:00:00:00=
/00:00:00:00:00/00 Emask<br>
0x4 (timeout)<br>
[ =C2=A0180.531658] ata9.00: status: { DRDY }<br>
<br>
Woops, a non-critical command failed? Best shoot the controller in the<br>
face until it stops twitching:<br>
<br>
[ =C2=A0180.531666] ata9: hard resetting link<br>
[ =C2=A0185.887433] ata9: link is slow to respond, please be patient (ready=
=3D0)<br>
[ =C2=A0190.524871] ata9: COMRESET failed (errno=3D-16)<br>
[ =C2=A0190.524877] ata9: hard resetting link<br>
[ =C2=A0195.872694] ata9: link is slow to respond, please be patient (ready=
=3D0)<br>
[ =C2=A0200.510134] ata9: COMRESET failed (errno=3D-16)<br>
[ =C2=A0200.510141] ata9: hard resetting link<br>
[ =C2=A0205.857925] ata9: link is slow to respond, please be patient (ready=
=3D0)<br>
[ =C2=A0235.470518] ata9: COMRESET failed (errno=3D-16)<br>
[ =C2=A0235.470526] ata9: limiting SATA link speed to 3.0 Gbps<br>
[ =C2=A0235.470529] ata9: hard resetting link<br>
[ =C2=A0240.483102] ata9: COMRESET failed (errno=3D-16)<br>
[ =C2=A0240.483110] ata9: reset failed, giving up<br>
[ =C2=A0240.483112] ata9.00: disabled<br>
[ =C2=A0240.483134] ata9: EH complete<br>
<br>
So now other stuff goes wrong:<br>
<br>
[ =C2=A0301.216814] ata7.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0=
x6 frozen<br>
[ =C2=A0301.216818] ata7.00: failed command: FLUSH CACHE EXT<br>
[ =C2=A0301.216821] ata7.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0<=
br>
[ =C2=A0301.216821] =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0res 40/00:00:00:00:00=
/00:00:00:00:00/00 Emask<br>
0x4 (timeout)<br>
[ =C2=A0301.216822] ata7.00: status: { DRDY }<br>
[ =C2=A0301.216827] ata7: hard resetting link<br>
[ =C2=A0301.216842] ata10.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action =
0x6 frozen<br>
[ =C2=A0301.216845] ata10.00: failed command: FLUSH CACHE EXT<br>
[ =C2=A0301.216849] ata10.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0=
<br>
[ =C2=A0301.216849] =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0res 40/00:00:00:00:00=
/00:00:00:00:00/00 Emask<br>
0x4 (timeout)<br>
[ =C2=A0301.216851] ata10.00: status: { DRDY }<br>
[ =C2=A0301.216855] ata10: hard resetting link<br>
[ =C2=A0301.216861] ata8.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0=
x6 frozen<br>
[ =C2=A0301.216864] ata8.00: failed command: FLUSH CACHE EXT<br>
[ =C2=A0301.216868] ata8.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0<=
br>
[ =C2=A0301.216868] =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0res 40/00:00:00:00:00=
/00:00:00:00:00/00 Emask<br>
0x4 (timeout)<br>
[ =C2=A0301.216870] ata8.00: status: { DRDY }<br>
<br>
Until eventually, the patient&#39;s dead=E2=80=A6so let&#39;s report succes=
s:<br>
<br>
[ =C2=A0351.917459] md/raid:md127: Disk failure on sde, disabling device.<b=
r>
[ =C2=A0351.917459] md/raid:md127: Operation continuing on 0 devices.<br>
[ =C2=A0351.921299] md: md127: recovery done.<br>
<br>
This is on a cheapo PCIe extension board with four internal SATA3<br>
ports. Chip is a &quot;Marvell Technology Group Ltd. 88SE9230 PCIe SATA<br>
6Gb/s Controller [1b4b:9230]&quot; using the ahci driver.<br>
<br>
It would be really good to see this fixed. I see two issues:<br>
- That SMART command probably shouldn&#39;t fail. Weird drive firmware?<br>
Timeout too tight?<br>
- A failing SMART command should probably not trigger a breakdown of<br>
the whole controller. At least, not such a messy one.<br>
<br>
I&#39;ll make myself available, as time allows, to provide requested<br>
additional information.<br>
--<br>
To unsubscribe from this list: send the line &quot;unsubscribe linux-raid&q=
uot; in<br>
the body of a message to <a href=3D"mailto:majordomo@vger.kernel.org">major=
domo@vger.kernel.org</a><br>
More majordomo info at =C2=A0<a href=3D"http://vger.kernel.org/majordomo-in=
fo.html" target=3D"_blank">http://vger.kernel.org/majordomo-info.html</a><b=
r>
</blockquote></div><br></div>

--001a11c1b64850e9b204d991e39a--
