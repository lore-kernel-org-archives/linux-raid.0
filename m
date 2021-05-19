Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 777E4C433ED
	for <linux-raid@archiver.kernel.org>; Wed, 19 May 2021 14:49:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4BDD260FDB
	for <linux-raid@archiver.kernel.org>; Wed, 19 May 2021 14:49:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354638AbhESOue (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 19 May 2021 10:50:34 -0400
Received: from sonic315-9.consmr.mail.gq1.yahoo.com ([98.137.65.33]:42918 "EHLO
        sonic315-9.consmr.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1354624AbhESOue (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Wed, 19 May 2021 10:50:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=att.net; s=s1024; t=1621435754; bh=/6tpliZNmAzOzDgW4M/vcO4S61PmRk0ePxpe//Twak4=; h=Subject:To:References:From:Date:In-Reply-To:From:Subject:Reply-To; b=wv7EKkew5r5B6dktHfbDmrprYtayCgcv19NswHLltj7uMsi5vJfphHcPV4/kEgwVGQnX1wC823cVBVkgOjl+oxWcmtgw2M4wsqp3F5JPlrBDKb8BR3UFYPldmclZ+OfU2LK8lEVcTBx9d1p2U8lDno3Xalc9WsQXHJV2UfBAFv4=
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1621435754; bh=9OacsENoFX/D/OSjMjN4gsJtmmDTBDs2pDx7YfwQbQ6=; h=X-Sonic-MF:Subject:To:From:Date:From:Subject; b=nqjPaoD58SU1gAcYsAJVdCUSDl5KjJ8JUTar+84aAY308jGBrzopayXflngEUgMDKPTCz362nBsIBCih+NgWjH3J47coF9v+9O/Ggppg6EQPSOK8NkWoPZp6FXBY13Lb+i/v5CBHzaL05oWoJuULvpBIDePRzvcH/nTe4ShY2hBKDYlHb074MhXHiCPNL+O8EVW0UAuQuWpsxds92uK/wI64p4dYa4u1NKyWlpc2AwGADS1g1cvfmOvNHpLJmW8bRVAh7S7C26pXJy1bVq2URyl/xqRA1Q+/aHC2G/fMVVRYaMGLRt+pfN4h5gpKonYD2toXXsUQLzWUKq7h29jkSw==
X-YMail-OSG: Mc.R_tgVM1mx2c5ir8ZPSwFUEN2GeByFAHiN5qYG9BekTg9Ig.Ep8AcyQPAWntG
 V7RCtx2a4Nn5rLoTaxaOGqJVE_1OEIlVSlW1CZINcfOBgincxCEP8Lutcj4jI1sNrYfN96vxxPCq
 rBpKG6ycIpniakBPm9o8frP6tjZNDOJZ75BOi9l9le0OIO5F6Ky6db5YJFvfSqOMcxjKkqGIvdSj
 oz6K5A7Uenh7IHhwd6yGM1URwAs842gpXlMlEuVZP1MORzDwvNyYFhbEje3J9orfj3zY2uOOnXkB
 2G1hKy9fbwCfv0pnF5Og_uIKh8XNJgpd90KYRRq4hZLXov6SPqvQ7WGDkwl2D6OEXKIKveXBP.vo
 KBt3XreKXXSeH4kTvUbwZM4ndC5ODVcYFzjopC_oTlzz6aFDz0LlIAl8J2euUW_mtLJp_Gf_l6JA
 durt26GBir9AEjzvAeBnk0drDAC0aDpqetPHi6BkbKYr6BOioRxM.jGtVUdPbyZA9AYH4xT9f8SW
 xb8vDmOYY8HzcqCqXlSpuaVX.fwbdyH_CRDPEt9zLss.xm3A2dQp3TY_92ACAiSfGmNrhjM7MCGG
 JyO6diJi9I9vuMNwp4OF.vlgmg_39oI2p8j5PuwjzPMigpSAS83MQnJHtt20m.NjF.ImbvKVtA5e
 Ku7kX4HRhxV2NRyFbEnmZKYn5Na6Br3F3NOQViqLyySQU8A8zpHwGkQQ9jblHK0U9ptfQJDskwyc
 I_Up7ZuEcBlGqpI0xOaQiSu24Kye.etlTcUtuqp8n_9hiWz5ZD4ihFqeT792lNyvsqhp2.CwHKJK
 _2OSuJ9.4ayQ52QQsnEyqGdxCk.PBOSq7pqxd5_w3KuFuPEC4Gx19w.cPe_92Kxf9HR0PLoRLgP4
 qSVtIZFol8IlcEwCsPrZZQuS_Xt7Wdh7nHAI5ONTggJ3O3BBpUP2B5yPHFRdTc2aR2wUJNDeXE94
 dXxoMkg03jvN3I9mwj6kXfxr6NPaMGoK6r4RtxPksOlbum6jahwPtLWXEK3RCrlFpI3QRcTYFmV0
 WqS46dQAhVPbJaDs_dQT8VHiOzVn6UVpktCAB2RySgrZRfHQenaoSp_sJ4YeT43y9HqqHwrjsxnN
 pnMBLKtwvmhwtgG1Wl0byHy6Fu.Vx9OfATgCwVBEapTKayZnrC0HehMfpNjo.gucf5qcYSq_LTcx
 vbh1jAmxQUSb9fP5drKiPi..VGYPQDwEj8a7ZGnx9hkYfUDWIVv7nWjsFDzV87TO60C.SDVT6OuR
 .S89ZROGGTWKb6ytFhMhMNUNvZhMbMEO7Nrw0VmKzM3WU8rRGfgK_hMDDB29Q0wzfBu.j8yfZX_u
 crv8LWZuldZiJGw9FsBue1JzyG3pV8Nor_sQL2uaFJ4qGHI6zYV3LiXXqNpQRr9ICpA88B.p0MEf
 MF9lL.KcR5sbQ8dbnrD5xC0x85LCSvpy_HhYfEnf.g4rScOT.SLVGq1NErvW2iv_g1sSjTUCfjCX
 EJ_iTWFzP7xnwcK363FZ2Nj4oWKWPVlZdrxhlz99.qSB4qVUwo7aPLGzZ7HDDbVEcGHQ1_rd83O6
 JUUe73JHiCFQM05DeYqNJm3ao8b413ow3hTp_2tmHP5vi4DQwKcC9JTX5PdJfIXUYlfa9XCHPxtM
 cYIbkzIdaPOMByN.zGE3yIC8FWcSpsx0Q3OUVCuUuvsB_xT.hBIElS1ub4S7NXYPNlVH62BiCn2D
 tui.q2gvNbPRagWHB8xJHHbrOM3dKtI1m1mLc24pHTWYNtcEsmW1Lrzhkaa85UwftU.oxOLhppRe
 9f0eK22HvcBKr8o4H.VIgPS3kwxfY7I3U1xesgOLu8ipX5KEid3Vxd1BVHzoBRUVebE2aHcKIwSz
 3gTqBtTcRtnQJ7fxfhriGrbM0t95lVvWjcunYL5n_DnMYP5pluqTDcSrQ6KJTZbLs3BXGGzx2QtR
 QdLtZlGrH_fXh5vXPuIN.I665Bw3DsPUFPgYoPTf83BLR0IWnNxsoFFcM_dvKIeQX27a7Q8ZKLGD
 XYehY7XzchILyb6MWgVlydkG9BxtIfuaNVO8jzrktryrUWQUEZFBb6ejzN4ojauBbl_ASlC2RKhT
 bQLvRoBPMcjUH_q_j6EAzla_kublFCf5T2.QLbi47Wu4paaAVBnlvuBret5UZc9Qua56U53FWDu0
 PtZZoowN6H_1zQdo2MyoOhuTacMLwa7hHrzrFTk4ys6YRy2X2RaSxjEpdpX2IkhhQdg25FMdX51g
 0PSDiDsPPOZE.DeY_zMZaw0rWqU0UGw68xhKuIHEICFrpquVlGrKuW74saS8iFPTp1pmQOJBEf8k
 zO0vcqPmoUzK_G5ZIG9Njn7ux22v.EVZEYk.5rsdIpFyLVxhgilgFI30LTz8WUWEVanFNvQl0XwE
 qn919jPuEd9qdn6HNae9cGBAb9NNmVJmA0KAY
X-Sonic-MF: <lesrhorer@att.net>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic315.consmr.mail.gq1.yahoo.com with HTTP; Wed, 19 May 2021 14:49:14 +0000
Received: by kubenode512.mail-prod1.omega.ne1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID e7fb73063b9e80318c4412ba2b99cc0a;
          Wed, 19 May 2021 14:49:10 +0000 (UTC)
Subject: Re: My superblocks have gone missing, can't reassemble raid5
To:     Linux RAID <linux-raid@vger.kernel.org>
References: <CA+o1gzBcQF_JeiC7Nv_zEBmJU2ypwQ_+RkbcZOOt0qOK1MkQww@mail.gmail.com>
From:   Leslie Rhorer <lesrhorer@att.net>
Message-ID: <c99e3bac-469a-0b48-31df-481754c477c7@att.net>
Date:   Wed, 19 May 2021 09:48:28 -0500
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CA+o1gzBcQF_JeiC7Nv_zEBmJU2ypwQ_+RkbcZOOt0qOK1MkQww@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Mailer: WebService/1.1.18291 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo Apache-HttpAsyncClient/4.1.4 (Java/16)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 5/16/2021 11:16 PM, Christopher Thomas wrote:
> Hi all,
> 
> I've updated my system & migrated my 3 raid5 component drives from the
> old to the new, but now can't reassemble the array - mdadm just
> doesn't recognize that these belong to an array at all.
> 
> The scenario:
> For many years, I've run a raid5 array on a virtual Linux server
> (Ubuntu 12.04) in VirtualBox on a Windows 10 host, with 3 2.7TB drives
> attached to the virt in "Raw Disk" mode, and assembled into an array.
> I recently upgraded to a completely different physical machine, but
> still running Windows 10 and VirtualBox.  I'm reasonably sure that the
> last time I shut it down, the array was clean.  Or at they very least,
> the drives had superblocks.  I plugged the old drives into it,
> migrated the virtual machine image to the new system, and attached
> them as raw disks, just as in the old system.  And they show up as
> /dev/sd[b-d], as before.  However, it's not recognized automatically
> as an array at boot, and manual attempts to assemble & start the array
> fail with 'no superblock'
> 
> The closest I've found online as a solution is to --create the array
> again using the same parameters.  But it sounds like if I don't get
> the drive order exactly the same, I'll lose the data.  Other solutions
> hint at playing with the partition table, but I'm equally nervous
> about that.  So I thought it was a good time to stop & ask for advice.
> 
> The details:
> 
> Here's my arrangement of disks now, where sd[bcd] are the components:
> 
> ==========
> chris@ursula:~$ lsblk
> NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
> sda      8:0    0 20.1G  0 disk
> ├─sda1   8:1    0 19.2G  0 part /
> ├─sda2   8:2    0    1K  0 part
> └─sda5   8:5    0  976M  0 part [SWAP]
> sdb      8:16   0  2.7T  0 disk
> └─sdb1   8:17   0  128M  0 part
> sdc      8:32   0  2.7T  0 disk
> └─sdc1   8:33   0  128M  0 part
> sdd      8:48   0  2.7T  0 disk
> └─sdd1   8:49   0  128M  0 part
> sr0     11:0    1 1024M  0 rom

	The first thing you need to do is copy those drives into safety media. 
  I know this means a new drive, but an 8T drive is not that expensive. 
  I would format the drive and mount it to some directory:

mkfs /dev/sdX
mkdir /Safety
mount /dev/sdX /Safety
cd /Safety
ddrescue /dev/sdb disk1 /Safety/disk1-map
ddrescue /dev/sdc disk2 /Safety/disk2-map
ddrescue /dev/sdd disk3 /Safety/disk3-map

	As mentioned earlier in this thread, you can create overlays of the 
original disks.  That, or you can make loops of the backup files. 
Actually, if it were me, I would create two sets of backups and work on 
the second set, but then I am hyper-anal about such things.  I don't 
just employ a belt and suspenders.  I use a belt, suspenders, large 
numbers of staples, super glue, and a braided steel strap welded in 
place.  Use whatever level of redundancy with which you feel 
comfortable, but I *DEFINITELY* do not recommend working with the 
original media.  Indeed, I do not recommend attempting to recover the 
original media, at all.  Once you have a solution identified, I would 
employ new drives, keeping the old as backups.  (Which rather begs the 
question, "Why don't you have backups of the data, so you could simply 
create an entirely new empty array and copy the data to the new array 
from the backup?")

	I would then create a loopfile from each backup file:

losetup -fP disk1
losetup -fP disk2
losetup -fP disk3

	Then I would try recreating the RAID based upon the earlier Examine report:

mdadm -C -f -n 3 -l 5 -e 1.2 -c 512 -p ls /dev/md99 /dev/loop2 
/dev/loop0 /dev/loop1

	You may notice some of the command switches are defaults.  Remember 
what I said about a belt and suspenders?  Personally, in such a case I 
would not rely on defaults.

	Now try running a check on the assembled array:
fsck /dev/md99

	If that fails, shutdown the array with

mdadm -S /dev/md99

	and then try creating the array with a different drive order.  There 
are only two other possible permutations of three disks.  If none of 
those work, you have some more serious problems.
