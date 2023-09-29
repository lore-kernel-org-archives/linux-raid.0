Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CCF6E71D40
	for <linux-raid@archiver.kernel.org>; Fri, 29 Sep 2023 15:06:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233260AbjI2PGC (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 29 Sep 2023 11:06:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232490AbjI2PGB (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 29 Sep 2023 11:06:01 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A28A3F7
        for <linux-raid@vger.kernel.org>; Fri, 29 Sep 2023 08:05:59 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38TAk8LB026192
        for <linux-raid@vger.kernel.org>; Fri, 29 Sep 2023 08:05:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : mime-version; s=s2048-2021-q4;
 bh=jQz/6ED91rAgOtwRywmpruRHLu+6VNmi+6iGnn5wnTU=;
 b=ivc/ISMVc8TemNH7vUCb1mjhyZQLJSl4xhFd6DJxobpAGFqfipKBsRXlhlKqc4Pua7ka
 Sur0SHrfrzVNOiX7TSamGgcniyod0cFQeGODvPDtnOORH07tDp8//OwSovVIYPZ8BMXB
 ckrzDcICW1sNc2I5CppkmvSxJqH4NI3bgbhS1H0WRi79XB4R2MnxAm5+I8lw9H6AJJ9O
 kjF61LQMmlSnG/+3nqKdmw7GvUjbWbckkg40zppfcb6BuuhogXrFXYl3LQO1jrqlEwXF
 BZcnwhBq+oBboay5ftf11xs1L2Ouy20+/2DkubDEzjC0AjojcLWZ0y5FCIyYbb7AxemV gA== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3tdddjb9n5-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-raid@vger.kernel.org>; Fri, 29 Sep 2023 08:05:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QNCtvf5MZQ28WMYLIsj93+zGvDoDtOv1e/5eEYkVhD1bAT3T+W67a1DF9NR1o7a/TJ1ydjTpuTVuL6i/ifP7arZPOHYzuhdz5Ch2dJN0VzbM1WvtjpKCH4jdbtpeted+oh9MO2PCn4UuEBU9Md4sinbu0kteNrs2KGe7KN3dsTAUr9hptM54gIwTIc8whtE3pXrn3N6EF6RtpN70bCo1Z5/Ia3hv5MG/3vnf+vL7xz+tntcvDcIhmNXHwXKRvZv/aM6nu2iLiNWubVZuBu02wT2OLk/anFdxTvDizr01JjU+ISTckTrniuSv1q1NMrmbUnOLTAZUb2KmWWUdKo335w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jQz/6ED91rAgOtwRywmpruRHLu+6VNmi+6iGnn5wnTU=;
 b=g5roiJW5NHmPsAh50cuYTbi4zZC9UkEpiwA60pYAcdD6q2yjRG3JFjgg9qyIuwPkqjOL05C/x4FxHVf0KIX9ald7kZzc80uUX/me3TQ6FQbzupEAWOQTlVPd9FthLAyhEwXNJHP67hMlYq8VgDR6WtRpw5KjKCwo1UCo38/4TmGlbgIZQyGJY9TMQq6391bnXYM4uLCYImXUb6IV72K3zRqUYLvqf4MGPGeEZ9GgCdk9W95wVSBHzuREiD7R0EXfAvE50cnePdXRC1YsYvak2YsM5UGSWTax1ZcfKpJj2IPoH5GAWONFCKGD7xayfqdkqNxhExg2niojfxLljZmq3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA1PR15MB4385.namprd15.prod.outlook.com (2603:10b6:806:190::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.26; Fri, 29 Sep
 2023 15:05:55 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::e0e7:7606:7fef:f9de]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::e0e7:7606:7fef:f9de%5]) with mapi id 15.20.6838.027; Fri, 29 Sep 2023
 15:05:54 +0000
From:   Song Liu <songliubraving@meta.com>
To:     Jens Axboe <axboe@kernel.dk>
CC:     Song Liu <songliubraving@meta.com>,
        linux-raid <linux-raid@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Justin Stitt <justinstitt@google.com>,
        Yu Kuai <yukuai3@huawei.com>, Yu Kuai <yukuai1@huaweicloud.com>
Subject: Re: [GIT PULL] md-next 2023-09-28
Thread-Topic: [GIT PULL] md-next 2023-09-28
Thread-Index: AQHZ8k6Yz5y62WGUOUGdago1tEebGLAxUHqAgABnSACAAAFRgIAALyWA
Date:   Fri, 29 Sep 2023 15:05:54 +0000
Message-ID: <67309336-D4CC-4EFE-810A-3096809ABD3B@fb.com>
References: <956CEF49-A326-4F68-BCB3-350C4BF3BAA8@fb.com>
 <f945f9bb-68bc-41b5-977c-64a1f2d0e016@kernel.dk>
 <69B42599-C78A-457F-81A4-DCA643FC32C9@fb.com>
 <b271911c-19cc-43aa-b29f-c5489bf357e3@kernel.dk>
In-Reply-To: <b271911c-19cc-43aa-b29f-c5489bf357e3@kernel.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.700.6)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|SA1PR15MB4385:EE_
x-ms-office365-filtering-correlation-id: 2938293d-381f-4173-2184-08dbc0fd93c0
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VkKITEJKeBF/vORg4Bjlewz8sn0h969+GtdChEI40+e/2zbcOBiay2vV6taNct6p75ZjvoX4ftFJjqKTLwmdfk4mfP2+wkj7RCA9KwGYU2ciEw5+xLN4SYUPIB6QsKvpmp9QzgBWo3O2tSUw7qul2dYCCqjIkIEafdReKmZsfA/rQ17nbr2XQWRfaQXnVlMXxBkv9jjKqUNLZJKiBUt+cJPTlLoLcrh2BsxE+SbcA6+aXBD5s7h0LSpZmisIW9+7NgfAqlg9B7ysTKUrnMeNvaJoXRXelT5Ey65tZwXxaZSJ2SgcqzAHjkz132c2ClxQXCbL/BwY6j1VJcNVO3lJVnjOBWp2Qkf84h2lD16B8T9RbgiHuD8XfA3RfFyxliYOsJm8PvvrCnJ0ohhf1yPNAbbbl2GnB4XRBiwSK8ej/lAqZrnf09kHTN7s30oEvZUaEWfiWCoJYfAk4qmNijooB8hKES0MTcXziVUP38toK7vd9H/LCIdVP1OYGht66nvMPegPiSkAfihNeJy5arzm0sRdZ6iOlTInHGCNfFv59Wl1GFETaWUtRfgYZGGNeE/bynU1S+NSd1jJeAPOHt98Bzx4SO2Frum7kUjJtHDOkKk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(396003)(366004)(39860400002)(136003)(230922051799003)(186009)(1800799009)(64100799003)(451199024)(71200400001)(66899024)(38070700005)(38100700002)(122000001)(9686003)(6512007)(41300700001)(33656002)(6916009)(53546011)(54906003)(316002)(36756003)(66556008)(86362001)(66946007)(66446008)(66476007)(91956017)(64756008)(2906002)(5660300002)(8936002)(8676002)(4326008)(83380400001)(76116006)(6506007)(966005)(6486002)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?XiNGC5R4XDp6ev4nXziITAf64ycLCVWD5TQzU0K8w6jLXfVIFiMkG6+bS4Y6?=
 =?us-ascii?Q?teqpqTe/rtLcxvsk87EhgRcLfNaGjiyC0LTvD2pEGOC/8vikIPDj6Cc9UYAx?=
 =?us-ascii?Q?RPJcIt09mqWCB/OwdbF0fyZHJr9K4MWiS/1PqHnpLtNkg7dml+QhWtJ6+eC6?=
 =?us-ascii?Q?rzA1FvckFu6hlaozi9olmqiRcfZQhp5Tuw13Wq/tbzJiw4ML14kwhGQsHDzr?=
 =?us-ascii?Q?Re8vwopEIceZGoaROjfpM5OPfGpGB+QIZTBBNt26b3erQzyxaQ9oUUxmPL//?=
 =?us-ascii?Q?i2qBuZaJZQB1ufdM44aRq+Pjzzsp012Tmv753udTL6biduPFcwZ9aHMb4+nn?=
 =?us-ascii?Q?wX5wXDJaJ8Zv7QeAf7+oB2qQLIspwW9WdbEOcrU6Gz+LHIxwRGAerFYhgTDM?=
 =?us-ascii?Q?nsb+WxCO+oSTikUOBAJZxDpd7xhqeNOcaIMDVgKKE1MYHGkbmwJFKxzAIrbN?=
 =?us-ascii?Q?Qmi0NMl301dDIjQ/zNLewtRfcqGEbqIk+Ikwp2xBttxsa0CgfdxiYgJLxqez?=
 =?us-ascii?Q?NpuAoU6pGiRIzoSbPi7sWEGnN+B2uFxcp0BNRcnRc2QqWne+XtKVgXq78iJ4?=
 =?us-ascii?Q?csENkgB/nP7dEBrXGSBvO2QYiuYXguVrTOHHlepJW8jQhW4t9Fau/k0+O1SO?=
 =?us-ascii?Q?8KwF7llweWJaZXxWGbMK1ZO5ahEUnt7M/R/k4I/vxfRab+iNcGtNoBJ55Mnh?=
 =?us-ascii?Q?1c+6/QZ6swgPrBwhVUZQMtUWlb6W0APdy4diM7HRBrgm9pemQpGjAI/ew5yC?=
 =?us-ascii?Q?E37/kgXCZ7RjoUOfe9pT4BOUqNc8VnZkFP8XcsMilQjNNQe8ZqgSL6/zJw+e?=
 =?us-ascii?Q?ZSkT7i66/AIgvuLw9Zp85k0H3yiU1R2frckteurFJ8RDUG3HHKuiSAbHDmOR?=
 =?us-ascii?Q?eTVQ+zZ8dvnbx+IGnyZ2Rx5afDV7fbwqErJQGng4ede2Eb7nbi4sX+uq5A9z?=
 =?us-ascii?Q?zCa/peCtzEQeNksN83PzKQzx4XswbAhanVt0up4WO2rnfudnJniNTQmbt1pu?=
 =?us-ascii?Q?6Q2j8fQthJYAQHpsNjVFWaSsbayiU6qBmwugh7MrPUeF0/FGfjjObj+FrnDN?=
 =?us-ascii?Q?zrRybpbr26bFAbWfF6+Zq/AIEXq5smfQ5YPOM4DS/ccMkjSiQTbmympmEKYf?=
 =?us-ascii?Q?TVM+VuC8sHLSgBSha8i2jg2SHQspUHaBAypLl8T4M0S39mWUyaDvJ+UuK2gq?=
 =?us-ascii?Q?DEQ+FMM1oxTTQo0EyVHfYn9eZoeBc5Iwrz8+5h370y/1xKc4kEpnyzz1LNtH?=
 =?us-ascii?Q?uvFAl+Ov0oLFsMd+z44woTdZPB2v9rYzKkjXjO/IBxS65I8s9Z4uU5zsCQeK?=
 =?us-ascii?Q?w1GfZKo+KguWNcaUoKcXl0iDGskcqNL96BH1SOlOiljNK4TajWsb+vziYCgl?=
 =?us-ascii?Q?LdTAabT28l02I+CdoGZb4sK7io4SDA1nZQLtAYyyrKR0C7SOYlixwycBxMLR?=
 =?us-ascii?Q?hML82tkCR7XQUHhrkMUmZ5QrBe2Zj7iZs4pnHDxfvjNGOGEOug/YgQ8bFOwQ?=
 =?us-ascii?Q?2SAacuK5ADVlP0p2IWOqEnsrbx8zeum0DzBVtFdOl4GX0ccZdbAs2ZlCFiCP?=
 =?us-ascii?Q?i/Ka6wCEVo0g5C818ma3PNbqF/SsYIANkwD74xUohayh2Hy+FXkOvDgJC6Ve?=
 =?us-ascii?Q?InAUest6kvm1KBK6ef3/6wg=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A876097EBB5A814892C4A4B00B6B3307@namprd15.prod.outlook.com>
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2938293d-381f-4173-2184-08dbc0fd93c0
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Sep 2023 15:05:54.0751
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: r/j7WulHrfsZNZbWShLLZV5piJ/BbbZX+aIG9uTr3ScjQoMNHJkavCVXYPGLftDBv6K2u1LnEYxVmAGx5XR08A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4385
X-Proofpoint-ORIG-GUID: XaOfyisnPfJwOhGZr8SXiX2LOIqJ7q3V
X-Proofpoint-GUID: XaOfyisnPfJwOhGZr8SXiX2LOIqJ7q3V
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-09-29_13,2023-09-28_03,2023-05-22_02
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



> On Sep 29, 2023, at 5:16 AM, Jens Axboe <axboe@kernel.dk> wrote:
> 
> On 9/29/23 6:12 AM, Song Liu wrote:
>> 
>> 
>>> On Sep 28, 2023, at 11:02 PM, Jens Axboe <axboe@kernel.dk> wrote:
>>> 
>>> On 9/28/23 2:58 PM, Song Liu wrote:
>>>> Hi Jens, 
>>>> 
>>>> Please consider pulling the following changes for md-next on top of your
>>>> for-6.7/block branch. 
>>>> 
>>>> Major changes in these patches are:
>>>> 
>>>> 1. Make rdev add/remove independent from daemon thread, by Yu Kuai;
>>>> 2. Refactor code around quiesce() and mddev_suspend(), by Yu Kuai.
>>> 
>>> Changes looks fine to me, but this patch:
>>> 
>>> https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git/commit/?h=md-next&id=b71fe4ac7531d67e6fc8c287cbcb2b176aa93833
>>> 
>>> is referencing a commit that doesn't exist:
>>> 
>>> "After commit 4d27e927344a ("md: don't quiesce in mddev_suspend()"),"
>>> 
>>> which I think should be:
>>> 
>>> b39f35ebe86d ("md: don't quiesce in mddev_suspend()")
>>> 
>>> where is this other sha from?
>> 
>> The other sha was from a previous md-next that got rebased later. 
>> I guess Kuai didn't catch it because he had the old sha in his 
>> local git cache. I should have caught it, but missed it because 
>> it was not behind a Fixed tag (still my fault). 
> 
> Makes sense. It's not a huge deal, and I would not rebase your tree for
> it. Mostly just curious where it came from.

Got it. Thanks for the suggestion. 

> 
>> I recently improved my process to only do rebase when necessary 
>> (I used to rebase too often). Hopefully this will prevent sha 
>> mismatch in the future. However, to fix this one, I guess I have 
>> no options but rebase the branch? I will fix it later today and 
>> resend the pull request. 
> 
> I did notice that the tree looks much better now, rather than have all
> brand new commits. Thanks for doing that! So I say we keep it as-is and
> I pull it - it's easy enough to find the real commit just based on the
> subject.

Yeah, the real commit is easy to find. 

Song
