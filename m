Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7EF5C433FE
	for <linux-raid@archiver.kernel.org>; Sun,  6 Nov 2022 12:29:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbiKFM33 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 6 Nov 2022 07:29:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbiKFM32 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 6 Nov 2022 07:29:28 -0500
X-Greylist: delayed 12602 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 06 Nov 2022 04:29:26 PST
Received: from 15.mo561.mail-out.ovh.net (15.mo561.mail-out.ovh.net [87.98.150.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EC58E94
        for <linux-raid@vger.kernel.org>; Sun,  6 Nov 2022 04:29:26 -0800 (PST)
Received: from player690.ha.ovh.net (unknown [10.111.172.186])
        by mo561.mail-out.ovh.net (Postfix) with ESMTP id 7BB2F23D59
        for <linux-raid@vger.kernel.org>; Sun,  6 Nov 2022 08:51:05 +0000 (UTC)
Received: from rechte.fr (82-65-133-131.subs.proxad.net [82.65.133.131])
        (Authenticated sender: marc4@rechte.fr)
        by player690.ha.ovh.net (Postfix) with ESMTPSA id 0A4DC30517555;
        Sun,  6 Nov 2022 08:51:03 +0000 (UTC)
Authentication-Results: garm.ovh; auth=pass (GARM-110S0047c7b9ebb-d9af-473c-8235-9a47c11578d9,
                    6D2D3BFE2A90E32C99406D564E491920D64DA061) smtp.auth=marc4@rechte.fr
X-OVh-ClientIp: 82.65.133.131
Message-ID: <3466aa97-597e-0c8e-42df-eaf2e947348f@rechte.fr>
Date:   Sun, 6 Nov 2022 09:51:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: mdadm udev rule does not start mdmonitor systemd unit.
To:     Xiao Ni <xni@redhat.com>
Cc:     linux-raid@vger.kernel.org
References: <984d4620-e53f-0d1f-c61a-0485ea79e3f6@rechte.fr>
 <CALTww2-dKxDzTo6svQm+8wyo5UiY6v+amjoKjbhHQ4dVvDO67w@mail.gmail.com>
Content-Language: en-US
From:   =?UTF-8?Q?Marc_Recht=c3=a9?= <marc4@rechte.fr>
In-Reply-To: <CALTww2-dKxDzTo6svQm+8wyo5UiY6v+amjoKjbhHQ4dVvDO67w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 8464796975422971066
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvgedrvdehgdduudejucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepkfffgggfuffvvehfhfgjtgfgsehtkeertddtfeejnecuhfhrohhmpeforghrtgcutfgvtghhthoruceomhgrrhgtgeesrhgvtghhthgvrdhfrheqnecuggftrfgrthhtvghrnhepteevfeetfeelgfegieehtdfffefhkeefieffjefgkedtfeduteduudfgkeegkedunecukfhppeduvdejrddtrddtrddupdekvddrieehrddufeefrddufedunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehinhgvthepuddvjedrtddrtddruddpmhgrihhlfhhrohhmpeeomhgrrhgtgeesrhgvtghhthgvrdhfrheqpdhnsggprhgtphhtthhopedupdhrtghpthhtoheplhhinhhugidqrhgrihgusehvghgvrhdrkhgvrhhnvghlrdhorhhgpdfovfetjfhoshhtpehmohehiedupdhmohguvgepshhmthhpohhuth
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Le 03/11/2022 à 03:54, Xiao Ni a écrit :
> On Tue, Nov 1, 2022 at 8:27 PM Marc Rechté <marc4@rechte.fr> wrote:
>> Hello,
>>
>> I have a udev rule and a md127 device with the properties as following.
>>
>> The mdmonitor service is not started (no trace in systemd journal).
>> However I can manually start the service.
>>
>> I just noticed that SYSTEMD_READY porperty is 0 which could explain this
>> behaviour (according to man systemd.device) ?
> Hi Marc
>
> For raid device, SYSTEMD_READY will be 1 when the change event happens.
> And for lvm volume, SYSTEMD_READY will be 1 when the add event happens.
> So you need to notice about his in your udev rule.
>
>> I don't know how to further debug.
> You can add systemd.log_level=debug udev.log-priority=debug to your boot conf
> file. For example,
> /boot/loader/entries/xxx-4.18.0-416.el8.x86_64.conf. My environment
> is rhel. Maybe it's different on your system.
>
> Then you can add some printf logs into your udev rule. I did in this
> way, something
> like this:
>
> ENV{SYSTEMD_READY}=="0", GOTO="test_end"
> SUBSYSTEM=="block", ACTION=="add", RUN{program}+="/usr/bin/echo
> mdadm-test-add-SYSTEMD_READY"
> SUBSYSTEM=="block", ACTION=="change", RUN{program}+="/usr/bin/echo
> mdadm-test-change-SYSTEMD_READY"
>
> You can check the logs by journalctl command. So you can know which
> rule runs in your udev rule.
>
> Regards
> Xiao
>> Thanks
>>
>> # udevadm info --query=property --name=/dev/md127
>>
>> DEVPATH=/devices/virtual/block/md127
>> DEVNAME=/dev/md127
>> DEVTYPE=disk
>> DISKSEQ=6
>> MAJOR=9
>> MINOR=127
>> SUBSYSTEM=block
>> USEC_INITIALIZED=5129215
>> ID_IGNORE_DISKSEQ=1
>> MD_LEVEL=raid1
>> MD_DEVICES=2
>> MD_METADATA=1.2
>> MD_UUID=800ee577:652e6fdc:79f6768e:dea2f7ea
>> MD_DEVNAME=SysRAID1Array1
>> MD_NAME=linux2:SysRAID1Array1
>> ID_FS_UUID=x94VGG-7hfP-rn1c-MR53-q6to-QPZR-73eAdq
>> ID_FS_UUID_ENC=x94VGG-7hfP-rn1c-MR53-q6to-QPZR-73eAdq
>> ID_FS_VERSION=LVM2 001
>> ID_FS_TYPE=LVM2_member
>> ID_FS_USAGE=raid
>> SYSTEMD_WANTS=mdmonitor.service
>> SYSTEMD_READY=0
>> UDISKS_MD_LEVEL=raid1
>> UDISKS_MD_DEVICES=2
>> UDISKS_MD_METADATA=1.2
>> UDISKS_MD_UUID=800ee577:652e6fdc:79f6768e:dea2f7ea
>> UDISKS_MD_DEVNAME=SysRAID1Array1
>> UDISKS_MD_NAME=linux2:SysRAID1Array1
>> UDISKS_MD_DEVICE_dev_nvme0n1p2_ROLE=0
>> UDISKS_MD_DEVICE_dev_nvme0n1p2_DEV=/dev/nvme0n1p2
>> UDISKS_MD_DEVICE_dev_nvme1n1p2_ROLE=1
>> UDISKS_MD_DEVICE_dev_nvme1n1p2_DEV=/dev/nvme1n1p2
>> DEVLINKS=/dev/md/SysRAID1Array1
>> /dev/disk/by-id/md-name-linux2:SysRAID1Array1
>> /dev/disk/by-id/lvm-pv-uuid-x94VGG-7hfP-rn1c-MR53-q6to-QPZR-73eAdq
>> /dev/disk/by-id/md-uuid-800ee577:652e6fdc:79f6768e:dea2f7ea
>> TAGS=:systemd:
>> CURRENT_TAGS=:systemd:
>>
>> # cat /usr/lib/udev/rules.d/63-md-raid-arrays.rules
>> # do not edit this file, it will be overwritten on update
>>
>> SUBSYSTEM!="block", GOTO="md_end"
>>
>> # handle md arrays
>> ACTION!="add|change", GOTO="md_end"
>> KERNEL!="md*", GOTO="md_end"
>>
>> # partitions have no md/{array_state,metadata_version}, but should not
>> # for that reason be ignored.
>> ENV{DEVTYPE}=="partition", GOTO="md_ignore_state"
>>
>> # container devices have a metadata version of e.g. 'external:ddf' and
>> # never leave state 'inactive'
>> ATTR{md/metadata_version}=="external:[A-Za-z]*",
>> ATTR{md/array_state}=="inactive", GOTO="md_ignore_state"
>> TEST!="md/array_state", ENV{SYSTEMD_READY}="0", GOTO="md_end"
>> ATTR{md/array_state}=="clear*|inactive", ENV{SYSTEMD_READY}="0",
>> GOTO="md_end"
>> ATTR{md/sync_action}=="reshape", ENV{RESHAPE_ACTIVE}="yes"
>> LABEL="md_ignore_state"
>>
>> IMPORT{program}="/usr/bin/mdadm --detail --no-devices --export $devnode"
>> ENV{DEVTYPE}=="disk", ENV{MD_NAME}=="?*",
>> SYMLINK+="disk/by-id/md-name-$env{MD_NAME}",
>> OPTIONS+="string_escape=replace"
>> ENV{DEVTYPE}=="disk", ENV{MD_UUID}=="?*",
>> SYMLINK+="disk/by-id/md-uuid-$env{MD_UUID}"
>> ENV{DEVTYPE}=="disk", ENV{MD_DEVNAME}=="?*", SYMLINK+="md/$env{MD_DEVNAME}"
>> ENV{DEVTYPE}=="partition", ENV{MD_NAME}=="?*",
>> SYMLINK+="disk/by-id/md-name-$env{MD_NAME}-part%n",
>> OPTIONS+="string_escape=replace"
>> ENV{DEVTYPE}=="partition", ENV{MD_UUID}=="?*",
>> SYMLINK+="disk/by-id/md-uuid-$env{MD_UUID}-part%n"
>> ENV{DEVTYPE}=="partition", ENV{MD_DEVNAME}=="*[^0-9]",
>> SYMLINK+="md/$env{MD_DEVNAME}%n"
>> ENV{DEVTYPE}=="partition", ENV{MD_DEVNAME}=="*[0-9]",
>> SYMLINK+="md/$env{MD_DEVNAME}p%n"
>>
>> IMPORT{builtin}="blkid"
>> OPTIONS+="link_priority=100"
>> OPTIONS+="watch"
>> ENV{ID_FS_USAGE}=="filesystem|other|crypto", ENV{ID_FS_UUID_ENC}=="?*",
>> SYMLINK+="disk/by-uuid/$env{ID_FS_UUID_ENC}"
>> ENV{ID_FS_USAGE}=="filesystem|other", ENV{ID_PART_ENTRY_UUID}=="?*",
>> SYMLINK+="disk/by-partuuid/$env{ID_PART_ENTRY_UUID}"
>> ENV{ID_FS_USAGE}=="filesystem|other", ENV{ID_FS_LABEL_ENC}=="?*",
>> SYMLINK+="disk/by-label/$env{ID_FS_LABEL_ENC}"
>>
>> ENV{MD_LEVEL}=="raid[1-9]*", ENV{SYSTEMD_WANTS}+="mdmonitor.service"
>>
>> # Tell systemd to run mdmon for our container, if we need it.
>> ENV{MD_LEVEL}=="raid[1-9]*", ENV{MD_CONTAINER}=="?*",
>> PROGRAM="/usr/bin/readlink $env{MD_CONTAINER}", ENV{MD_MON_THIS}="%c"
>> ENV{MD_MON_THIS}=="?*", PROGRAM="/usr/bin/basename $env{MD_MON_THIS}",
>> ENV{SYSTEMD_WANTS}+="mdmon@%c.service"
>> ENV{RESHAPE_ACTIVE}=="yes", PROGRAM="/usr/bin/basename
>> $env{MD_MON_THIS}", ENV{SYSTEMD_WANTS}+="mdadm-grow-continue@%c.service"
>>
>> LABEL="md_end"
>>
>>
Hello Xiao,

Thanks for the tips.

It appears that SYSTEMD_READY == 1 when entering the add/change event, 
but it seems it is reset to 0 while processing the rules.

Following is modified rule with debug info. Relevant journal entries:

md127: '/usr/bin/echo mdadm-test-add-SYSTEMD_READY'(out) 
'mdadm-test-add-SYSTEMD_READY'

...

md127: '/usr/bin/udevadm info --query=property --name=/dev/md127'(out) 
'SYSTEMD_READY=0'


$ cat 63-md-raid-arrays.rules

# do not edit this file, it will be overwritten on update

SUBSYSTEM!="block", GOTO="md_end"

# handle md arrays
ACTION!="add|change", GOTO="md_end"
KERNEL!="md*", GOTO="md_end"

ENV{SYSTEMD_READY}=="0", GOTO="md_test"
RUN{program}+="/usr/bin/echo mdadm-test-add-SYSTEMD_READY"
LABEL="md_test"


# partitions have no md/{array_state,metadata_version}, but should not
# for that reason be ignored.
ENV{DEVTYPE}=="partition", GOTO="md_ignore_state"

# container devices have a metadata version of e.g. 'external:ddf' and
# never leave state 'inactive'
ATTR{md/metadata_version}=="external:[A-Za-z]*", 
ATTR{md/array_state}=="inactive", GOTO="md_ignore_state"
TEST!="md/array_state", ENV{SYSTEMD_READY}="0", GOTO="md_end"
ATTR{md/array_state}=="clear*|inactive", ENV{SYSTEMD_READY}="0", 
GOTO="md_end"
ATTR{md/sync_action}=="reshape", ENV{RESHAPE_ACTIVE}="yes"
LABEL="md_ignore_state"

IMPORT{program}="/usr/bin/mdadm --detail --no-devices --export $devnode"
ENV{DEVTYPE}=="disk", ENV{MD_NAME}=="?*", 
SYMLINK+="disk/by-id/md-name-$env{MD_NAME}", 
OPTIONS+="string_escape=replace"
ENV{DEVTYPE}=="disk", ENV{MD_UUID}=="?*", 
SYMLINK+="disk/by-id/md-uuid-$env{MD_UUID}"
ENV{DEVTYPE}=="disk", ENV{MD_DEVNAME}=="?*", TAG+="systemd", 
SYMLINK+="md/$env{MD_DEVNAME}"
ENV{DEVTYPE}=="partition", ENV{MD_NAME}=="?*", 
SYMLINK+="disk/by-id/md-name-$env{MD_NAME}-part%n", 
OPTIONS+="string_escape=replace"
ENV{DEVTYPE}=="partition", ENV{MD_UUID}=="?*", 
SYMLINK+="disk/by-id/md-uuid-$env{MD_UUID}-part%n"
ENV{DEVTYPE}=="partition", ENV{MD_DEVNAME}=="*[^0-9]", 
SYMLINK+="md/$env{MD_DEVNAME}%n"
ENV{DEVTYPE}=="partition", ENV{MD_DEVNAME}=="*[0-9]", 
SYMLINK+="md/$env{MD_DEVNAME}p%n"


IMPORT{builtin}="blkid"
OPTIONS+="link_priority=100"
OPTIONS+="watch"
ENV{ID_FS_USAGE}=="filesystem|other|crypto", ENV{ID_FS_UUID_ENC}=="?*", 
SYMLINK+="disk/by-uuid/$env{ID_FS_UUID_ENC}"
ENV{ID_FS_USAGE}=="filesystem|other", ENV{ID_PART_ENTRY_UUID}=="?*", 
SYMLINK+="disk/by-partuuid/$env{ID_PART_ENTRY_UUID}"
ENV{ID_FS_USAGE}=="filesystem|other", ENV{ID_FS_LABEL_ENC}=="?*", 
SYMLINK+="disk/by-label/$env{ID_FS_LABEL_ENC}"

ENV{MD_LEVEL}=="raid[1-9]*", ENV{SYSTEMD_WANTS}+="mdmonitor.service"
ENV{MD_LEVEL}=="raid[1-9]*", ENV{SYSTEMD_WANTS}+="hello.service"

#RUN{program}+="/usr/bin/echo SYSTEMD_READY = $env(SYSTEMD_READY)"
RUN{program}+="/usr/bin/udevadm info --query=property --name=/dev/md127"

# Tell systemd to run mdmon for our container, if we need it.
ENV{MD_LEVEL}=="raid[1-9]*", ENV{MD_CONTAINER}=="?*", 
PROGRAM="/usr/bin/readlink $env{MD_CONTAINER}", ENV{MD_MON_THIS}="%c"
ENV{MD_MON_THIS}=="?*", PROGRAM="/usr/bin/basename $env{MD_MON_THIS}", 
ENV{SYSTEMD_WANTS}+="mdmon@%c.service"
ENV{RESHAPE_ACTIVE}=="yes", PROGRAM="/usr/bin/basename 
$env{MD_MON_THIS}", ENV{SYSTEMD_WANTS}+="mdadm-grow-continue@%c.service"

LABEL="md_end"



