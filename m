From: Nikolay Kichukov <hijacker@oldum.net>
Subject: data scrubbing
Date: Fri, 29 Jul 2011 11:50:13 +0300
Message-ID: <4E327445.9080404@oldum.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi all,

Recently on this list it was discussed it is a good practice to perform data scrubbing for some raid levels.
Can someone advise what raid levels need that operation scheduled on a regular basis? Perhaps all raid arrays that have:

/sys/block/md*/md/sync_action

[sync_action] property?

For example is it good for raid1 array?

Cheers,
- -Nik
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJOMnRFAAoJEDFLYVOGGjgX9c8H+wSgfQwiTsE5bjLClmiset2Q
CIBJoqyzVMX8MTLr3yeSEtk2rjG1byKCuc9+Ie7GR0gVx2hW2Hnvb13myOQB1Uww
GH1LI3sTGyet43fPK5JXMwyhBrAiAnh4HMLCSTK3WdWrjfRtaanddDMQDdk4DHVF
wg7xB1NWfsnkOtA0vdgMXQ9Oki1LuBPi9PuZg2Gr4IxdSPm010wDCbJjDRqYBlr4
jE99Elh6oZes+6OImmeMRGz7UJaqC+581/nM/KVMpBEwkOT9jMJKujgRAhLc0pf2
KjjDq6o2/UpIyVTf+EEgdThRL4/PM7g8TaDMBA/pthQKBzoHHJudTa/flzzW6rE=
=WpkM
-----END PGP SIGNATURE-----
