Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1A66C433DB
	for <linux-raid@archiver.kernel.org>; Sun,  7 Feb 2021 03:37:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89F8864E8A
	for <linux-raid@archiver.kernel.org>; Sun,  7 Feb 2021 03:37:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbhBGDhB (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 6 Feb 2021 22:37:01 -0500
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:32698 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229581AbhBGDg6 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 6 Feb 2021 22:36:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1612668949;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZkvZpdi2JBNGbJDHtBqLof7/WjJM7L95oymJZK9TQqk=;
        b=BXOUsD6owfkSEW26JvcsUqluO3p/8jIVUdjK6H+YMNLUB2gnoW0dpqWrEgEt+LT+Y7H1kV
        auixHtyi1GE6fTNqOAd2+6ohx59mSQ5QDzpVpqT6A55oM8GZoSX1nODkpoLfdYgA45FZ5Q
        RWhSuVRo0iuz02S19LKHPIOWXWbRHKE=
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
 (mail-db3eur04lp2055.outbound.protection.outlook.com [104.47.12.55]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-26-HkGWreLTML21mPXXD4kZew-1; Sun, 07 Feb 2021 04:35:48 +0100
X-MC-Unique: HkGWreLTML21mPXXD4kZew-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a2pUompdGDVeg3vjEa4SMNpGHcMfWXkUxecUrasqX+Wn0YOhDWrk6Egf/YSY/u3oxBDZBub5WbDi2401gf4FLQE4nc3AWdGi3XcnMFUHKfX5K09sV1mDrQQ2q46c6mtS0C+tKHQNHNOsQa96bx7RTF6GWQwZ60Hhsdr4F0ow2g1m5Z/3g/pExG0w3010xM8pKLiU+YzwvfGo04XeMybmxdjtEz4lCHbU8/OkrfszXZrHehEvylglN7Oeq8b/gbRHN0E5xpjxfBaolHgvo7Jim+0ZBZEVhGszADRXBQlqapNYrcJ67xvv5MWwQEYaPt7kpskYLJMwL+y/EaraooU5lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TrfgRj/QkENFTTMjpoPI3hmfHcxCKgcVTbIQ7JWfXYs=;
 b=GKH04HlNU2hw55t359pf/PJpzs799x3VhtQJtnBTrlmQSNHbs7fxUkq2iT9thOI5U/yH9ZTGZvI3Y0EECPNGawf0/YdLkIFZzps6I5qdBauNUjF3XdVdvm6GcvOcaEmQZ7bJ/WhX+6nu9OHuyBkB2FM2e9BXf/Td9gcCgeaiK6LCZVk4KscUMhq4Gok7OqN/nL+n4q/noo3FK1+DCq3MOo5XVSdC7dKWbTEULBTgGgVx4gnrMM61aCn3rtPMaSA9yncJOk42G4WZd8jk9V/s/OhplmSdrTYj3lM7fCJ46k682KKadSL6GoXHmQhcsFbbZNQ5eQR2gF9t9ALnduYIMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=suse.com;
Received: from AM0PR04MB6529.eurprd04.prod.outlook.com (2603:10a6:208:16f::21)
 by AM0PR04MB6948.eurprd04.prod.outlook.com (2603:10a6:208:187::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19; Sun, 7 Feb
 2021 03:35:46 +0000
Received: from AM0PR04MB6529.eurprd04.prod.outlook.com
 ([fe80::1d6e:70d1:7189:f2e4]) by AM0PR04MB6529.eurprd04.prod.outlook.com
 ([fe80::1d6e:70d1:7189:f2e4%7]) with mapi id 15.20.3825.027; Sun, 7 Feb 2021
 03:35:45 +0000
Subject: Re: [RFC PATCH] super-intel: correctly recognize NVMe device during
 assemble
To:     "Tkaczyk, Mariusz" <mariusz.tkaczyk@linux.intel.com>,
        jes@trained-monkey.org
CC:     linux-raid@vger.kernel.org, david.chang@hpe.com,
        "Shchirskyi, Oleksandr" <oleksandr.shchirskyi@intel.com>
References: <20210205071133.11139-1-lidong.zhong@suse.com>
 <f07a286d-e56e-7b47-86a3-5677893876d6@linux.intel.com>
From:   Zhong Lidong <lidong.zhong@suse.com>
Message-ID: <b399f065-387e-6d5b-ea26-f411edd49edb@suse.com>
Date:   Sun, 7 Feb 2021 11:35:38 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
In-Reply-To: <f07a286d-e56e-7b47-86a3-5677893876d6@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [112.232.229.111]
X-ClientProxiedBy: AM0PR05CA0085.eurprd05.prod.outlook.com
 (2603:10a6:208:136::25) To AM0PR04MB6529.eurprd04.prod.outlook.com
 (2603:10a6:208:16f::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from l3-laptop.suse (112.232.229.111) by AM0PR05CA0085.eurprd05.prod.outlook.com (2603:10a6:208:136::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.20 via Frontend Transport; Sun, 7 Feb 2021 03:35:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 37fb9d47-b72e-4f9a-d8f3-08d8cb1973fa
X-MS-TrafficTypeDiagnostic: AM0PR04MB6948:
X-Microsoft-Antispam-PRVS: <AM0PR04MB6948E597D9F7596B668EF50AF8B09@AM0PR04MB6948.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3woMMODeSN9H6S8/CjhYLIyoGBZVw6RT5uf4z+ybNBU5XF1y6bOLOuaijHnVZoYwguRQQNRuFRczuoFp3YRLpEJI59hMunndEByxDzc25FsELvgWFfJ+OAD3IxVX+BUK2VJmBP8ZuOOA6uFeyuj58LAWNSYKzhL3v4fb7zW6VTQePSH/THMUscsAotGN5329b6Yh7Hnc2o5NbQz7ftQqP8yDepDn+aZHxu118YVcU/S9gOdn8sqgnss+IA7Q99grRkkaF2Jxd5rqM6mT4qzB69Nbj4FcuOhoxBBQXC1Blo35RTZbrWr6HSPEwPTIQQ6Kar4A6xZpUH9bbDVAW5Zxr6fPhJNiBDJ0keh28aq5zGCJ1s85uzLyf/+hlIyMDnE8w1Ois7mxw1JqTTQ02PZgGSQzObTCQmKvDsFeLJ2YxI+fQ4fR0dUom/LXligWGFRt8qeMUa3/XalsVY8uysaDH/Yw1hBTsfCUVWTRdS+G8HOK4VDddluwrX4vzbmE5hs04uGdGH5ew2tY2wzkGkWu38qJ0XInkg3pPGIRjL3ahHk+aRQypku6NUaFC+0mNuKmZv+q6TUVAAWpEUXgtaUe5bMA8PEF4RchCzxwA/5hDVkJd0Mml7Nti5H2h7iwklkAXb4tyUGtgyTIskHy7qutY1TZDnKaG24wR5pa9r+dmLf+WikD1l66E4YTEC65yuWJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6529.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(346002)(39860400002)(136003)(366004)(52116002)(316002)(6486002)(83380400001)(2906002)(966005)(6666004)(478600001)(2616005)(956004)(16526019)(8936002)(26005)(4326008)(186003)(66946007)(66476007)(53546011)(6506007)(6512007)(66556008)(8676002)(5660300002)(8886007)(86362001)(36756003)(31696002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?/YjB2wQxSaBUGPUk54jjuJvJIzc7I0SEXr+pTfG0+v+2vT/SuVaBPYxOiK7m?=
 =?us-ascii?Q?LhjxvoMRIrOcQoEEP+YDvk5ivE5GFQqnA+h8C7sIZOTSYaNFWU35lwWX850p?=
 =?us-ascii?Q?AaNNSLCzct8GNNEmQpv584MJy4nIBwmG0NC0Ce9g/Q70eeoDhW0IgMMc7F0I?=
 =?us-ascii?Q?PtyDFkRO+Dzn8WYyxbj6aNi8QtGx4NhvgyVaFtSy8hjB/UZPfGQvkykSm0ab?=
 =?us-ascii?Q?Fuhgr62zeOfPABlrWBlJ/Jn79qe2MOi84BRFoam05DYu8eC8e9khnI46Ckvj?=
 =?us-ascii?Q?EJ2awOOMd++4I613GQpyq/vORkWJ8RQR605i9Mm8mK149PixWc2HFn49tSm5?=
 =?us-ascii?Q?vZn8gsT5UAcBNsXNJ83DEQrip7ZRQR6FEf82vsrLNDyEABDgnTby0z9WCce0?=
 =?us-ascii?Q?4IkvcD7Us1JuLABJ6lwNSdouTt0t3z3dSuJXCn4mn6rfqsW3aChARLdi7r9h?=
 =?us-ascii?Q?r4yan6S7pe94QN3eUVPEeJTUIXkyRWeF/1ql1DhflidBuUnzcHnOLcm4TK6L?=
 =?us-ascii?Q?wTPB+2eXB7xvUkBjtlfeGGu3eKDb+j0rWtUSRZh4w8iJ580mcdxXn0oNyfkR?=
 =?us-ascii?Q?1BlENIsakHCbro3LWaOlx2FsdQptgw/+YMr/RraR7VW2+TDdsar+4X79OQCn?=
 =?us-ascii?Q?bFShQzUcupQrlnNS6gdKrnxCmi/PkHX1IW6FG57/bxcwgVW37c2i0hS90hSt?=
 =?us-ascii?Q?TLqDo8Yla9ooqFYsNb/gjNHRN888WvTQLsFq0w1+HML5D1bZ3V4bVl8WgrLS?=
 =?us-ascii?Q?UwFfpm691vXwwDiPvVXSh7NuzH3XuZoKt3fbGqNWb9XWuQinKucFEdqvUCOc?=
 =?us-ascii?Q?peKSkWrtSsbnYnXBDrwbEHf5cpSAzMUIeWONSQ7am4q7D1dKuaEYiqMamL1u?=
 =?us-ascii?Q?WoHt2H4dcmcw7sLocB6vDWUYGL54JQ7zL1Y6auU8OuAVZCcnmPLE/Npdj1Cx?=
 =?us-ascii?Q?Tza91kibH6Y7kF6SJJ3iINbT1UOPxFl+GGzbT3VJ1KwAsFh8QD/dtugXcUf/?=
 =?us-ascii?Q?MPHFvhBWwbkleHODA82J5N6684uhU1K2ytViiXJl/cw7DARU/nDIOyDcBTtj?=
 =?us-ascii?Q?GWxoech6vx7NaVo0YVBueWIdv+IpUuMAxWatuzWcLcfnfSE+P00ZGizDjoSf?=
 =?us-ascii?Q?pQZhbTAxqHb4Xa74pkTVBFZhwXKF1Da7umj3A2LpWL2iWcnJZlJShs3Ahv3n?=
 =?us-ascii?Q?o8S9QcSMcv3nRM2PNT/pr0eHNTPsa0h4KujQZK5BBuA6Y0UQGtIR+lRo+Tcl?=
 =?us-ascii?Q?ZogXpOfa83Tw0+BUdLAq0QM1IJ/4T6T7i4E0eYJWCYa1fMZnFwlamoSH2KJY?=
 =?us-ascii?Q?vfiv029nmStC6GS2x8eYeodB?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37fb9d47-b72e-4f9a-d8f3-08d8cb1973fa
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6529.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2021 03:35:45.4874
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YzYFk60+GNfy4hgiRX9WSUQoaKDnEpUuLR8Xg+9/imlwdA1hgOU38xQQbpVGEhhLbVqIBMei+TbjDVk/LUdIzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6948
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Mariusz,

Sorry I didn't pay attention to the patch you sent to the list and thank
you for letting me know the situation. Please ignore my patch then.

Regards,
Lidong

On 2/5/21 5:17 PM, Tkaczyk, Mariusz wrote:
> Hello,
> Thanks for the patch but we sent similar solution recently, see:
> https://lore.kernel.org/linux-raid/20210115152824.51793-1-
> oleksandr.shchirskyi@intel.com/
> For namespaces exposed via nvme-subsystem, autorebuild scenarios won't
> work because /dev/disk/by-path link doesn't exist.
>=20
> Our patch fixes mdadm --detail-platform output additionally, this part is
> missed here.
>=20
> Mariusz
>=20
> On 05.02.2021 08:11, Lidong Zhong wrote:
>> We had a customer report the following error while assembling the raid
>> device, which is created from Intel VMD configuration of RBSU(bios).
>>> sudo /sbin/mdadm -v --incremental --export /dev/nvme0n1 --offroot
>> /dev/disk/by-id/nvme-eui.355634304e2000530025384500000001
>> /dev/disk/by-id/nvme-MZXL5800HBHQ-000H3_S5V4NE0N200053
>> [sudo] password for root:
>> mdadm: /dev/nvme0n1 is not attached to Intel(R) RAID controller.
>> mdadm: No OROM/EFI properties for /dev/nvme0n1
>> mdadm: no RAID superblock on /dev/nvme0n1
>>
>> It's because in function path_attached_to_hba(), the string of disk
>> doesn't match hba and thus it fails to be recognized as a valid device.
>> The following is the debug output with this patch applied.
>> mdadm: hba: /sys/devices/pci0000:c0/0000:c0:00.5/pci10002:00 - disk:
>> /sys/devices/virtual/nvme-subsystem/nvme-subsys0
>> mdadm: NVME:tmp_path:
>> /sys/devices/virtual/nvme-subsystem/nvme-subsys0/nvme0
>> mdadm: NVME:tmp_path:
>> /sys/devices/virtual/nvme-subsystem/nvme-subsys0/nvme0 - real_disk_path:
>> /sys/devices/pci0000:c0/0000:c0:00.5/pci10002:00/10002:00:04.0/10002:03:=
00.0/nvme/nvme0
>>
>>
>> Signed-off-by: Lidong Zhong <lidong.zhong@suse.com>
>> Reported-by: David Chang <david.chang@hpe.com>
>> ---
>> =A0 platform-intel.c | 11 +++++++++++
>> =A0 1 file changed, 11 insertions(+)
>>
>> diff --git a/platform-intel.c b/platform-intel.c
>> index f1f6d4c..e3c12a3 100644
>> --- a/platform-intel.c
>> +++ b/platform-intel.c
>> @@ -707,6 +707,17 @@ int path_attached_to_hba(const char *disk_path,
>> const char *hba_path)
>> =A0=A0=A0=A0=A0=A0=A0=A0=A0 rc =3D 1;
>> =A0=A0=A0=A0=A0 else
>> =A0=A0=A0=A0=A0=A0=A0=A0=A0 rc =3D 0;
>> +=A0=A0=A0 if (0 =3D=3D rc && strstr(disk_path, "nvme-subsys")) {
>> +=A0=A0=A0=A0=A0=A0=A0 char tmp_path[PATH_MAX], *real_disk_path;
>> +=A0=A0=A0=A0=A0=A0=A0 int len =3D strlen(disk_path);
>> +=A0=A0=A0=A0=A0=A0=A0 snprintf(tmp_path,"%s/nvme%c",disk_path, disk_pat=
h[len-1]);
>> +=A0=A0=A0=A0=A0=A0=A0 real_disk_path =3D realpath(tmp_path, NULL);
>> +=A0=A0=A0=A0=A0=A0=A0 if (real_disk_path) {
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (strncmp(real_disk_path, hba_path,=
 strlen(hba_path))
>> =3D=3D 0)
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 rc =3D 1;
>> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 free(real_disk_path);
>> +=A0=A0=A0=A0=A0=A0=A0 }
>> +=A0=A0=A0 }
>> =A0 =A0=A0=A0=A0=A0 return rc;
>> =A0 }
>>
>=20

