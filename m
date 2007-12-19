From: Thierry Iceta <Thierry.Iceta@bull.net>
Subject: ERROR] scsi.c: In function 'scsi_get_serial_number_page'
Date: Wed, 19 Dec 2007 12:56:45 +0100
Message-ID: <476906FD.3040605@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi

I would like to use raidtools-1.00.3 on Rhel5 distribution
but I got thie error
Could you tell me if a new version is available or if a patch exists
to use raidtools on Rhel5
Thanks for your answer

Thierry

gcc -O2 -Wall -DMD_VERSION=3D\""raidtools-1.00.3"\" -c -o rrc_common.o=20
rrc_common.c
raid_io.c:96: error: expected declaration specifiers or =E2 before =E2
raid_io.c:96: error: expected declaration specifiers or =E2 before =E2
raid_io.c:96: error: expected declaration specifiers or =E2 before =E2
raid_io.c:97: error: expected declaration specifiers or =E2 before =E2
raid_io.c:97: error: expected declaration specifiers or =E2 before =E2
raid_io.c:98: error: expected declaration specifiers or =E2 before =E2
raid_io.c:101: warning: return type defaults to =E2
raid_io.c: In function =E2:
raid_io.c:102: error: expected =E2, =E2, =E2, =E2 or =E2 before =E2 tok=
en
raid_io.c:119: error: expected =E2, =E2, =E2, =E2 or =E2 before =E2 tok=
en
raid_io.c:214: error: expected =E2, =E2, =E2, =E2 or =E2 before =E2 tok=
en
raid_io.c:267: error: expected =E2, =E2, =E2, =E2 or =E2 before =E2 tok=
en
raid_io.c:361: error: expected =E2, =E2, =E2, =E2 or =E2 before =E2 tok=
en
raid_io.c:519: error: expected =E2, =E2, =E2, =E2 or =E2 before =E2 tok=
en
raid_io.c:96: error: parameter name omitted
raid_io.c:96: error: parameter name omitted
raid_io.c:96: error: parameter name omitted
raid_io.c:97: error: parameter name omitted
raid_io.c:97: error: parameter name omitted
raid_io.c:98: error: parameter name omitted
raid_io.c:539: error: expected =E2 at end of input
make: *** [raid_io.o] Error 1
make: *** Waiting for unfinished jobs....
scsi.c: In function =E2:
scsi.c:434: warning: pointer targets in passing argument 2 of =E2 diffe=
r=20
in signedness

--=20
  __________________________________________________________________   =
    =20
                  Bull, Architect of an Open World TM
                    	 Open Software R&D

        Email   :Thierry.Iceta@bull.net
        Bull SA                Bullcom :229 76 29
        1, rue de Provence     Phone   :+33 04 76 29 76 29
        B.P. 208               http://www.bull.com                     =
    =20
        38432 Echirolles-CEDEX Office  :FREC B1-361=20
  __________________________________________________________________   =
    =20

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
