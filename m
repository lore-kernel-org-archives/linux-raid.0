From: amritanshu johri <jeane.genet@gmail.com>
Subject: Need for init:query
Date: Wed, 14 Dec 2005 20:15:05 +0800
Message-ID: <53aae5ff0512140415m54ea4162y48517f989e06eb40@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,
My query has more to do with raid algorithms rather than the Linux
implementation.
Let me know if I'm off topic :).

I am planning to build system where it is possible to create 100's of
array(raid 5) at a time, that means some of them can go faulty even
before init-task is complete.If INIT hasn't completed then there is no
way to rebuild the array(?).

Lets say raid-subsystem does things this way.
We bypass init.
Array is RUNNING The stripes are always cached in memory.
a)whenever a cache miss happens we read the whole stripe(except parity)=
=2E
b) whenever we write to the disk we recompute parity based on the data
and write it to disk.
c)Now if a single disk fault happens the array is in REBUILD_REQUIRED
state,for every read we recompute the parity and give the data back.

The assumption here I make is that reads wont happen for locations
where writes haven't happened. The exceptions are for boot sector and
partition tables.

I wanted to know if this is the right approach am I overlooking some as=
pect?

Please excuse my poor English. I hope I was able to convey the qry.

Regards,
Jeane.


--
"L'existence pr=E9c=E8de et commande l'essence."  --Jeane Paul Sartre
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
