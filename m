From: "Slawomir Socha" <socha_s@tlen.pl>
Subject: "Global spare" with mdadm
Date: Mon, 28 Feb 2005 16:27:19 +0100
Message-ID: <013701c51da9$feb6d280$020aa8c0@llnx7pzaq0g0w3>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello!

Does anyone know if it is possible to assign a single spare drive to
multiple RAID sets using mdadm?

For example:  a system with 2 x RAID5 would generally have a single spare
drive.. the first RAID5 to fail grabs it and utilizes it.

Slawomir Socha



