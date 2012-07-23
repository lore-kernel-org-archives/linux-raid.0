From: Drew <drew.kay@gmail.com>
Subject: Re: [RFE] Please, add optional RAID1 feature (= chunk checksums) to
 make it more robust
Date: Mon, 23 Jul 2012 14:31:36 -0700
Message-ID: <CACJz6Qu6qVAroTTZJL=Q_Gs5VRsn=VttaKMu0WOKCh2sdJdgqQ@mail.gmail.com>
References: <500CD32E.4000800@hardwarefreak.com> <542194327.593466.1343036057599.JavaMail.root@redhat.com>
 <20120723170320.GA2691@lazy.lzy> <CABYL=Tq0w150QMcehdsScUfDfCD2tGFeuROjWjwsepy1rRXk_w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CABYL=Tq0w150QMcehdsScUfDfCD2tGFeuROjWjwsepy1rRXk_w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Been mulling this problem over and I keep getting hung up on one
problem with ECC on a two disk RAID1 setup.

In the event of silent corruption of one disk, which one is the good copy?

It works fine if the ECC code is identical across both mirrors. Just
checksum both chunks and discard the incorrect one.

It also works fine if the ECC codes are corrupted but the data chunks
are identical. Discard the bad checksum.

What if the corruption goes across several sectors and both data & ECC
chuncks are corrupted? Now you're back to square one.


-- 
Drew

"Nothing in life is to be feared. It is only to be understood."
--Marie Curie
