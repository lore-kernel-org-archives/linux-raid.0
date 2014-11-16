From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Raid 6 Fail Event
Date: Sun, 16 Nov 2014 12:52:02 -0700
Message-ID: <3B23D2F1-09A3-4C1F-AB38-2AB0DDC2D5A7@colorremedies.com>
References: <em16d8035c-84ce-4b71-bcbb-b5c965e35b04@littlez>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <em16d8035c-84ce-4b71-bcbb-b5c965e35b04@littlez>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Stephenson <justin@evensteveninc.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Nov 16, 2014, at 8:39 AM, Justin Stephenson <justin@evensteveninc.co=
m> wrote:

> Hello,
>=20
> I am new to MDADM and have just experienced my first device fail on m=
y raid 6.
>=20
> I am wondering if someone might be able to help by outlining a proper=
 protocol for troubleshooting and rebuilding this array (proc/mdstat be=
low).
>=20
> Here is how I might approach it:
>=20
> - remove the device
> - test the device
> - if the device tests OK then re add the device
> - if the device fails, then replace the device
> - resync
>=20
> Thank-you for your consideration.
>=20
> Best,
>=20
> - Justin
>=20
> Here is the mdstat email
>=20
> -----------------
>=20
> This is an automatically generated mail message from mdadm
> running on BigBlue
>=20
> A Fail event had been detected on md device /dev/md0.
>=20
> It could be related to component device /dev/sdh1.

=46irst step is getting the backup current.=20

Second you can do this without removing the device:

# smartctl -x /dev/sdh

And then look in dmesg for errors related to its ata designation. You s=
hould be able to get a serial number from the smartctl output and can s=
earch that with dmesg | grep <serial#> to find out what it=92s ata desi=
gnation (port and device number) is, then you can dmesg | grep ataX.YY =
to get any read/write error events that explain what=92s going on.=20

While you=92re at it the following would be helpful as well:

# smartctl -l scterc /dev/sdh
# cat /sys/block/sdh/device/state
# cat /sys/block/sdh/device/timeout

These are read-only commands to determine states, they don=92t change s=
tates so it=92s safe.

Chris Murphy--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
