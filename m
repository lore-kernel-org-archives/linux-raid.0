From: "Enrique Garcia Briones" <egarcia@mail.uadec.mx>
Subject: RAID-1 and RAID(5 or 6) on Sparc HELP
Date: Tue, 28 Feb 2006 09:45:43 -0600
Message-ID: <20060228152109.M9744@mail.uadec.mx>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: debian-sparc@lists.debian.org, linux-raid@vger.kernel.org
Cc: cmontoya@mail.uadec.mx
List-Id: linux-raid.ids

Hi listers,

I hope someone can help me to aim in the right direction.

I'km trying to put an RAID-1 and RAID-(5 or 6) in a Sun420 with an A1000 
disk array with (12 * 36gb) and 2 internal HDD.

I have been following the instructions in the following links:

http://www.epimetrics.com/topics/one-page?page_id=421&topic=Bit-head%
20Stuff&page_topic_id=120 

http://translate.google.com/translate?u=http%3A%2F%2Fwww.sunwizard.net%
2Fhtml%2Farticles%2Fsl001.html&langpair=fr%7Cen&hl=fr&ie=UTF-8&oe=UTF-
8&prev=%2Flanguage_tools 
 
http://marc.theaimsgroup.com/?l=linux-sparc&m=101787980731878&w=2

And as well a lot of Deep Google-ing...

And I have stuck in the step when setting up the disc B of the array and 
ready to boot from a reduced raid-1, after modifying the FSTAB and SILO.CONF 
files, all I can get is KERNEL PANIC

I have already compile the RAID-1 directly in the kernel, it seems to be 
correctly configured.

It seems to me that I have to put a boot point in the disk B, someone 
suggested me to use mkinitrd, but after reading the man pages for this 
command I can't be able to figure out how to do that.

my fdisk -l are the followings:

DISK A

debian:/etc/mkinitrd# fdisk -l /dev/sda

Disco /dev/sda (etiqueta de disco Sun): 64 cabezas, 32 sectores, 34732 
cilindros
Unidades = cilindros de 2048 * 512 bytes

Disposit. Indic.  Principio   Fin    Bloques  Id  Sistema
/dev/sda1             0      9537   9765888    1  Inicio
/dev/sda2          9537     13352   3906560   82  Linux swap
/dev/sda3             0     34732  35565568    5  Disco completo
/dev/sda4         13352     18216   4980736   83  Linux native
/dev/sda5         18216     23080   4980736   83  Linux native
/dev/sda6         23080     34732  11931648   83  Linux native
debian:/etc/mkinitrd# 


DISK B

debian:/etc/mkinitrd# fdisk -l /dev/sdm

Disco /dev/sdm (etiqueta de disco Sun): 64 cabezas, 32 sectores, 34730 
cilindros
Unidades = cilindros de 2048 * 512 bytes

Disposit. Indic.  Principio   Fin    Bloques  Id  Sistema
/dev/sdm1             0      9537   9765888   fd  Linux raid autodetect
/dev/sdm2          9537     13352   3906560   82  Linux swap
/dev/sdm3             0     34730  35563520    5  Disco completo
/dev/sdm4         13352     18216   4980736   fd  Linux raid autodetect
/dev/sdm5         18216     23080   4980736   fd  Linux raid autodetect
/dev/sdm6         23080     34730  11929600   fd  Linux raid autodetect
debian:/etc/mkinitrd# 


The /dev/sda if the first HDD of the A1000 and the /dev/sdm is the first 
internal HDD

the /dev/sdm have already a 'cp' of the /dev/sda

Must I use /dev/sda and /dev/sdb to have this working?
Any plans to make work correctly seting up RAID from installation in Sparc?
Can I have more that one disk with boot-able partition? if so, I haven't got 
any clues on how to do that.

The rest of the disks in the BOX are for configuring the raid-(5 or 6)

Please, any suggestion will be greatly appreciated, whatever crazy idea 
would be good.

Thanks in Advance.

Enrique

--
UAdeC
En el Bien fincamos el Saber
Open WebMail Project (http://openwebmail.org)

