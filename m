From: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: mdadm --detail showing annoying device
Date: Thu, 22 Oct 2009 13:29:16 +0200
Message-ID: <slrnhe0ggc.sn.Mario.Holbe@darkside.dyn.samba-tng.org>
References: <alpine.DEB.2.00.0910171825270.16781@p34.internal.lan>
 <alpine.DEB.2.00.0910181607040.27363@p34.internal.lan>
 <20091019030456.GS9464@discord.disaster>
 <alpine.DEB.2.00.0910190431180.23395@p34.internal.lan>
 <20091020003358.GW9464@discord.disaster>
 <alpine.DEB.2.00.0910200431290.21878@p34.internal.lan>
 <alpine.DEB.2.00.0910210618210.10288@p34.internal.lan>
 <4ADF17EC.6090606@forumdesimages.fr>
 <19167.33065.766493.889406@notabene.brown>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown <neilb@suse.de> wrote:
> On Wednesday October 21, stephane.bunel@forumdesimages.fr wrote:
>>         0       8        0        0      active sync   /dev/char/21:0
>>         1       8       16        1      active sync   /dev/char/21:1
> What is a block device doing in /dev/char ???  There should only be
> character devices in there.

major 21 are usually SCSI generic devices (/dev/sg) and they are char...
crw-rw----  1 root root  21, 0 Oct 10 21:48 /dev/sg0
crw-rw----  1 root root  21, 1 Oct 10 21:48 /dev/sg1

The question is, why do they appear at mdadm --detail


regards
   Mario
-- 
There are trivial truths and the great truths.
The opposite of a trivial truth is plainly false.
The opposite of a great truth is also true.
                                    -- Niels Bohr

