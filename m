From: danci@agenda.si
Subject: Re: big fault :-)
Date: Wed, 12 Oct 2005 11:41:39 +0200 (CEST)
Message-ID: <Pine.LNX.4.61.0510121136250.27472@desktop.agenda.si>
References: <434BE7CA.4040707@gmx.de>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-154940912-1887062804-1129110099=:27472"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <434BE7CA.4040707@gmx.de>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-15?Q?Karsten_R=F6mke?= <k.roemke@gmx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---154940912-1887062804-1129110099=:27472
Content-Type: TEXT/PLAIN; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT

On Tue, 11 Oct 2005, Karsten Römke wrote:

> Oct 11 18:15:44 hhbgate kernel: end_request: I/O error, dev hda, sector
> 97562304
> Oct 11 18:15:44 hhbgate kernel: raid1: hda: unrecoverable I/O read error for
> block 94440448
> 
> the recovering prozess starts again and again.
> 
> Any hints what to do?

Try to save as much data as possible to a new, known good disk - as soon 
as possible. You might be lucky and the data is not spread over those bad 
sectors...

Syncing the array will *always* hit bad sectors and thus will *always* 
fail.

 D.



---154940912-1887062804-1129110099=:27472--
