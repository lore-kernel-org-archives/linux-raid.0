From: Oliver Schinagl <oliver+list@schinagl.nl>
Subject: Re: Question about resync in RAID5
Date: Mon, 15 Apr 2013 22:27:20 +0200
Message-ID: <516C62A8.4050900@schinagl.nl>
References: <1366106362-12886-1-git-send-email-sanbai@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1366106362-12886-1-git-send-email-sanbai@taobao.com>
Sender: linux-raid-owner@vger.kernel.org
To: Robin Dong <sanbai@taobao.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 16-04-13 11:59, Robin Dong wrote:
> Dear Raid experts,
>
> I have a soft RAID5 volume and after one disk failed I replaced it wi=
th
> a new hard-disk. Then the raid5 volume begin to resync with WHOLE new
> disk.
> There is only 1G data in the RAID5 volume so I think resync whole dis=
k
> is not efficient.
The md driver however does not know this. It syncs everything.

Having said that, how do you know there's only 1 GB in use? Maybe there=
=20
is a hidden partition for the remainder of the disk? Or, maybe it house=
s=20
a encrypted container and in that container a nother encrpyted=20
countainer (check truecrypt on deniability).

=46act is, you do not know how much data is or is not used, well not fo=
r sure.
> Take ZFS for example, when replacing with a new disk, it only resync =
the
> data which are written after the creation of the volume.
but md is only the raid layer, zfs is the lower layer AND the=20
filesystem, you can't really fairly compare them. Btrfs may do this, bu=
t=20
I don't know and don't think it's ready as replacement yet anyway.
>
> Is there any method to just resync WRITTEN data to new-added-disk ? O=
r
> any developing plan to add this feature?
I highly doubt it, since, as said above, the md layer could not ever=20
possibly know what data is on the disk.
>
> ________________________________
>
> This email (including any attachments) is confidential and may be leg=
ally privileged. If you received this email in error, please delete it =
immediately and do not copy it or use it for any purpose or disclose it=
s contents to any other person. Thank you.
>
> =B1=BE=B5=E7=D3=CA(=B0=FC=C0=A8=C8=CE=BA=CE=B8=BD=BC=FE)=BF=C9=C4=DC=BA=
=AC=D3=D0=BB=FA=C3=DC=D7=CA=C1=CF=B2=A2=CA=DC=B7=A8=C2=C9=B1=A3=BB=A4=A1=
=A3=C8=E7=C4=FA=B2=BB=CA=C7=D5=FD=C8=B7=B5=C4=CA=D5=BC=FE=C8=CB=A3=AC=C7=
=EB=C4=FA=C1=A2=BC=B4=C9=BE=B3=FD=B1=BE=D3=CA=BC=FE=A1=A3=C7=EB=B2=BB=D2=
=AA=BD=AB=B1=BE=B5=E7=D3=CA=BD=F8=D0=D0=B8=B4=D6=C6=B2=A2=D3=C3=D7=F7=C8=
=CE=BA=CE=C6=E4=CB=FB=D3=C3=CD=BE=A1=A2=BB=F2=CD=B8=C2=B6=B1=BE=D3=CA=BC=
=FE=D6=AE=C4=DA=C8=DD=A1=A3=D0=BB=D0=BB=A1=A3
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
