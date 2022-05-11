Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D918C433F5
	for <linux-raid@archiver.kernel.org>; Wed, 11 May 2022 05:39:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241912AbiEKFjh (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 11 May 2022 01:39:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237985AbiEKFjf (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 11 May 2022 01:39:35 -0400
Received: from postoffice.wmawater.com.au (postoffice.wmawater.com.au [61.69.178.123])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id CA32D65D0D
        for <linux-raid@vger.kernel.org>; Tue, 10 May 2022 22:39:32 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by postoffice.wmawater.com.au (Postfix) with ESMTP id 8A72319F372;
        Wed, 11 May 2022 15:39:31 +1000 (AEST)
Authentication-Results: postoffice.wmawater.com.au (amavisd-new);
        dkim=pass (1024-bit key) header.d=wmawater.com.au
Received: from postoffice.wmawater.com.au ([127.0.0.1])
        by localhost (postoffice.wmawater.com.au [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id IqdS-bfBKFzW; Wed, 11 May 2022 15:39:31 +1000 (AEST)
Received: from localhost (localhost [127.0.0.1])
        by postoffice.wmawater.com.au (Postfix) with ESMTP id 5AD7D19F373;
        Wed, 11 May 2022 15:39:31 +1000 (AEST)
DKIM-Filter: OpenDKIM Filter v2.10.3 postoffice.wmawater.com.au 5AD7D19F373
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wmawater.com.au;
        s=1D92CC64-C1F9-11E4-96FC-2C1EC0F5F97B; t=1652247571;
        bh=QmC/s2++QI26oT10PT3SQ9uvfsJjMwSTxrivPnhE8p4=;
        h=From:To:Date:Message-ID:MIME-Version;
        b=aohzAAs+42rt0wysImuqtNRcenGDlOb0qYosoQJrMKQmvjw0HvnZTc3EJXgQeacH5
         sPrPO6ACGdnRlQHQaW0yRRzSlGZQPMqsC1p/vavtA3zcQyGilXv5p932hTvmsJuoUy
         mUnAO99oED+yZ9kazXqn9xnRPzw+7V5dkNzJjvFQ=
X-Virus-Scanned: amavisd-new at wmawater.com.au
Received: from postoffice.wmawater.com.au ([127.0.0.1])
        by localhost (postoffice.wmawater.com.au [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id KGbBsyPBBNFt; Wed, 11 May 2022 15:39:31 +1000 (AEST)
Received: from postoffice.wmawater.com.au (postoffice.wmawater.com.au [61.69.178.123])
        by postoffice.wmawater.com.au (Postfix) with ESMTP id 2EA1919F372;
        Wed, 11 May 2022 15:39:31 +1000 (AEST)
Reply-To: "Bob Brand" <brand@wmawater.com.au>
From:   Bob Brand <brand@wmawater.com.au>
To:     "Roger Heflin" <rogerheflin@gmail.com>,
        "Wols Lists" <antlists@youngman.org.uk>
Cc:     "Linux RAID" <linux-raid@vger.kernel.org>,
        "Phil Turmel" <philip@turmel.org>, "NeilBrown" <neilb@suse.com>
References: <00ae01d862de$1d336980$579a3c80$@wmawater.com.au> <f4e9c9f8-590d-49a4-39da-e31d81258ff3@youngman.org.uk> <00cf01d86327$9c5dd8a0$d51989e0$@wmawater.com.au> <3f84648b-29db-0819-e3ba-af52435a2aab@youngman.org.uk> <00d101d86329$a2a57130$e7f05390$@wmawater.com.au> <00d601d8632f$ac1f1300$045d3900$@wmawater.com.au> <00e401d86333$e75d8f60$b618ae20$@wmawater.com.au> <00eb01d86339$18cc0860$4a641920$@wmawater.com.au> <5931f716-008d-399b-2ea8-acbbc9c8d239@youngman.org.uk> <CAAMCDecTb69YY+jGzq9HVqx4xZmdVGiRa54BD55Amcz5yaZo1Q@mail.gmail.com>
In-Reply-To: <CAAMCDecTb69YY+jGzq9HVqx4xZmdVGiRa54BD55Amcz5yaZo1Q@mail.gmail.com>
Subject: RE: Failed adadm RAID array after aborted Grown operation
Thread-Topic: Failed adadm RAID array after aborted Grown operation
Date:   Wed, 11 May 2022 15:39:30 +1000 (AEST)
Message-ID: <019701d864f9$7c87ab90$759702b0$@wmawater.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
X-Mailer: Microsoft Outlook 16.0
X-Mailer: Zimbra 8.8.15_GA_3894 (Zimbra-ZCO/9.0.0.1903 (10.0.19044  en-AU) P4764 T66f8 R6477)
Thread-Index: AQK0Ylmfkg1g1mZGz7yxBx3O0op7hADpZ3mFAYMzo9kBZlg9dAGZ0oLFAdWidsoCQWnqlQI7z0N+AMQVcYoBrcfnAarvmjsw
Content-Language: en-au
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Thanks Roger.

My apologies for not replying earlier.  By the time I read this I already=
=20
had a reshape underway to reduce the size of the array back to the origin=
al=20
30 disks.  So far it seems to be progressing OK although the ETA is aroun=
d=20
10 days which is why I didn=E2=80=99t respond sooner =E2=80=93 I=E2=80=99=
ve been bury dealing with=20
the fallout from this.

Do I understand that you would recommend upgrading our installation of Li=
nux=20
once the repair is complete or are advising downloading and compiling a n=
ew=20
kernel as part of the repair?  Or are you suggesting that it was the fact=
=20
that we=E2=80=99re on such an old version of CentOS that caused this mess=
?  I ask=20
because once this is repaired (assuming it does complete successfully), I=
=20
would like to extend the array to the full 45 drives of which this server=
 is=20
capable

Thanks,
Bob

From: Roger Heflin <rogerheflin@gmail.com>
Sent: Monday, 9 May 2022 9:05 PM
To: Wols Lists <antlists@youngman.org.uk>
Cc: Bob Brand <brand@wmawater.com.au>; Linux RAID=20
<linux-raid@vger.kernel.org>; Phil Turmel <philip@turmel.org>; NeilBrown=20
<neilb@suse.com>
Subject: Re: Failed adadm RAID array after aborted Grown operation

The short term easiest way for a new kernel might be this.

Download a Fedora 35 livecd and boot from it.  It will allow you to turn =
on=20
the raid and/or reshape the raid and/or abort the reshape using the fedor=
a=20
35 kernel and mdadm tools.    Though all of this will need to be done=20
manually from either the gui and/or command line, so it will be somewhat =
of=20
a pain.

The other choice is to download/compile/install a current http://kernel.o=
rg=20
kernel.  This takes some time (you have to install compiler/header rpms),=
=20
and follow this=20
(https://docs.rockylinux.org/guides/custom-linux-kernel/)--rockylinux so =
a=20
redhat clone list of instructions.  How long it takes will depend on the=20
number of cpus your machine has and the value after the -j<cpustouse>.=20
The biggest issue with this will likely be dealing with compile errors fo=
r=20
missing dependencies you get for this or that tool and/or devel package=20
being missing.   And then you would still need to download the newest mda=
dm=20
and compile and install it.   These steps will take longer, but doing thi=
s=20
will get your system on a new kernel and new tools, and typically once yo=
u=20
know how to do this, this process of compiling/installing a kernel has fo=
r=20
the most part not changed in a long time.  And I have been doing this on =
and=20
off for 20+ years and newer kernel on older userspace is widely used by a=
=20
lot of the kernel developers so is generally well testing and in my=20
experience just works to get you on a new kernel with minimal trouble.



On Mon, May 9, 2022 at 5:24 AM Wols Lists <mailto:antlists@youngman.org.u=
k>=20
wrote:
On 09/05/2022 01:09, Bob Brand wrote:
> Hi Wol,
>
> My apologies for continually bothering you but I have a couple of=20
> questions:

Did you read the links I sent you?
>
> 1. How do I overcome the error message "mount: /dev/md125: can't read
> superblock."  Do it use fsck?
>
> 2. The removed disk is showing as "   -   0   0   30   removed". Is it=20
> safe
> to use "mdadm /dev/md2 -r detached" or "mdadm /dev/md2 -r failed" to
> overcome this?

I don't know :-( This is getting a bit out of my depth. But I'm
SERIOUSLY concerned you're still futzing about with CentOS 7!!!

Why didn't you download CentOS 8.5? Why didn't you download RHEL 8.5, or
the latest Fedora? Why didn't you download SUSE SLES 15?

Any and all CentOS 7 will come with either an out-of-date mdadm, or a
Frankenkernel. NEITHER are a good idea.

Go back to the links I gave you, download and run lsdrv, and post the
output here. Hopefully somebody will tell you the next steps. I will do
my best.
>
> Thank you!
>
Cheers,
Wol
>
> -----Original Message-----
> From: Bob Brand <mailto:brand@wmawater.com.au>
> Sent: Monday, 9 May 2022 9:33 AM
> To: Bob Brand <mailto:brand@wmawater.com.au>; Wol=20
> <mailto:antlists@youngman.org.uk>;
> mailto:linux-raid@vger.kernel.org
> Cc: Phil Turmel <mailto:philip@turmel.org>
> Subject: RE: Failed adadm RAID array after aborted Grown operation
>
> I just tried it again with the --invalid_backup switch and it's now=20
> showing
> the State as "clean, degraded".and it's showing all the disks except fo=
r=20
> the
> suspect one that I removed.
>
> I'm unable to mount it and see the contents. I get the error "mount:
> /dev/md125: can't read superblock."
>
> Is there more that I need to do?
>
> Thanks
>
>
> -----Original Message-----
> From: Bob Brand <mailto:brand@wmawater.com.au>
> Sent: Monday, 9 May 2022 9:02 AM
> To: Bob Brand <mailto:brand@wmawater.com.au>; Wol=20
> <mailto:antlists@youngman.org.uk>;
> mailto:linux-raid@vger.kernel.org
> Cc: Phil Turmel <mailto:philip@turmel.org>
> Subject: RE: Failed adadm RAID array after aborted Grown operation
>
> Hi Wol,
>
> I've booted to the installation media and I've run the following comman=
d:
>
> mdadm
> /dev/md125 --assemble --update=3Drevert-reshape --backup-file=3D/mnt/sy=
simage/grow_md125.bak
>   --verbose --uuid=3D f9b65f55:5f257add:1140ccc0:46ca6c19
> /dev/md125mdadm --assemble --update=3Drevert-reshape --backup-file=3D/g=
row_md125.bak
>    --verbose --uuid=3Df9b65f55:5f257add:1140ccc0:46ca6c19
>
> But I'm still getting the error:
>
> mdadm: /dev/md125 has an active reshape - checking if critical section=20
> needs
> to be restored
> mdadm: No backup metadata on /mnt/sysimage/grow_md125.back
> mdadm: Failed to find backup of critical section
> mdadm: Failed to restore critical section for reshape, sorry.
>
>
> Should I try the --invalid_backup switch or --force?
>
> Thanks,
> Bob
>
>
> -----Original Message-----
> From: Bob Brand <mailto:brand@wmawater.com.au>
> Sent: Monday, 9 May 2022 8:19 AM
> To: Wol <mailto:antlists@youngman.org.uk>;=20
> mailto:linux-raid@vger.kernel.org
> Cc: Phil Turmel <mailto:philip@turmel.org>
> Subject: RE: Failed adadm RAID array after aborted Grown operation
>
> OK.  I've downloaded a Centos 7 - 2009 ISO from http://centos.org - tha=
t=20
> seems to
> be the most recent they have.
>
>
> -----Original Message-----
> From: Wol <mailto:antlists@youngman.org.uk>
> Sent: Monday, 9 May 2022 8:16 AM
> To: Bob Brand <mailto:brand@wmawater.com.au>;=20
> mailto:linux-raid@vger.kernel.org
> Cc: Phil Turmel <mailto:philip@turmel.org>
> Subject: Re: Failed adadm RAID array after aborted Grown operation
>
> How old is CentOS 7? With that kernel I guess it's quite old?
>
> Try and get a CentOS 8.5 disk. At the end of the day, the version of li=
nux
> doesn't matter. What you need is an up-to-date rescue disk.
> Distro/whatever is unimportant - what IS important is that you are usin=
g=20
> the
> latest mdadm, and a kernel that matches.
>
> The problem you have sounds like a long-standing but now-fixed bug. An
> original CentOS disk might be okay (with matched kernel and mdadm), but
> almost certainly has what I consider to be a "dodgy" version of mdadm.
>
> If you can afford the downtime, after you've reverted the reshape, I'd =
try
> starting it again with the rescue disk. It'll probably run fine. Let it
> complete and then your old CentOS 7 will be fine with it.
>
> Cheers,
> Wol
>
> On 08/05/2022 23:04, Bob Brand wrote:
>> Thank Wol.
>>
>> Should I use a CentOS 7 disk or a CentOS disk?
>>
>> Thanks
>>
>> -----Original Message-----
>> From: Wols Lists <mailto:antlists@youngman.org.uk>
>> Sent: Monday, 9 May 2022 1:32 AM
>> To: Bob Brand <mailto:brand@wmawater.com.au>;=20
>> mailto:linux-raid@vger.kernel.org
>> Cc: Phil Turmel <mailto:philip@turmel.org>
>> Subject: Re: Failed adadm RAID array after aborted Grown operation
>>
>> On 08/05/2022 14:18, Bob Brand wrote:
>>> If you=E2=80=99ve stuck with me and read all this way, thank you and =
I hope
>>> you can help me.
>>
>> https://raid.wiki.kernel.org/index.php/Linux_Raid
>>
>> Especially
>> https://raid.wiki.kernel.org/index.php/Linux_Raid#When_Things_Go_Wrogn
>>
>> What you need to do is revert the reshape. I know what may have
>> happened, and what bothers me is your kernel version, 3.10.
>>
>> The first thing to try is to boot from up-to-date rescue media and see
>> if an mdadm --revert works from there. If it does, your Centos should
>> then bring everything back no problem.
>>
>> (You've currently got what I call a Frankensetup, a very old kernel, a
>> pretty new mdadm, and a whole bunch of patches that does who knows wha=
t.
>> You really need a matching kernel and mdadm, and your frankenkernel
>> won't match anything ...)
>>
>> Let us know how that goes ...
>>
>> Cheers,
>> Wol
>>
>>
>>
>> CAUTION!!! This E-mail originated from outside of WMA Water. Do not
>> click links or open attachments unless you recognize the sender and
>> know the content is safe.
>>
>>
>
>
>
> CAUTION!!! This E-mail originated from outside of WMA Water. Do not cli=
ck
> links or open attachments unless you recognize the sender and know the
> content is safe.
>
>
>
