From: "Slawomir Socha" <socha_s@tlen.pl>
Subject: Mdadm reporting on RAID0
Date: Mon, 28 Feb 2005 14:09:36 +0100
Message-ID: <000701c51d96$c0d176e0$020aa8c0@llnx7pzaq0g0w3>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

Forgive me if this is one of those simple questions and the answer is
clearly documented, but I have tried to find it and can not.


If we have a RAID0 and remove a drive in turn causing a fatal fail state..
How do we know (other than i/o errors)?  Mdadm seems to say that the raid is
still 'active' and does not report it as faulty.. At least not the way we
have configured it.


Any help would be appreciated

Slawomir Socha

