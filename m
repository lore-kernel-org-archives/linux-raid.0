From: Gionatan Danti <g.danti@assyoma.it>
Subject: RAID 10 far and offset on-disk layouts
Date: Fri, 27 Dec 2013 15:29:49 +0100
Message-ID: <52BD8EDD.10809@assyoma.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,
I (think of) quite well understand how far and offset work, but I can 
not find any data on the precise on-disk layout.

FAR LAYOUT
md(4) states:
"The first copy of all data blocks will be striped across the early part 
of all drives in RAID0 fashion, and then the next copy of all blocks 
will be striped across a later section of all drives, always ensuring 
that all copies of any given block are on different drives"

The "on different drives" part let me wonder _how_ are chunks 
distributed. On a 4-disk array, I can imagine some different schemas:

1)	A1 A2 A3 A4
	.. .. .. ..
	A4 A1 A2 A3

2)	A1 A2 A3 A4
	.. .. .. ..
	A2 A1 A4 A3

The first schema is the one depicted by SuSe documentation [1], while 
the second is the one described by Wikipedia [2].

Question 1: as the two schema have different reliability 
characteristics, which is really used?

OFFSET LAYOUT
md(4) states:
"When 'offset' replicas are chosen, the multiple copies of a given chunk 
are laid out on consecutive drives and at consecutive offsets. 
Effectively each stripe is duplicated and the copies are offset by one 
device."

This means a schema like this:
	
3)	A1 A2 A3 A4
	A4 A1 A2 A3
	.. .. .. ..

However, this is susceptible to any consecutive two-disk failures. A 
schema like

4)	A1 A2 A3 A4
	A2 A1 A4 A3

would not suffer from this problem (eg: disk 2 & 3 can fail and the 
array is still working).

Question 2: apart from simplicity, why the offset layout use the schema 
as n.3? I miss something?

Regards.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
