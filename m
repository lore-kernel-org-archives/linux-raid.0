From: Mark Knecht <markknecht@gmail.com>
Subject: --chunk & pretend?
Date: Sun, 16 Jan 2011 16:11:51 -0800
Message-ID: <AANLkTik53ynBsXKiV58c-Xu6yNZ1MWF5jWeeiwEPM=Mu@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,
   I've partitioned 5 drives to create a RAID6. I have a few questions:

1) Is there a 'pretend' option for create? Something that would say
all the things it intended to do but then do nothing?

2) For the uninitiated, what should I be considering about chunk size?
The machine is a home server. It runs a bunch of VMWare and Virtualbox
VMs. The VM's typically result in a few large files. (2GB or larger)
Is the 512K default reasonable for this work model?

Thanks,
Mark
