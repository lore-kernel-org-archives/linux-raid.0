From: Bernd Schubert <bernd.schubert@pci.uni-heidelberg.de>
Subject: is raid of raid possible ?
Date: Fri, 11 Jul 2003 16:09:54 +0200
Sender: enbd-admin@lists.community.tummy.com
Message-ID: <200307111609.54844.bernd.schubert@pci.uni-heidelberg.de>
Reply-To: enbd@lists.community.tummy.com
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <enbd-admin@lists.community.tummy.com>
Content-Disposition: inline
Errors-To: enbd-admin@lists.community.tummy.com
List-Unsubscribe: <http://lists.community.tummy.com/mailman/listinfo/enbd>,
	<mailto:enbd-request@lists.community.tummy.com?subject=unsubscribe>
List-Post: <mailto:enbd@lists.community.tummy.com>
List-Help: <mailto:enbd-request@lists.community.tummy.com?subject=help>
List-Subscribe: <http://lists.community.tummy.com/mailman/listinfo/enbd>,
	<mailto:enbd-request@lists.community.tummy.com?subject=subscribe>
List-Archive: <http://lists.community.tummy.com/pipermail/enbd/>
To: linux-raid@vger.kernel.org
Cc: enbd@lists.community.tummy.com
List-Id: linux-raid.ids

Hi,

for fallback reasons of an existing server with software-raid5 I would like=
 to=20
install a raid1 via enbd to another system of this raid5-device.

scheme-1:
server1(software-raid5)-->raid1-->enbd-->fall-back server(hardisk or=20
software-raid)

scheme-2:
server1(software-raid5)-->enbd-->fall-back-server(hardisk)--raid1

I guess that scheme-2, so exporting a mdX-device via enbd and importing thi=
s=20
device on the fallback-server and mirroring it via raid1 to another=20
hardisk-partition should work anyway.

But whats about scheme-1 in general ? Or in scheme-2 if one would like to p=
ut=20
the the raid1 to another software-raid5 ?

Thanks in advance,
	Bernd

=2D-=20
Bernd Schubert
Physikalisch Chemisches Institut / Theoretische Chemie
Universit=E4t Heidelberg
INF 229
69120 Heidelberg
e-mail: bernd.schubert@pci.uni-heidelberg.de
