From: Luca Berra <bluca@comedia.it>
Subject: Re: Configurazione RAID SOFTWARE su vecchio PC: CONSIGLI
Date: Mon, 14 Dec 2009 08:37:12 +0100
Message-ID: <20091214073712.GA31774@maude.comedia.it>
References: <26769455.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <26769455.post@talk.nabble.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Sorry for italian here, english translation at bottom

Prima di tutto, come ti hanno gia' fatto notare, scrivere in italiano q=
ui
e' stato scortese, la prossima volta prima di buttarti a pesce dai un
occhiata agli archivi...

On Sun, Dec 13, 2009 at 12:35:39PM -0800, mig81 wrote:
>Ciao a tutti, mi sono appena iscritto su questo forum per chiedervi un
>consiglio riguardo la configurazione di un  Pentium PRO 166 MHz con 64=
 Mb di
>RAM un controller SCSI Adaptech AHA-2940U con collegati 2 HD Viking SC=
SI da
>4,5 Gb l'uno ed un CD-ROM SCSI. HD Maxtor 80 Gb su IDE ATA-133, lettor=
e
>floppy
bel pezzo da museo, immagino tu abbia gia' valutato l'opzione di
rottamare il tutto....

>Il controller SCSI non permette di creare un RAID hardware e quindi de=
vo
>optare per uno software.
>Ho una RED HAT 7.0 che permette di costruire un array software e quind=
i di
>fare un RAID 0/1/5 in fase di installazione.=20
>
>Anzi tutto vorrei sapere come =E8 pi=F9 opportuno collegare i 2 HD SCS=
I: uno lo
>collego alla piattina interna del controller e l'altro HD sulla piatti=
na
>esterna, anzich=E8 entrambi sulla stessa piattina come li ho sempre av=
uti,
>giusto?=20
lasciali sulla piattina interna, in ogni caso e' sempre lo stesso canal=
e
e cosi' ti risparmi un terminatore e un cavo.

>Poi, qunado costruisco il file system come mi conviene suddividere gli=
 hard
>disk? mi conviene creare la /home su quello IDE da 80 Gb? il boot load=
er
dipende da quanto spazio hai bisogno per la home, in linea di massima
si.
>credo debba installarlo su l'HD da 80 Gb perch=E8 il bios se  rileva l=
'HD sul
>IDE cerca automaticamnete il bootloader su di quello e se non lo trova=
 non
>parte.....
a meno di non disabilitare il riconoscimento degli hard disk dal bios,
linux comunque lo trova lo stesso.

>Avete consigli utili? Anzich=E8 una vecchia REDHAT =E8 meglio che util=
izzi un
>altro sistema operativo?
come qualcuno ha gia' detto forse debian supporta ancora quell'hardware
e almeno ci sono ancora gli update. Il problema e' che e' molto diversa
dalla redhat che probabilmente conosci.

In ogni caso io averi qualche remora a creare un raid-0 su dei dischi
cosi' vecchi, se uno dei due si dovesse guastare perdi tutto.

english translation:
(hw description is fairly understandable)
Nice stuff for a museum. i believe you already dismissed the opportunit=
y
to decommission it.

> Scsi controller does not allow making a HW raid, so i have to make a
> software raid.
> I have a Redhat 7, that allows configuring a sw raid during install.
>
> First question is, should i connect the two scsi HDD one on the
> internal scsi port and the other one on the external?
No, you should only use the internal scsi port, it is the same channel
anyway and you save a cable and a terminator.

> How should map the filesystems to the different hard drives? should i
> put /home on the IDE?
It depends on your space requirements, probably yes.
> I believe i should install the boot loader on the IDE drive, since
> bios tries to boot from that one.
You can always disable the drive from the bios. linux does not care.

> do you have any useful hint? would it be better using a different os
> than an old redhat?
As someone already said you can try with a debian, it should support
your old hw and still provide updates. The issue might be that it is
quite different from the redhat system you are probably accustomed to.

In any case i would be wary of creating a raid0 on a couple of very old
disks, if a single one fails you loose all data.

Ciao,
L.


--=20
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
