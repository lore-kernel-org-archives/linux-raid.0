From: wilsonjonathan <piercing_male@hotmail.com>
Subject: Re: 4 out of 16 drives show up as 'removed'
Date: Sat, 10 Dec 2011 17:28:26 +0000
Message-ID: <BLU0-SMTP333F9DA6F4F71CC9B70876A98BE0@phx.gbl>
References: <F0C8A2FE-8E5E-4683-BBF8-8E6B6A831635@ucsc.edu>
	 <4EE263A5.3010107@hardwarefreak.com>
	 <381720EC-8DCA-4862-9C62-22954CC7AA60@ucsc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <381720EC-8DCA-4862-9C62-22954CC7AA60@ucsc.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Eli Morris <ermorris@ucsc.edu>
Cc: stan@hardwarefreak.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 2011-12-09 at 14:07 -0800, Eli Morris wrote:

> My further understanding is that one can control the timeout in the O=
S of drives that are in an expansion bay, such as they are now configur=
ed in our system. But, look, I'll admit that that I'm no expert in this=
 issue and someone might have a better suggestion or will tell me why t=
hat is not the right idea / a bad idea, whatever. And if using these dr=
ives is just impossible (which very well might be - YES, I'm getting ve=
ry sick of trying to find a way to make these work), then so be it.=20
>=20

I'm setting up my first raid server for home use so power reduction whe=
n
not in use is important hence my drives and the hostlink power
management need to be able to go into low power mode and this is what I
have gleaned from the net!


=46irst issue the following (taken and edited from
http://www.excaliburtech.net/archives/83 )

(top one works in Red Hat 4):
for a in /sys/class/scsi_device/*/device/timeout; do echo -n =E2=80=9C$=
a =E2=80=9C; cat
=E2=80=9C$a=E2=80=9D ; done;
or
for a in /sys/class/scsi_generic/*/device/timeout; do echo -n =E2=80=9C=
$a =E2=80=9C; cat
=E2=80=9C$a=E2=80=9D ; done;

You should see results similar to:

/sys/class/scsi_device/0:0:0:0/device/timeout 30
/sys/class/scsi_device/2:0:0:0/device/timeout 30
/sys/class/scsi_device/4:0:0:0/device/timeout 30


If you (as root) for each entry above:

echo 120 > /sys/class/...   (use the full path names displayed from
previous here)

Then re-run the first command they should all now show 120. This is mor=
e
than enough to cope with disks winding up, doing some stuff, maybe a bi=
t
of alignment correction, and then replying to the md stack.

=46rom what I have read (although documentation on the net is rarely up=
 to
date) the md stack will wait forever on an action until either an error
is returned or the data is. There is no "time out" within the md stack
as there is with a hardware raid controller.

Mind you, I don't know anything about SAS cables or controllers so its
possible they may have hardware/software timeouts in their own right.

It might be worth investigating also (note this is for sata, so may not
be applicable):

for a in /sys/class/scsi_host/*/link_power_management_policy; do echo -=
n
"$a "; cat "$a"; done

which should show:

/sys/class/scsi_host/host0/link_power_management_policy max_performance
/sys/class/scsi_host/host1/link_power_management_policy max_performance


I guess another place to look is at the sdparm/hdparm data for the disk=
s
to see what options are set regarding winddown etc.



--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
