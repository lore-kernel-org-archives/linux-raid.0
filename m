From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: [RFE] Please, add optional RAID1 feature (= chunk checksums) to
 make it more robust
Date: Tue, 24 Jul 2012 09:51:04 -0300
Message-ID: <CABYL=TpSEscGdzESPRycXvGv7o649xt7XCEPqNhCKQyien+K9Q@mail.gmail.com>
References: <500CD32E.4000800@hardwarefreak.com>
	<542194327.593466.1343036057599.JavaMail.root@redhat.com>
	<20120723170320.GA2691@lazy.lzy>
	<CABYL=Tq0w150QMcehdsScUfDfCD2tGFeuROjWjwsepy1rRXk_w@mail.gmail.com>
	<CACJz6Qu6qVAroTTZJL=Q_Gs5VRsn=VttaKMu0WOKCh2sdJdgqQ@mail.gmail.com>
	<500E27BE.3040605@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <500E27BE.3040605@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: Drew <drew.kay@gmail.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

10 milion bad blocks (5gb of lost information)
check that we are talking about one device (it can be a disk, a
partition, a raid1 a raid0, nbd, drbd, or anything else)

2012/7/24 Stan Hoeppner <stan@hardwarefreak.com>:
> On 7/23/2012 4:31 PM, Drew wrote:
>
>> What if the corruption goes across several sectors and both data & ECC
>> chuncks are corrupted?
>
> What if the 'silent' corruption spans 10 million sectors (~5GB)?
>
> --
> Stan
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Roberto Spadim
Spadim Technology / SPAEmpresarial
