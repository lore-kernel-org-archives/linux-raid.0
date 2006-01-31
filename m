From: "Enrique Garcia Briones" <egarcia@mail.uadec.mx>
Subject: Configuring combination of RAID-1 RAID-5
Date: Tue, 31 Jan 2006 10:43:59 -0600
Message-ID: <20060131163248.M20133@mail.uadec.mx>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

Let me introduce myself.

I'm newbie in linux and in RAID over linux, I have configured a RAID-0 in a 
NetBSD 2.0 BOX. so, now let me explain what I'm trying to do,

Antecedents/Equipment:

I have a Sparc 420 with 4 processors and 4 Gb in RAM, two SCSI SEAGATE 
internal hard disk with an array of 12 hard disks (Storedge 1000).

What we want to have:

We installed Debian Linux (I think it is 3.1 with kernel 2.4), and we want 
to have the following configuration:

1 System Harddisk
1 RAID-1 Mirror Hard Drive
12 Hard drives in RAID-5, 10 working and 2 as spare disks.

I have read the setting-up for the raid-5 and 1, but I would like to ask you 
if I can set-up a combined RAID configuration as mentioned above, since all 
the examples I found upto now just talk of one RAD configuration, besides 
this, I would like to ask you that if the configuration I want to have is 
STRONG enough for the quantity of disk in the box, or if there must be any 
other considerations to have.

I really don't expect you to gave me all the answers, just to aimed me to 
the right direction would be really appreciated.

Thanks in Advance

Enrique Garcia Briones

--
UAdeC http://www.uadec.mx
En el Bien fincamos el Saber
Open WebMail Project (http://openwebmail.org)

