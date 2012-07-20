From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: [RFE] Please, add optional RAID1 feature (= chunk checksums) to
 make it more robust
Date: Fri, 20 Jul 2012 15:30:33 -0300
Message-ID: <CABYL=Trp+n2gqzSw6yzr1E=YdMxiU5-rG=5njKbmB=divonUsg@mail.gmail.com>
References: <50078375.7050208@hardwarefreak.com>
	<f05fcb33-b518-426e-b308-6fac462554fd@zmail15.collab.prod.int.phx2.redhat.com>
	<CABYL=Tqc4D00Y9S5Ow5mzgqvGFtx6qh=XhQQUXzpcUuReNniyA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CABYL=Tqc4D00Y9S5Ow5mzgqvGFtx6qh=XhQQUXzpcUuReNniyA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jaromir Capik <jcapik@redhat.com>
Cc: stan@hardwarefreak.com, NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Just some examples... searching on google (silent data loss) some guys
report silent loss, but the NEC study is usefull to support Jamiro
report...

http://www.necam.com/Docs/?id=3D54157ff5-5de8-4966-a99d-341cf2cb27d3

page 3)
Silent data corruption
Introduction
There are certain types of storage errors that go completely
unreported and undetected in
other storage systems which result in corrupt data being provided to
applications with no
warning, logging, error messages or notification of any kind.  Though
the problem is
frequently identified as a silent read failure, the root cause can be
that the write failed,
thus we refer to this class of errors as =93silent data corruption.=94
These errors are difficult
to detect and diagnose, yet what=92s worse is they are actually fairly
common in systems
without an extended data integrity feature.



--=20
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
