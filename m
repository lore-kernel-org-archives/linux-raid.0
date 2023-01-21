Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC0F3C38142
	for <linux-raid@archiver.kernel.org>; Sat, 21 Jan 2023 21:20:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbjAUVU2 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 21 Jan 2023 16:20:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbjAUVU1 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 21 Jan 2023 16:20:27 -0500
Received: from hermes.turmel.org (hermes.turmel.org [IPv6:2604:180:f1::1e9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F0CBB1
        for <linux-raid@vger.kernel.org>; Sat, 21 Jan 2023 13:20:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=turmel.org;
         s=a; h=In-Reply-To:From:References:To:Subject:MIME-Version:Date:Message-ID:
        Content-Type:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=SBKNd1BO+MGlXvrcUtvlyrIoW4YukuVdm6N7yB5ePqM=; b=QzCwXj+wQPieQUQk56/7mL+5/V
        fwJIY6I9dphCaRptFggdHx66bc+FwIRVQrX5XgRALw4lePKdhxSDPiq/O6RIuCTKd6Z9R2JsPB3j6
        4O3DprTdH6DXEWPGj/Wg4QebQ8t8sBaTCl7Z+M+FhupARmwFYMNFSHl1MvuFMrxtF2Ocu+15bNnOw
        ++KQ1pWpE0MsPjhAqm8VHrkf+9DSAXoWnVWLUZCXT289U752rU4xaJb14TiGz5wC+NY8ij0ANNgH5
        TVgHMmDW663mJWrf9nOdGQ/Vzl+wODBKvJKE44X3FzgwYIy/MH7qBwerNCLLqenS13cbPIX5FbPvb
        RLbv6EjQ==;
Received: from c-98-192-104-236.hsd1.ga.comcast.net ([98.192.104.236] helo=[192.168.19.197])
        by hermes.turmel.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <philip@turmel.org>)
        id 1pJLHg-0002EN-J8; Sat, 21 Jan 2023 21:20:20 +0000
Content-Type: multipart/mixed; boundary="------------ziTc7XZJXVOmsAaK3sbQ1MIP"
Message-ID: <e63fb57f-21e6-51b0-1fc1-f8af21175e80@turmel.org>
Date:   Sat, 21 Jan 2023 16:20:19 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: Transferring an existing system from non-RAID disks to RAID1
 disks in the same computer
To:     Wol <antlists@youngman.org.uk>,
        Pascal Hambourg <pascal@plouf.fr.eu.org>,
        H <agents@meddatainc.com>,
        Linux RAID Mailing List <linux-raid@vger.kernel.org>
References: <273d1fc9-853f-a8fa-bb47-2883ba217820@meddatainc.com>
 <3c124633-6b69-c97c-30f2-02f70141ac1a@plouf.fr.eu.org>
 <963bb7eb-7ce2-c887-ca5c-d0359290841b@turmel.org>
 <4224103d-17b4-0635-9bb4-7f81b896ad07@plouf.fr.eu.org>
 <d1a78f14-843a-e6f1-b909-67e091c5fa3f@youngman.org.uk>
Content-Language: en-US
From:   Phil Turmel <philip@turmel.org>
In-Reply-To: <d1a78f14-843a-e6f1-b909-67e091c5fa3f@youngman.org.uk>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

This is a multi-part message in MIME format.
--------------ziTc7XZJXVOmsAaK3sbQ1MIP
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Sigh,

On 1/20/23 15:26, Wol wrote:
> On 20/01/2023 19:27, Pascal Hambourg wrote:
>> Why in initramfs-tools ? The initramfs has nothing to do with the 
>> bootloader installation nor the EFI partition so there is no need to 
>> resync EFI partitions on initramfs update (unless GRUB menu entries or 
>> kernel and initramfs images are in the EFI partition, which is not a 
>> great idea IMO). IMO the right place would be a hook called after the 
>> system configuration manager or the GRUB package runs grub-install, if 
>> that exists.
> 
> I think you've just put your finger on it. Multiple EFI partitions is 
> outside the remit of linux, and having had two os's arguing over which 
> was the right EFI, I really don't think the system manager - be it yast, 
> yum, apt, whatever - is capable of even trying. With a simple 
> configuration you don't have mirrored EFI, some systems have one EFI per 
> OS, others have one EFI for several OSes, ...

Linux has efibootmgr, which certainly can manage multiple EFI partitions.

If using grub on multiple efi partions, you would use efibootmgr one 
time (after grub-install) to ensure all of your partitions were listed 
in the order you want them tried.  If one gets corrupted the BIOS will 
fall back to the next one.

{ This is the #1 reason to use EFI instead of MBR boot. }

If using EFI boot *without* GRUB, you want your actual bootable kernel 
*and* initramfs in place in all of your EFI partitions.

I use an initramfs hook for this on some of my production servers. 
Kernal install reliably installs an initramfs, too, so this hook is the 
right place for my use case.

> At the end of the day, it's down to the user, and if you can shove a 
> quick rsync in the initramfs or boot sequence to sync EFIs, then that's 
> probably the best place. Then it doesn't get missed ...

As noted, rsync on boot is too late.  rsync on kernel or initramfs 
install is best.

> Cheers,
> Wol

My script for direct booting (instead of grub) is attached.  Works with 
distro kernels that have EFI_STUB turned on.  (Ubuntu Server, in my case.)

Regards,

Phil
--------------ziTc7XZJXVOmsAaK3sbQ1MIP
Content-Type: text/plain; charset=UTF-8; name="99-direct-efi"
Content-Disposition: attachment; filename="99-direct-efi"
Content-Transfer-Encoding: base64

IyEgL2Jpbi9iYXNoCiMKIyBOb3JtYWxseSBpbnN0YWxsZWQgaW4gL2V0Yy9pbml0cmFtZnMv
cG9zdC11cGRhdGUuZC8gYW5kIG1hcmtlZAojIGV4ZWN1dGFibGUuCiMKIyBNb3ZlIG5ld2x5
IGluc3RhbGxlZCBpbml0cmFtZnMgdG8gL2Jvb3QvZWZpIGFuZCBlbnN1cmUgY29ycmVzcG9u
ZGluZwojIGtlcm5lbCBpcyBhbHNvIG1vdmVkLiAgSWYgdGhlIGtlcm5lbCBoYXMgdG8gYmUg
bW92ZWQsIGFsc28gdXBkYXRlCiMgdGhlIEVGSSBCb290IE1hbmFnZXIgd2l0aCB0aGUgbmV3
IGtlcm5lbCBhbmQgcHJ1bmUgb2xkIGtlcm5lbHMuCiMKIyBUaGlzIHJvdXRpbmUgaXMgY2Fs
bGVkIHRoZSBrZXJuZWwgdmVyc2lvbiBpbiBhcmd1bWVudCAjMSBhbmQgdGhlIAojIG5hbWUg
b2YgdGhlIGluaXRyYW1mcyBmaWxlIGluIGFyZ3VtZW50ICMyCgojIE9idGFpbiByb290IGZz
IGluZm8gZm9yIGJvb3QgY29tbWFuZCBsaW5lCnNvdXJjZSA8KGJsa2lkIC1vIGV4cG9ydCAk
KGRmIC8gfGdyZXAgLW8gJ14vZGV2L1teIF1cKycpKSAKaWYgdGVzdCAiJHtERVZOQU1FOjA6
MTJ9IiA9PSAiL2Rldi9tYXBwZXIvIiA7IHRoZW4KCWV4cG9ydCBSb290U3BlYz0iJERFVk5B
TUUiCmVsc2UKCWlmIHRlc3QgIiR7REVWTkFNRTowOjV9IiA9PSAiL2Rldi8iIDsgdGhlbgoJ
CXZnbHY9IiR7REVWTkFNRTo1fSIKCQl2Zz0iJHt2Z2x2JSUvKn0iCgkJbHY9IiR7dmdsdiMk
dmd9IgoJCWlmIHRlc3QgLW4gIiRsdiIgOyB0aGVuCgkJCWV4cG9ydCBSb290U3BlYz0iJERF
Vk5BTUUiCgkJZWxzZQoJCQlleHBvcnQgUm9vdFNwZWM9IlVVSUQ9JFVVSUQiCgkJZmkKCWVs
c2UKCQlleHBvcnQgUm9vdFNwZWM9IlVVSUQ9JFVVSUQiCglmaQpmaQoKIyBEZXN0aW5hdGlv
bnMgbXVzdCBoYXZlIGEgdHJhaWxpbmcgc2xhc2guCmZvciBERVNUIGluIC9ib290Qi8gL2Jv
b3RBLwpkbwoJIyBGaXJzdCwgY29weSB0aGUgdXBkYXRlZCBpbml0cmFtZnMuCgljcCAiJDIi
ICIkREVTVCIKCgkjIENvbnN0cnVjdCB0aGUgdGFyZ2V0IGtlcm5lbCBlZmkgZmlsZSBuYW1l
IGFuZCBjaGVjayBmb3IgZXhpc3RlbmNlCglleHBvcnQgS0Y9IiR7REVTVH12bWxpbnV6LSQx
LmVmaSIKCXRlc3QgLWYgIiRLRiIgJiYgY29udGludWUKCgkjIE5lZWQgdG8gY29weSBhbmQg
cmVnaXN0ZXIgdGhlIGtlcm5lbC4KCWVjaG8gIkNvcHlpbmcgJEtGIC4uLiIKCWNwICIvYm9v
dC92bWxpbnV6LSQxIiAiJEtGIgoKCSMgT2J0YWluIEVGSSBib290IGZzIGluZm8gZm9yIGJv
b3QgcGFydGl0aW9uIGluZm8gYW5kIGZpbGUgbG9jYXRpb25zCglzb3VyY2UgPChibGtpZCAt
byBleHBvcnQgJChkZiAiJERFU1QiIHxncmVwIC1vICdeL2Rldi9bXiBdXCsnKSkgCgoJQk9P
VD0iJChzZWQgLXIgLWUgJ3MvKC4rW14wLTldKShbMC05XSspL1wxOlwyLycgPDw8ICIkREVW
TkFNRSIpIgoJcmVhZCBkdW1teTEgTU9VTlRQVCBvdGhlciA8PDwgIiQoZ3JlcCAiXiRERVZO
QU1FICIgL3Byb2MvbW91bnRzKSIKCUVGSVJPT1Q9IiQoZWNobyAke0RFU1QjIyRNT1VOVFBU
fSB8c2VkICdzL1wvL1xcL2cnKSIKCgkjIFNldCB0aGUgbmV3IGJvb3QgcmVjb3JkCgllZmli
b290bWdyIC1xIC1jIC0tZGlzayAiJHtCT09UJSU6Kn0iIC0tcGFydCAiJHtCT09UIyMqOn0i
IFwKCQktLWxhYmVsICJFRkkgRGlyZWN0ICRERVNUICQxIiBcCgkJLS1sb2FkZXIgIiR7RUZJ
Uk9PVH12bWxpbnV6LSQxLmVmaSIgXAoJCS11ICJpbml0cmQ9JHtFRklST09UfSQoYmFzZW5h
bWUgIiQyIikgcm9vdD0ke1Jvb3RTcGVjfSIKCgllY2hvICJDb25maWd1cmVkIEVGSSBEaXJl
Y3QgJERFU1QgJDEgYXMgJEVGSVJPT1Qgb24gJEJPT1QiCgpkb25lCg==

--------------ziTc7XZJXVOmsAaK3sbQ1MIP--
