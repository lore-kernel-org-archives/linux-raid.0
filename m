From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: RAID backup
Date: Fri, 4 Oct 2002 10:00:51 +0200
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20021004080051.GB10028@marowsky-bree.de>
References: <3D9CA1C7.2000405@cfht.hawaii.edu> <CFEAJJEGMGECBCJFLGDBCENHCEAA.enorwood@effrem.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CFEAJJEGMGECBCJFLGDBCENHCEAA.enorwood@effrem.com>
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2002-10-03T16:59:57,
   Effrem Norwood <enorwood@effrem.com> said:

> With multiple inexpensive large disk arrays from companies like Netwo=
rk
> Appliance (NearStor) and Exstor (T-2120) organizations are asynchrono=
usly
> mirroring their data to geographically distant locations to prevent s=
ingle
> points of failure with their arrays.

Let's just point out that Linux can do that too with drbd.

(I wonder if that will stay a separate module or whether it'll become a=
 EVMS
plugin ;-)


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
Principal Squirrel
Research and Development, SuSE Linux AG
=20
``Immortality is an adequate definition of high availability for me.''
	--- Gregory F. Pfister
