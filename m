From: "Dirk Jagdmann" <jagdmann@gmail.com>
Subject: [patch] fix static build
Date: Sat, 27 May 2006 12:05:56 +0200
Message-ID: <5d0f60990605270305r8acc03fmb57cb739711456fe@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_29007_27346665.1148724356220"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

------=_Part_29007_27346665.1148724356220
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hello developers and patch reviewers,

I just tried to update my (old) mdadm to 2.5 and had to apply this
small patch to build a static linked mdadm.

--=20
---> Dirk Jagdmann
----> http://cubic.org/~doj
-----> http://llg.cubic.org

------=_Part_29007_27346665.1148724356220
Content-Type: application/octet-stream; name="staticbuild.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="staticbuild.patch"
X-Attachment-Id: f_enpst5k5

SW5kZXg6IG1kYWRtLTIuNS9NYWtlZmlsZQo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09Ci0tLSBtZGFkbS0yLjUub3JpZy9N
YWtlZmlsZQorKysgbWRhZG0tMi41L01ha2VmaWxlCkBAIC04OCw3ICs4OCw3IEBAIG1kYWRtIDog
cm1jb25mICQoT0JKUykKIAkkKENDKSAkKExERkxBR1MpIC1vIG1kYWRtICQoT0JKUykgJChMRExJ
QlMpCiAKIG1kYWRtLnN0YXRpYyA6IFNUQVRJQz0tRFNUQVRJQwotbWRhZG0uc3RhdGljIDogcm1j
b25mICQoT0JKUykKK21kYWRtLnN0YXRpYyA6IHJtY29uZiAkKE9CSlMpIFNIQTEubyBzaGExLm8K
IAkkKENDKSAkKExERkxBR1MpIC1EU1RBVElDIC1zdGF0aWMgLW8gbWRhZG0uc3RhdGljICQoT0JK
UykgU0hBMS5vIHNoYTEubwogcm1jb25mOgogCXJtIC1mIGNvbmZpZy5vCg==
------=_Part_29007_27346665.1148724356220--
