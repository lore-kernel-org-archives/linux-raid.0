From: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: bitmap questions
Date: Thu, 14 Oct 2010 14:39:55 +0200
Message-ID: <slrnibdugr.c1r.Mario.Holbe@darkside.dyn.samba-tng.org>
References: <201010131824.53363.a.miskiewicz@gmail.com>
 <AANLkTikBAi=NO-uzkvtzwYsgLSf44KuA1VmvXj3d708_@mail.gmail.com>
 <201010140800.38419.a.miskiewicz@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Arkadiusz Miskiewicz <a.miskiewicz@gmail.com> wrote:
> So there is no way to know in advance how much is going to be resynced when 
> sudden reset would happen in that moment?

mdadm -X /dev/component-device


regards
   Mario
-- 
To err is human. To really foul things up requires a computer.

