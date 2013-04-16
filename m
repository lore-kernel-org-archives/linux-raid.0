From: Robin Dong <sanbai@taobao.com>
Subject: Question about resync in RAID5
Date: Tue, 16 Apr 2013 17:59:22 +0800
Message-ID: <1366106362-12886-1-git-send-email-sanbai@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Robin Dong <sanbai@taobao.com>
List-Id: linux-raid.ids

Dear Raid experts,

I have a soft RAID5 volume and after one disk failed I replaced it with
a new hard-disk. Then the raid5 volume begin to resync with WHOLE new
disk.
There is only 1G data in the RAID5 volume so I think resync whole disk
is not efficient.
Take ZFS for example, when replacing with a new disk, it only resync th=
e
data which are written after the creation of the volume.

Is there any method to just resync WRITTEN data to new-added-disk ? Or
any developing plan to add this feature?

________________________________

This email (including any attachments) is confidential and may be legal=
ly privileged. If you received this email in error, please delete it im=
mediately and do not copy it or use it for any purpose or disclose its =
contents to any other person. Thank you.

=B1=BE=B5=E7=D3=CA(=B0=FC=C0=A8=C8=CE=BA=CE=B8=BD=BC=FE)=BF=C9=C4=DC=BA=
=AC=D3=D0=BB=FA=C3=DC=D7=CA=C1=CF=B2=A2=CA=DC=B7=A8=C2=C9=B1=A3=BB=A4=A1=
=A3=C8=E7=C4=FA=B2=BB=CA=C7=D5=FD=C8=B7=B5=C4=CA=D5=BC=FE=C8=CB=A3=AC=C7=
=EB=C4=FA=C1=A2=BC=B4=C9=BE=B3=FD=B1=BE=D3=CA=BC=FE=A1=A3=C7=EB=B2=BB=D2=
=AA=BD=AB=B1=BE=B5=E7=D3=CA=BD=F8=D0=D0=B8=B4=D6=C6=B2=A2=D3=C3=D7=F7=C8=
=CE=BA=CE=C6=E4=CB=FB=D3=C3=CD=BE=A1=A2=BB=F2=CD=B8=C2=B6=B1=BE=D3=CA=BC=
=FE=D6=AE=C4=DA=C8=DD=A1=A3=D0=BB=D0=BB=A1=A3
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
