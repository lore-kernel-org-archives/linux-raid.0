From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: [RFE] Please, add optional RAID1 feature (= chunk checksums)
 to make it more robust
Date: Mon, 23 Jul 2012 23:42:38 -0500
Message-ID: <500E27BE.3040605@hardwarefreak.com>
References: <500CD32E.4000800@hardwarefreak.com> <542194327.593466.1343036057599.JavaMail.root@redhat.com> <20120723170320.GA2691@lazy.lzy> <CABYL=Tq0w150QMcehdsScUfDfCD2tGFeuROjWjwsepy1rRXk_w@mail.gmail.com> <CACJz6Qu6qVAroTTZJL=Q_Gs5VRsn=VttaKMu0WOKCh2sdJdgqQ@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CACJz6Qu6qVAroTTZJL=Q_Gs5VRsn=VttaKMu0WOKCh2sdJdgqQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Drew <drew.kay@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 7/23/2012 4:31 PM, Drew wrote:

> What if the corruption goes across several sectors and both data & ECC
> chuncks are corrupted?

What if the 'silent' corruption spans 10 million sectors (~5GB)?

-- 
Stan

