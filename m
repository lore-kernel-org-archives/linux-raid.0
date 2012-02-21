From: =?iso-8859-1?Q?=C1lvaro_L=F3pez_L=F3pez?= <allopez@gmv.com>
Subject: RAID1 content under Windows OS
Date: Tue, 21 Feb 2012 19:50:59 +0100
Message-ID: <FCC44AC27019AF49B444F7E7F684FABD01DE8B605CA4@GMVMAIL4.gmv.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: es-ES
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I have been able to create a RAID 1 device in a Linux 2.6.36 system using mdadm command. 

Both disks had been formatted using mkdosfs in order to be mounted with type vfat. I also changed its label using cfdisk from "Linux" to the "W95 FAT32".

After mounting the RAID1 device MD0 in the filesystem, I copy some files inside the folder associated to the RAID1. I can see the contents when MD0 is mounted
inside Linux, not if disks are mounted separately.

Then, when I connect both disks to a Windows XP or 7 OS I cannot see any content inside them.

Is it possible to see the content? What can I do?

Thanks in advance,

Alvaro



______________________
This message including any attachments may contain confidential 
information, according to our Information Security Management System,
 and intended solely for a specific individual to whom they are addressed.
 Any unauthorised copy, disclosure or distribution of this message
 is strictly forbidden. If you have received this transmission in error,
 please notify the sender immediately and delete it.

______________________
Este mensaje, y en su caso, cualquier fichero anexo al mismo,
 puede contener informacion clasificada por su emisor como confidencial
 en el marco de su Sistema de Gestion de Seguridad de la 
Informacion siendo para uso exclusivo del destinatario, quedando 
prohibida su divulgacion copia o distribucion a terceros sin la 
autorizacion expresa del remitente. Si Vd. ha recibido este mensaje 
 erroneamente, se ruega lo notifique al remitente y proceda a su borrado. 
Gracias por su colaboracion.

______________________

