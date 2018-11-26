From: Cesare Leonardi <celeonar@gmail.com>
Subject: Re: LVM RAID: task mdX_raid1:221 blocked for more than
	120 seconds
Date: Mon, 26 Nov 2018 12:31:41 +0100
Message-ID: <45bbdff9-b88c-4533-8aa5-9976564ed2bf@gmail.com>
References: <90473b46-274c-55af-3887-f058f2cf05dd@gmail.com>
	<6dc75647-bec9-564d-23fa-aeb626678cf6@redhat.com>
Reply-To: LVM general discussion and development <linux-lvm@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-lvm-bounces@redhat.com>
In-Reply-To: <6dc75647-bec9-564d-23fa-aeb626678cf6@redhat.com>
Content-Language: it-IT
List-Unsubscribe: <https://www.redhat.com/mailman/options/linux-lvm>,
	<mailto:linux-lvm-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/linux-lvm>
List-Post: <mailto:linux-lvm@redhat.com>
List-Help: <mailto:linux-lvm-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/linux-lvm>,
	<mailto:linux-lvm-request@redhat.com?subject=subscribe>
Sender: linux-lvm-bounces@redhat.com
Errors-To: linux-lvm-bounces@redhat.com
To: Zdenek Kabelac <zkabelac@redhat.com>, LVM general discussion and development <linux-lvm@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Resending, I erroneusly replied only to Zdenek, sorry.


On 26/11/18 09:49, Zdenek Kabelac wrote:
> It does look like 'freeze' happens during LV=A0 resize of device
> (just wild guess from bug=3D913138)
> =

> To track down the issue - there would need to be probably some =

> communication with bug reporters - they would need to expose what they =

> were doing plus state
> of dm tables and number of other things.

I can provide details about this, that was filed by me:
https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D913119

It's about a desktop PC, with two SSD (Samsung 850 EVO) on which i build =

RAID1 using LVM.
# pvs
   PV         VG  Fmt  Attr PSize    PFree
   /dev/sdb3  vg0 lvm2 a--  <250,00g 15,98g
   /dev/sdc3  vg0 lvm2 a--  <250,00g 15,98g

# lvs
   LV    VG  Attr       LSize   Pool Origin Data%  Meta%  Move Log =

Cpy%Sync Convert
   home  vg0 rwi-aor--- 200,00g 100,00
   root  vg0 rwi-aor---  30,00g 100,00
   swap0 vg0 rwi-aor---   4,00g 100,00

It's a desktop PC using Debian unstable, so it's rebooted quite often =

due to frequent updates.
The freezes happens during normal work, without any resizing or any =

maintenance on LVM going on. Most of the time I noted the freeze while I =

was using Thunderbird. But eventually they resolve by themself: I wait =

minutes and the system suddenly became responsive again. Sometimes I've =

noted freezes but without any notice in dmesg: maybe they resolved =

before some kernel threshold.
But most of the time another freeze will happen soon (it could be 1-2 =

hours but also minutes), so a reboot is really necessary.

I've not noticed any corruption due to these freeze but often they are =

very long and very impacting. The only reliable workaround found was to =

reboot with:
scsi_mod.use_blk_mq=3D0 dm_mod.use_blk_mq=3D0

Or to reboot with Debian kernel 4.16.16 (linux-image-4.16.0-2-amd) the =

last that work without problem but also the last before Debian =

maintaner's activated SCSI_MQ_DEFAULT and DM_MQ_DEFAULT.

To me the only evidence is that disabling blk-mq the problem doesn't =

happen and so it looks an interaction with blk-mq.
I've read in RHEL8 release notes that it will enable it by default, so I =

wonder if that happened to others. I have a fedora-server 29 VM, =

upgraded from 28, but there, if I recall correctly, SCSI_MQ_DEFAULT and =

DM_MQ_DEFAULT are not set.

> Anyway without way more info such bug report is meaningless.

Please ask, I'll do my best to provide any info you need.

Cesare.

_______________________________________________
linux-lvm mailing list
linux-lvm@redhat.com
https://www.redhat.com/mailman/listinfo/linux-lvm
read the LVM HOW-TO at http://tldp.org/HOWTO/LVM-HOWTO/
