From: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: Care and feeding of RAID?
Date: Wed, 6 Sep 2006 09:41:55 +0200
Message-ID: <edlu43$jo4$4@sea.gmane.org>
References: <44FD722C.7050608@waldoware.com> <Pine.LNX.4.56.0609051414310.17570@lion.drogon.net> <44FD91D1.7090501@maine.edu> <Pine.LNX.4.56.0609051749430.17570@lion.drogon.net>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Gordon Henderson <gordon@drogon.net> wrote:
> I don't have any mdadm.conf files ... What am I missing? (I've always been
> under the impression that after needing the /etc/raidtab file with the old
> raidtools, you didn't need a config file as such under mdadm...  However,

You don't necessarily need one. However, since Neil considers in-kernel
RAID-autodetection a bad thing and since mdadm typically relies on
mdadm.conf for RAID-assembly and since especially with newer kernels you
probably need to auto-create device nodes (2.6 and udev), it's more
convenient to have one. Though you could live without one even then.

I did also run without one over a long time and I also don't like it to
have one, however, sometimes in the past convenience won :)


regards
   Mario
-- 
There is nothing more deceptive than an obvious fact.
             -- Sherlock Holmes by Arthur Conan Doyle

