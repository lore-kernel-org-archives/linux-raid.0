From: Danilo Godec <danilo.godec@agenda.si>
Subject: Re: SATA errors?
Date: Wed, 01 Oct 2008 12:41:25 +0200
Message-ID: <48E353D5.1060908@agenda.si>
References: <48E34221.1000008@agenda.si> <20081001100833.3253724847@gemini.denx.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060303090806010300040904"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20081001100833.3253724847@gemini.denx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Wolfgang Denk <wd@denx.de>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------060303090806010300040904
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Wolfgang Denk pravi:
> In my experience, problems like this are often casued by
> broken/unreliable cables / connectors / backplanes.
>
> As a first measure, try replugging the SATA cables.
>
> If this doesn't help, try swapping arount the disks and cables to see
> if the problem is with the cable (sticks with the disk) or  with  the
> backplance (sticks with a physical port).
>   
That has been one of my ideas too and I have already checked and swapped
cables - but no success. I couldn't change the backplane as I don't have
a spare one.

But there is one thing though that crossed my mind just seconds after
I've hit the 'send' button!

I periodically check (every minute)  the drive temperature using
'smartctl -a' and I only query one drive - '/dev/sda'! So I re-checked
my log files and indeed - the SATA error ALWAYS happens within one
second of the 'smartctl' command (but not every time).

So now I changed the scripts to query a different drive ('/dev/sdb'). In
a couple of hours I should know if that was it...

  Thanks for the help, Danilo

PS: Oh, one more thing - the 'sda' drive is a WDC, while all the others
are Seagate.


> Then replace the faulty components.
>
> Best regards,
>
> Wolfgang Denk
>
>   


-- 
Danilo Godec, sistemska podpora

Predlog! Obiscite prenovljeno spletno stran http://www.agenda.si

ODPRTA KODA IN LINUX
STORITVE : POSLOVNE RESITVE : UPRAVLJANJE IT : INFRASTRUKTURA IT : IZOBRAZEVANJE : PROGRAMSKA OPREMA

Visit our updated web page at http://www.agenda.si

OPEN SOURCE AND LINUX
SERVICES : BUSINESS SOLUTIONS : IT MANAGEMENT : IT INFRASTRUCTURE : TRAINING : SOFTWARE 


--------------060303090806010300040904
Content-Type: text/x-vcard; charset=utf-8;
 name="danilo_godec.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="danilo_godec.vcf"

begin:vcard
fn:Danilo Godec
n:Godec;Danilo
org:Agenda OpenSystems
adr:;;Ul. Pohorskega bataljona 49;Maribor;;2000;Slovenia
email;internet:danilo.godec@agenda.si
tel;work:+386 2 4216138
tel;fax:+386 2 4216141
tel;cell:+386 40 618802
x-mozilla-html:FALSE
url:http://www.agenda.si/
version:2.1
end:vcard


--------------060303090806010300040904--
