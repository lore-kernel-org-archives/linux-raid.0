From: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: RAID5: *all* of my drives are now spares
Date: Tue, 27 Oct 2009 10:30:03 +0100
Message-ID: <slrnhedfcr.cca.Mario.Holbe@darkside.dyn.samba-tng.org>
References: <2c2a4e250910261845w7e62274es63b5fcebdfce034e@mail.gmail.com>
 <960e25b92f434569a5833ffda52a1f25.squirrel@neil.brown.name>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown <neilb@suse.de> wrote:
> On Tue, October 27, 2009 12:45 pm, John P Poet wrote:
>> md3 : inactive sdk[0](S) sdf[1](S) sdg[2](S) sdj[4](S)
>>       7814056960 blocks super 1.2
> However the --examine shows that 3 of the 4 devices report a role
> of 'spare'... which is odd because "--assemble --force" managed to

Hmmm, it's not. Yes, it's odd but not unusual for v1 metadata :)
Please have a look at the thread starting with:

From: John Hughes <john@Calva.COM
Subject: Dumb questions about mdadm #1 - replacing broken disks - "slot" reuse?
Date: Fri, 18 Sep 2009 14:13:44 +0200
Message-ID: <4AB37978.5030403@Calva.COM>

John and me reported something that looks quite similar to me for v1
metadata already (and the OP runs v1.2 metadata).


regards
   Mario
-- 
Ho ho ho! I am Santa Claus of Borg. Nice assimilation all together!

