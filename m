From: Tom Peters <tpeters@mixcom.com>
Subject: benchmarking
Date: Wed, 01 Feb 2006 18:28:43 -0600
Message-ID: <5.1.0.14.2.20060201182533.0b78b008@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Does Linux (SuSE 9) have a tool that will give me a handle on read/writ=
e=20
throughput to a drive without trashing anything on the drive (i.e. usin=
g=20
empty space on it)?  I have an 8-drive array and sometimes writes to it=
=20
fail over the network (Samba) and I can't prove its the array and not t=
he=20
network.

I've played with hdparm -Tt and gotten some idea. What else can I try t=
hat=20
won't take a lot of setup?






[Computing] B can be thought of as C without types; more accurately,
it is BCPL squeezed into 8K bytes of memory and filtered through
Thompson's brain. --Dennis Ritchie
--... ...--  -.. .  -. ----. --.- --.- -...
tpeters@nospam.mixcom.com   (remove "nospam") N9QQB (amateur radio)
"HEY YOU" (loud shouting)  WEB ADDRESS http//www.mixweb.com/tpeters
43=B0 7' 17.2" N by 88=B0 6' 28.9" W,  Elevation 815',  Grid Square EN5=
3wc
WAN/LAN/Telcom Analyst, Tech Writer, MCP, CCNA, Registered Linux User 3=
85531



-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
