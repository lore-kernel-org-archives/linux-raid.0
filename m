From: KELEMEN Peter <Peter.Kelemen@cern.ch>
Subject: Re: Spares and partitioning huge disks
Date: Tue, 11 Jan 2005 11:09:01 +0100
Message-ID: <20050111100901.GE32199@chihiro.cern.ch>
References: <crmt7e$8d6$1@sea.gmane.org> <200501081749.32816.maarten@ultratux.net> <200501082001.09317.maarten@ultratux.net> <200501101734.24851.maarten@ultratux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200501101734.24851.maarten@ultratux.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

* Maarten (maarten@ultratux.net) [20050110 17:34]:

> P.S.:  I get this filling up my logs. Should I be worried about that =
?
> Jan 10 11:30:32 dozer kernel: raid5: switching cache buffer size, 512=
 --> 4096
> Jan 10 11:30:33 dozer kernel: raid5: switching cache buffer size, 409=
6 --> 512
> Jan 10 11:30:33 dozer kernel: raid5: switching cache buffer size, 512=
 --> 4096
> Jan 10 11:30:36 dozer kernel: raid5: switching cache buffer size, 409=
6 --> 512

You have an internal XFS log on the RAID device and it is
accessed in sector units by default, md is reporting the changes
(harmless).  Best workaround is to instruct your filesystem to use
4K sectors: mkfs.xfs -s size=3D4k

HTH,
Peter

--=20
    .+'''+.         .+'''+.         .+'''+.         .+'''+.         .+'=
'
 Kelemen P=C3=A9ter     /       \       /       \     Peter.Kelemen@cer=
n.ch
=2E+'         `+...+'         `+...+'         `+...+'         `+...+'
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
