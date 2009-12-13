From: mig81 <fluxus@sonicurbs.com>
Subject: Configurazione RAID SOFTWARE su vecchio PC: CONSIGLI
Date: Sun, 13 Dec 2009 12:35:39 -0800 (PST)
Message-ID: <26769455.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Ciao a tutti, mi sono appena iscritto su questo forum per chiedervi un
consiglio riguardo la configurazione di un  Pentium PRO 166 MHz con 64 =
Mb di
RAM un controller SCSI Adaptech AHA-2940U con collegati 2 HD Viking SCS=
I da
4,5 Gb l'uno ed un CD-ROM SCSI. HD Maxtor 80 Gb su IDE ATA-133, lettore
floppy

Il controller SCSI non permette di creare un RAID hardware e quindi dev=
o
optare per uno software.
Ho una RED HAT 7.0 che permette di costruire un array software e quindi=
 di
fare un RAID 0/1/5 in fase di installazione.=20

Anzi tutto vorrei sapere come =C3=A8 pi=C3=B9 opportuno collegare i 2 H=
D SCSI: uno lo
collego alla piattina interna del controller e l'altro HD sulla piattin=
a
esterna, anzich=C3=A8 entrambi sulla stessa piattina come li ho sempre =
avuti,
giusto?=20
Poi, qunado costruisco il file system come mi conviene suddividere gli =
hard
disk? mi conviene creare la /home su quello IDE da 80 Gb? il boot loade=
r
credo debba installarlo su l'HD da 80 Gb perch=C3=A8 il bios se  rileva=
 l'HD sul
IDE cerca automaticamnete il bootloader su di quello e se non lo trova =
non
parte.....

Avete consigli utili? Anzich=C3=A8 una vecchia REDHAT =C3=A8 meglio che=
 utilizzi un
altro sistema operativo?

Spero di ricevere qualche risposta........
Grazie sin da ora!
--=20
View this message in context: http://old.nabble.com/Configurazione-RAID=
-SOFTWARE-su-vecchio-PC%3A-CONSIGLI-tp26769455p26769455.html
Sent from the linux-raid mailing list archive at Nabble.com.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
