From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: mdadm RAID6 faulty drive
Date: Tue, 26 Mar 2013 21:05:59 +0100 (CET)
Message-ID: <13291185.10.1364328359906.JavaMail.root@zimbra>
References: <51508CD6.50702@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51508CD6.50702@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org, Meenakshisundaram Paramasivam <mparamas@iupui.edu>
List-Id: linux-raid.ids

> You could also show us some of the kernel error messages, or show the
> output of "smartctl -x /dev/sdf".

I second that. Also, if the command above shows no errors, do tests wit=
h smartctl -t short and -t long. If those succeed, you may try to re-ad=
d it, but I wouldn't --assume-clean. Better go through a normal rebuild=
 to see if any errors occur.

Vennlige hilsener / Best regards

roy
--
Roy Sigurd Karlsbakk
(+47) 98013356
roy@karlsbakk.net
http://blogg.karlsbakk.net/
GPG Public key: http://karlsbakk.net/roysigurdkarlsbakk.pubkey.txt
--
I all pedagogikk er det essensielt at pensum presenteres intelligibelt.=
 Det er et element=C3=A6rt imperativ for alle pedagoger =C3=A5 unng=C3=A5=
 eksessiv anvendelse av idiomer med xenotyp etymologi. I de fleste tilf=
eller eksisterer adekvate og relevante synonymer p=C3=A5 norsk.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
