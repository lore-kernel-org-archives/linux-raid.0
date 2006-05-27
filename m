From: "Dirk Jagdmann" <jagdmann@gmail.com>
Subject: [patch] install a static build
Date: Sat, 27 May 2006 12:08:19 +0200
Message-ID: <5d0f60990605270308j71f3f2aem18219202d0fa957f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_29027_18625360.1148724499974"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

------=_Part_29027_18625360.1148724499974
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hello developers,

after building my static mdadm I wanted to install it via "make
install", but had to tweak the Makefile a little. However my approach
is not the best, since I had to remove the "rmconf" target for the
static build, issue a "cp" of the mdadm.static binary and my patch
might interfere with the "everything" target :-(

--=20
---> Dirk Jagdmann
----> http://cubic.org/~doj
-----> http://llg.cubic.org

------=_Part_29027_18625360.1148724499974
Content-Type: application/octet-stream; name="staticinstall.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="staticinstall.patch"
X-Attachment-Id: f_enpswui2

SW5kZXg6IG1kYWRtLTIuNS9NYWtlZmlsZQo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09Ci0tLSBtZGFkbS0yLjUub3JpZy9N
YWtlZmlsZQorKysgbWRhZG0tMi41L01ha2VmaWxlCkBAIC04NCwxMiArODQsMTQgQEAgYWxsIDog
bWRhZG0gbWRhZG0ubWFuIG1kLm1hbiBtZGFkbS5jb25mLgogZXZlcnl0aGluZzogYWxsIG1kYWRt
LnN0YXRpYyBtZGFkbS51Y2xpYmMgc3dhcF9zdXBlciB0ZXN0X3N0cmlwZSAgbWRhc3NlbWJsZSBt
ZGFzc2VtYmxlLnVjbGliYyBtZGFzc2VtYmxlLnN0YXRpYyBtZGFzc2VtYmxlLm1hbgogIyBtZGFk
bS50Y2MgZG9lc24ndCB3b3JrLi4KIAotbWRhZG0gOiBybWNvbmYgJChPQkpTKQorbWRhZG0gOiAk
KE9CSlMpCiAJJChDQykgJChMREZMQUdTKSAtbyBtZGFkbSAkKE9CSlMpICQoTERMSUJTKQogCiBt
ZGFkbS5zdGF0aWMgOiBTVEFUSUM9LURTVEFUSUMKIG1kYWRtLnN0YXRpYyA6IHJtY29uZiAkKE9C
SlMpIFNIQTEubyBzaGExLm8KIAkkKENDKSAkKExERkxBR1MpIC1EU1RBVElDIC1zdGF0aWMgLW8g
bWRhZG0uc3RhdGljICQoT0JKUykgU0hBMS5vIHNoYTEubworCWNwIC1mICRAIG1kYWRtCisKIHJt
Y29uZjoKIAlybSAtZiBjb25maWcubwogCg==
------=_Part_29027_18625360.1148724499974--
