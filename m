From: Phil Turmel <philip@turmel.org>
Subject: Re: Possible HDD error, how do I find which HDD it is?
Date: Sat, 19 Feb 2011 17:22:22 -0500
Message-ID: <4D60429E.1090501@turmel.org>
References: <AANLkTimV8-mciW_9z_=U_-uYLvKp7Rbh0V1N0mr7rh8v@mail.gmail.com>	<4D5FE3D6.8070006@anonymous.org.uk>	<4D5FF386.6070003@turmel.org> <AANLkTinw8hSks5kopU9ju1cNCQu11kUgPzRbC8L2h_ed@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030202080503000407010608"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTinw8hSks5kopU9ju1cNCQu11kUgPzRbC8L2h_ed@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?TWF0aGlhcyBCdXLDqW4=?= <mathias.buren@gmail.com>
Cc: John Robinson <john.robinson@anonymous.org.uk>, Linux-RAID <linux-raid@vger.kernel.org>, Simon Mcnair <simonmcnair@gmail.com>
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------030202080503000407010608
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 02/19/2011 03:09 PM, Mathias Burén wrote:
> The script works for me:
> 
>  $ sudo ./lsdrv.sh
> Password:
> Controller device @ pci0000:00/0000:00:0b.0 [ahci]
>   SATA controller: nVidia Corporation MCP79 AHCI Controller (rev b1)
>     host0: /dev/sda ATA Corsair CSSD-F60 {SN: 10326505580009990027}
>     host1: /dev/sdb ATA WDC WD20EARS-00M {SN: WD-WCAZA1022443}
>     host2: /dev/sdc ATA WDC WD20EARS-00M {SN: WD-WMAZ20152590}
>     host3: /dev/sdd ATA WDC WD20EARS-00M {SN: WD-WMAZ20188479}
>     host4: [Empty]
>     host5: [Empty]
> Controller device @ pci0000:00/0000:00:16.0/0000:05:00.0 [sata_mv]
>   SCSI storage controller: HighPoint Technologies, Inc. RocketRAID
> 230x 4 Port SATA-II Controller (rev 02)
>     host6: [Empty]
>     host7: /dev/sde ATA SAMSUNG HD204UI {SN: S2HGJ1RZ800964 }
>     host8: /dev/sdf ATA WDC WD20EARS-00M {SN: WD-WCAZA1000331}
>     host9: /dev/sdg ATA SAMSUNG HD204UI {SN: S2HGJ1RZ800850 }
> 
> So ata3 is the same as host3 then? How come no errors are logged on the drive:

No, generally not.  ATA numbering starts from #1.  Host numbering starts from #0, but includes non-ATA SCSI devices.

I've attached a version of the script that shows the LUN in addition to the host number, and includes John's adjustment.  It might be useful to people with port multipliers, and controllers that show all ports under a single host.

Simon, I'm very curious what this latest script shows for the Supermicro when one or more ports are empty, and whether those LUNs are consistently assigned to specific ports.

Phil

--------------030202080503000407010608
Content-Type: text/plain;
 name="lsdrv"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="lsdrv"

IyEgL2Jpbi9iYXNoCiMKIyBFeGFtaW5lIHNwZWNpZmljIHN5c3RlbSBob3N0IGRldmljZXMg
dG8gaWRlbnRpZnkgdGhlIGRyaXZlcyBhdHRhY2hlZAojCgpmdW5jdGlvbiBkZXNjcmliZV9j
b250cm9sbGVyICgpIHsKCWxvY2FsIGRldmljZSBkcml2ZXIgbW9kcHJlZml4IHNlcmlhbCBz
bG90bmFtZQoJZHJpdmVyPSJgcmVhZGxpbmsgLWYgXCIkMS9kcml2ZXJcImAiCglkcml2ZXI9
ImBiYXNlbmFtZSAkZHJpdmVyYCIKCW1vZHByZWZpeD0iYGN1dCAtZDogLWYxIDxcIiQxL21v
ZGFsaWFzXCJgIgoJZWNobyAiQ29udHJvbGxlciBkZXZpY2UgQCAkezEjIy9zeXMvZGV2aWNl
cy99IFskZHJpdmVyXSIKCWlmIFtbICIkbW9kcHJlZml4IiA9PSAicGNpIiBdXSA7IHRoZW4K
CQlzbG90bmFtZT0iYGJhc2VuYW1lIFwiJDFcImAiCgkJZWNobyAiICBgbHNwY2kgLXMgJHNs
b3RuYW1lIHxjdXQgLWRcICAtZjItYCIKCQlyZXR1cm4KCWZpCglpZiBbWyAiJG1vZHByZWZp
eCIgPT0gInVzYiIgXV0gOyB0aGVuCgkJaWYgW1sgLWYgIiQxL2J1c251bSIgXV0gOyB0aGVu
CgkJCWRldmljZT0iYGNhdCBcIiQxL2J1c251bVwiYDpgY2F0IFwiJDEvZGV2bnVtXCJgIgoJ
CQlzZXJpYWw9ImBjYXQgXCIkMS9zZXJpYWxcImAiCgkJZWxzZQoJCQlkZXZpY2U9ImBjYXQg
XCIkMS8uLi9idXNudW1cImA6YGNhdCBcIiQxLy4uL2Rldm51bVwiYCIKCQkJc2VyaWFsPSJg
Y2F0IFwiJDEvLi4vc2VyaWFsXCJgIgoJCWZpCgkJZWNobyAiICBgbHN1c2IgLXMgJGRldmlj
ZWAge1NOOiAkc2VyaWFsfSIKCQlyZXR1cm4KCWZpCgllY2hvIC1lICIgIGBjYXQgXCIkMS9t
b2RhbGlhc1wiYCIKfQoKZnVuY3Rpb24gZGVzY3JpYmVfZGV2aWNlICgpIHsKCWxvY2FsIGVt
cHR5PTEKCXdoaWxlIHJlYWQgZGV2aWNlIDsgZG8KCQllbXB0eT0wCgkJaWYgW1sgIiRkZXZp
Y2UiID1+IF4oLisvWzAtOV0rOikoWzAtOV0rOlswLTldKzpbMC05XSspL2Jsb2NrWy86XSgu
KykkIF1dIDsgdGhlbgoJCQliYXNlPSIke0JBU0hfUkVNQVRDSFsxXX0iCgkJCWx1bj0iJHtC
QVNIX1JFTUFUQ0hbMl19IgoJCQliZGV2PSIke0JBU0hfUkVNQVRDSFszXX0iCgkJCXZuZD0i
JCg8ICR7YmFzZX0ke2x1bn0vdmVuZG9yKSIKCQkJbWRsPSIkKDwgJHtiYXNlfSR7bHVufS9t
b2RlbCkiCgkJCXNuPSJgc2dpbmZvIC1zIC9kZXYvJGJkZXYgfCBcCgkJCQlzZWQgLXJuIC1l
IFwiL1NlcmlhbCBOdW1iZXIve3MlXi4rJyAqKC4rKSAqJy4qXFxcJCVcXFxcMSU7cDtxfVwi
YCIgJj4vZGV2L251bGwKCQkJaWYgW1sgLW4gIiRzbiIgXV0gOyB0aGVuCgkJCQllY2hvIC1l
ICIgICAgJDEgYGVjaG8gJGx1biAkYmRldiAkdm5kICRtZGwge1NOOiAkc259YCIKCQkJZWxz
ZQoJCQkJZWNobyAtZSAiICAgICQxIGBlY2hvICRsdW4gJGJkZXYgJHZuZCAkbWRsYCIKCQkJ
ZmkKCQllbHNlCgkJCWVjaG8gLWUgIiAgICAkMSBVbmtub3duICRkZXZpY2UiCgkJZmkKCWRv
bmUKCVtbICRlbXB0eSAtZXEgMSBdXSAmJiBlY2hvIC1lICIgICAgJDEgW0VtcHR5XSIKfQoK
ZnVuY3Rpb24gY2hlY2tfaG9zdCAoKSB7Cglsb2NhbCBmb3VuZD0wCglsb2NhbCBwQ29udHJv
bGxlcj0KCXdoaWxlIHJlYWQgc2hvc3QgOyBkbwoJCWhvc3Q9YGRpcm5hbWUgIiRzaG9zdCJg
CgkJY29udHJvbGxlcj1gZGlybmFtZSAiJGhvc3QiYAoJCWJob3N0PWBiYXNlbmFtZSAiJGhv
c3QiYAoJCWlmIFtbICIkY29udHJvbGxlciIgIT0gIiRwQ29udHJvbGxlciIgXV0gOyB0aGVu
CgkJCXBDb250cm9sbGVyPSIkY29udHJvbGxlciIKCQkJZGVzY3JpYmVfY29udHJvbGxlciAi
JGNvbnRyb2xsZXIiCgkJZmkKCQlmaW5kICRob3N0IC1yZWdleCAnLisvdGFyZ2V0WzAtOTpd
Ky9bMC05Ol0rL2Jsb2NrWzovXVteL10rJyB8ZGVzY3JpYmVfZGV2aWNlICIkYmhvc3QiCglk
b25lCn0KCmZpbmQgL3N5cy9kZXZpY2VzLyAtbmFtZSAnc2NzaV9ob3N0KicgfGNoZWNrX2hv
c3QK
--------------030202080503000407010608--
