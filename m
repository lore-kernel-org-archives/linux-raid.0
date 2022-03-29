Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43F61C433F5
	for <linux-raid@archiver.kernel.org>; Tue, 29 Mar 2022 13:06:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235616AbiC2NIR (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 29 Mar 2022 09:08:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237215AbiC2NIH (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 29 Mar 2022 09:08:07 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1C64E438E
        for <linux-raid@vger.kernel.org>; Tue, 29 Mar 2022 06:06:22 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22TCa3uP003891;
        Tue, 29 Mar 2022 13:06:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : in-reply-to : mime-version;
 s=corp-2021-07-09; bh=crto6BZOkglYEoYP0/fCgFbd+/NghbcETAnkWKv0cKM=;
 b=XFUdLJupz4o7F0rCcnkPZjzmwyPyzrFqQT0eV3+8VHZSkn4lA7wQVNtuLJRKmVrcLX78
 5fRK5ZKQ9WePdblCuc3rOD/GUdgytk8iWWjrWYj96GKCBkkHE7n0pkhiQMXyfIRY1MaE
 atYYJl/wF/VRd7knxk4QM1vi4fqhndiy7bN/SOTiyYNkDIb5we3lQmU6zkjdeChVmPep
 p0TTpks+G+WmJUwjhgg4X0E/w4Y3f05EJlYx0dsEm7fmz1k9KhWLyWx6e1WlbxJZBOjp
 tuOeXRjNoswqq4N2rPuf+Q7L5LHVnbbcM/DWj1WJUCeSwDPRb0meme+ixqaVAzdcyk4D jQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80] (may be forged))
        by mx0b-00069f02.pphosted.com with ESMTP id 3f1sm2ehk2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Mar 2022 13:06:01 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22TD5mJ9075546;
        Tue, 29 Mar 2022 13:06:00 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by userp3030.oracle.com with ESMTP id 3f1qxqeeuu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Mar 2022 13:06:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cUklBYld4h40EH/p+DnO6BE4nOxM0LNE9peLbFSe/3k+U9NX16YAmF8IcvuXHhIqvKHH6U4xUR7eVLFWhcNWR+yhN7MG3nCilLlTv8R8beHuMZwaoKcj+OSszsQOI6lcriGLR6hI97xnF29OEW1/MZ1vrZWrQ6UHJtf1XceDiTE6oxjRKA60aKItkACwdGnrL6I1r5UmbOmeoXrM3bZiBNSW1VxgsukCgmHOfykqhsap4i0Z4wrlP5XcBjt/l71yxWSdK+MscOB2AIyTmSntnnbfcJ6C6fJej5YkP4sAxuxj0mB2DZFg49jsgzsEtznCAzbsVW7W6GtQTJw6rsYYNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=crto6BZOkglYEoYP0/fCgFbd+/NghbcETAnkWKv0cKM=;
 b=CrjAp9srbPYvGcqJPsjF6eVoi0CXSe7iS3q3uuY9t+/+7Xzqm4xymyZhUJkrrfc8RvA/23BGDjuDce7gbkihMzslhy3eZYY9MBm9udZQnMro6uEUIy5+pAkmzR/1j41nekvp/883s7h8cjN88gUbetfTlbK2g6KyaQNuuU3qKp6kskM3MVww9YtoWxY0MSvUeIDS8KYqeRrrT3ap3+ARjya5ZhjkgkHBq7jiI3/vjPn/szfZtN9I/EbeYrkCfo4slOycZwAhP6/PbHHjFFM4EFz77VxBmkJ4A0jMpTgPbY7ZhxUKrbXTxuqMDuPbu9+JK2em23htJYbgl2JZbfQdrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=crto6BZOkglYEoYP0/fCgFbd+/NghbcETAnkWKv0cKM=;
 b=IAeIdyJJxUWYnYsszaudXOSMtjkITRQwMGTvzSE1Hqga9SLyOOGfewEOOLFM0EQWjYzKWAJUc5Rh5mBWkxZmwG1OSqBAiABVygXGVGdlGKxNcat1EUM1OPWPX8SIaE3FmztJBZb2wSeyg/FWVqqXzwOrSry5IBTbyV2Me57jZBo=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1325.namprd10.prod.outlook.com
 (2603:10b6:300:1e::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.18; Tue, 29 Mar
 2022 13:05:57 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d4e7:ee60:f060:e20c]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d4e7:ee60:f060:e20c%7]) with mapi id 15.20.5081.025; Tue, 29 Mar 2022
 13:05:57 +0000
Date:   Tue, 29 Mar 2022 16:05:40 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     kbuild@lists.01.org, Heming Zhao <heming.zhao@suse.com>,
        linux-raid@vger.kernel.org, song@kernel.org
Cc:     lkp@intel.com, kbuild-all@lists.01.org,
        Heming Zhao <heming.zhao@suse.com>, guoqing.jiang@linux.dev,
        xni@redhat.com
Subject: [kbuild] Re: [PATCH] md/bitmap: don't set sb values if can't pass
 sanity check
Message-ID: <202203260647.ZIDU6VYv-lkp@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220325025223.1866-1-heming.zhao@suse.com>
Message-ID-Hash: KJX5G7JD7XSCULJ3QAYUJOQ7DOL6QGLF
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNAP275CA0036.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4d::6)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d2bcdc54-f364-4f8e-a275-08da1184dd67
X-MS-TrafficTypeDiagnostic: MWHPR10MB1325:EE_
X-Microsoft-Antispam-PRVS: <MWHPR10MB1325699417747CB2A8663B078E1E9@MWHPR10MB1325.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Cr/WyMbHs/b7xptXdkHWknRmQ40EgK5KOw4hZiFeFNvFYGNtcK13rpkpu8/Ts4os93j7kaAj6sajhcqr6IPOvT9rhPIRr4/jV9lmvUxxmLwPU6P5/VeXd1MiNmR8pvcONovVUr7DBjQoxQJ7WFnk30dgoXLJTfeAV0rMkxKEUJ2wIaFdXf/YAR7dwkEK0id24rnJtlSGG4oBvgQPm0vZ3Bekz2cqSIk7XgZYMtrPfhp8IJdPb6Ff1Xek43Dw6i0/1VyKN2UoaX71LgJ2sI+S3M6AZyKJAFJx22xpHDh3NOQeuGH3k0+DzaYHSTQjgd7Hkozsdd8fpufSX0rg/SpkjQ6OqeUmaM2FSskqtElJN+TuLpsODnI98ZT/69KoRo2zCXROQVobkZoPwsXHn+kZTwkXEWZTFl/YeTQSRcIEphgbMLMdAwmE0UTjFmOGPFUvt0E9VUt84FnSnynFN+K2snvBLcHWst9uxHyeKmeIp2ZXMVYGNEwQmbgSTY8+wLIm3R13UDnTyS3TPgDTwmhFc1uEAC9k6H1KZ52P+uAw1MSRk/FEDpcxJczLDn6z0L0YY/D+uk0lJ+fTN/MMy0TN2WuOJRZzd1PQlYRZ8sKjPK7BIrMdU1OotzQB70BOxpb77nAjfj+0JvEicrTNpxg6ZF5AsZyCtvs5WhCj8z2wdW425BS3h8MO4Q0EU48nRxTnHdV5BHcrlx4LWjydufLwBOGrQp2RPjBe9Dm423M6Txy6dOuM1X/IPFX2LmE4pZvnk7oc9SEjwRK7NuKKL9KRrosj5F3qxxltts3ZP8wXYfaXMOaOFcMDpP/GNaOfLreZoczxENNHzhF/whb5NwZJnA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(4001150100001)(8676002)(38350700002)(38100700002)(66476007)(2906002)(66946007)(316002)(66556008)(52116002)(4326008)(6512007)(5660300002)(30864003)(86362001)(36756003)(1076003)(966005)(9686003)(44832011)(6506007)(186003)(26005)(6666004)(508600001)(6486002)(8936002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QYwdQYqSQHB+nc5aGVPxg4lo2cp+ol1Xs4UhVKa9ElmqLjTEwKBOLRKw9+hW?=
 =?us-ascii?Q?vvF8UxURpAVZB6KThGXF/tcBmpn/lUpjjapjobbMJozLnyZRA21w5Q5ohc8D?=
 =?us-ascii?Q?BERyr1ciPDEOEs6/sMIiTqZFI6cpFFkmgP86GmnTquy1sSiMAi5hBwh18rk3?=
 =?us-ascii?Q?Mo5ocoilLtOH3JWQzeP03sFOC8GiSMbJG/TxZ4QyRqlXLG7Q3aN0VTxTBPJk?=
 =?us-ascii?Q?KnCOPpdU1Io/QV2T2G/ncM6Nnn1d7OwJ/snGjxnRf5kBpADxVqk4s98r9a1f?=
 =?us-ascii?Q?OaukhSLEGwtG4cPSr+W4CFo+p58laH67iULggncyipkH3aBnbM2+Gym8POE/?=
 =?us-ascii?Q?WRmhq0CF063euaPOsDCkbF4d6QH9lqrY/BHlfeUCBAnmDe31ONydyx820Mlf?=
 =?us-ascii?Q?1bPX6+hNq3AeFC8fysMc1DQaE2TuoNXm13Ee4GuOuhizqlI5LTDMOW6OUjOd?=
 =?us-ascii?Q?3ugu3zkaVcPCENeov8m1KsTBvvkgM2kv01Uu/c127eOUVbmoJEomMKITqzuC?=
 =?us-ascii?Q?X3fwCcVMvtveyaB46jEnpHFuSullOVvavi+6SImIvhKEPd4Mq2C+BeA3VSY7?=
 =?us-ascii?Q?RDvlx01FUg4YQrdYbAFzVREImTvjcCs8A74CQgCrhfnHWmyeAbG/ljB5T7qq?=
 =?us-ascii?Q?iiky8V3flV9IVLDmr8QLMx+EKodyQAUO/DwdIA2VZ6jfeQuCfdPf2JSPX2LT?=
 =?us-ascii?Q?fsDa69Tg+EHhsewYHqHPv+WJZa7d+S320cdmLJCEgFGGO9vxz1ozMNJyWqJa?=
 =?us-ascii?Q?R7BML2xhJD9J8dVvBNGyFddUY5FiHfkqDMkAbvvHYohHHsJXT7zapsbR+WfO?=
 =?us-ascii?Q?iy0u1lC9S/ZLxx4DF+xNX1ylQkYDgbdcyHSWDEzPpvN0XKQLdTq+hx+w8gc9?=
 =?us-ascii?Q?1pQ6KYbXk7FeGgAQvpZ0FMkFODU8hTVcK4a3KiJ1ra9FUg1mrkihJTurzELp?=
 =?us-ascii?Q?Ba2hQ6PiN+42tnhHyg4F5F+AZsbyRSVq9S3+13pnKRLC2YGSXgoEZtlMpodC?=
 =?us-ascii?Q?oQFB8uGkoKBQP5SbRO9yPrfAd0sKLnztzNA21vGURxozYMYqTCcmkYBEGnBu?=
 =?us-ascii?Q?/GLIsDn49RIVYnK0aXXpZpErmqJZ1KrSAybp1HGa7tf3nscqr488uGQvGAny?=
 =?us-ascii?Q?moq8lIb/qbrVEO3cycYby2RWkT5UgClOt3RLPYc2XI5aoI6oMhswFPt3X4CE?=
 =?us-ascii?Q?WzfmNwwkqt5Fxy11pKF+c+bhXybUChjl+ziclc2Ak5smkmHCFlA2/4jSUZ+D?=
 =?us-ascii?Q?TVGxM48flk5HgeMxfaAQJ9KXkE6a77JZ2pSZrWfBrxpXl0BTBY+Cr3Pn4gCi?=
 =?us-ascii?Q?sII9jINnyVON21Xb4Asff3HNJP72WPZ8mEPFUBFiQVUv+xGWZGb3Hj0GzQ5Q?=
 =?us-ascii?Q?Txr5MZ3EcF0Fn6afYM6ElBPEmMqJDr8l+68Vk4jO50CQo/rJyKihORr9bO60?=
 =?us-ascii?Q?PBglu9+1L9/4mq5IaYN8nET87kfE82Cf6UYQm+qPNmK1kBlvEafl4A4aSfBS?=
 =?us-ascii?Q?v2WjPcsGgqvnGBFM8hoO9TU8Z7JyU4e5WdFxIwBtfOoEn6CXxfenrZUoASqV?=
 =?us-ascii?Q?Ksjl5tMrSaD2z36n0D9JmNHcseE1yE++7VlIiqmixpy91CnoLGjVmqh6CpwD?=
 =?us-ascii?Q?b9pGbt30o0wy2ZPSOFeOyf80/HRtQSl6g4ymcu34yfoNSo9OasWbKYPa6BL6?=
 =?us-ascii?Q?DyYtP+ePSoPHq225tJS5MYuA2EpS2muPd6vkFydDnPUpY6ax2wSFB+KyITro?=
 =?us-ascii?Q?lR5ln/D1b5OZTktVpGWfGDxcEjDEvts=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2bcdc54-f364-4f8e-a275-08da1184dd67
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2022 13:05:57.5664
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZK3GIKM3y2V+I3jgjL16DqY2Xb7Mhv7XQUeYfKx4goUhRZNUUvdtPFAkKd264eLHaJxxIzMn5G6Pd2r6VkC625cAzUOZm8dio6w+U5z7ze0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1325
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10300 signatures=694973
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 bulkscore=0
 adultscore=0 spamscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203290080
X-Proofpoint-ORIG-GUID: z5-KH3xF74vreMdpkn8GFXnxvcrf2QL1
X-Proofpoint-GUID: z5-KH3xF74vreMdpkn8GFXnxvcrf2QL1
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Heming,

url:    https://github.com/0day-ci/linux/commits/Heming-Zhao/md-bitmap-don-t-set-sb-values-if-can-t-pass-sanity-check/20220325-105426 
base:   git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
config: powerpc-randconfig-m031-20220324 (https://download.01.org/0day-ci/archive/20220326/202203260647.ZIDU6VYv-lkp@intel.com/config )
compiler: powerpc-linux-gcc (GCC) 11.2.0

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>

New smatch warnings:
drivers/md/md-bitmap.c:644 md_bitmap_read_sb() error: uninitialized symbol 'chunksize'.
drivers/md/md-bitmap.c:648 md_bitmap_read_sb() error: uninitialized symbol 'daemon_sleep'.
drivers/md/md-bitmap.c:650 md_bitmap_read_sb() error: uninitialized symbol 'write_behind'.

Old smatch warnings:
drivers/md/md-bitmap.c:371 read_page() warn: should 'index << (12 - inode->i_blkbits)' be a 64 bit type?
drivers/md/md-bitmap.c:2182 md_bitmap_resize() warn: should 'old_counts.chunks << old_counts.chunkshift' be a 64 bit type?
drivers/md/md-bitmap.c:2206 md_bitmap_resize() warn: should '1 << chunkshift' be a 64 bit type?

vim +/chunksize +644 drivers/md/md-bitmap.c

e64e4018d57271 drivers/md/md-bitmap.c Andy Shevchenko   2018-08-01  578  static int md_bitmap_read_sb(struct bitmap *bitmap)
32a7627cf3a353 drivers/md/bitmap.c    NeilBrown         2005-06-21  579  {
32a7627cf3a353 drivers/md/bitmap.c    NeilBrown         2005-06-21  580  	char *reason = NULL;
32a7627cf3a353 drivers/md/bitmap.c    NeilBrown         2005-06-21  581  	bitmap_super_t *sb;
4b6d287f627b5f drivers/md/bitmap.c    NeilBrown         2005-09-09  582  	unsigned long chunksize, daemon_sleep, write_behind;
32a7627cf3a353 drivers/md/bitmap.c    NeilBrown         2005-06-21  583  	unsigned long long events;
c4ce867fdad200 drivers/md/bitmap.c    Goldwyn Rodrigues 2014-03-29  584  	int nodes = 0;
1dff2b87a34a1a drivers/md/bitmap.c    NeilBrown         2012-05-22  585  	unsigned long sectors_reserved = 0;
32a7627cf3a353 drivers/md/bitmap.c    NeilBrown         2005-06-21  586  	int err = -EINVAL;
27581e5ae01f77 drivers/md/bitmap.c    NeilBrown         2012-05-22  587  	struct page *sb_page;
33e38ac6887d97 drivers/md/bitmap.c    Goldwyn Rodrigues 2015-07-01  588  	loff_t offset = bitmap->mddev->bitmap_info.offset;
32a7627cf3a353 drivers/md/bitmap.c    NeilBrown         2005-06-21  589  
1ec885cdd01a9a drivers/md/bitmap.c    NeilBrown         2012-05-22  590  	if (!bitmap->storage.file && !bitmap->mddev->bitmap_info.offset) {
ef99bf480de9bd drivers/md/bitmap.c    NeilBrown         2012-05-22  591  		chunksize = 128 * 1024 * 1024;
ef99bf480de9bd drivers/md/bitmap.c    NeilBrown         2012-05-22  592  		daemon_sleep = 5 * HZ;
ef99bf480de9bd drivers/md/bitmap.c    NeilBrown         2012-05-22  593  		write_behind = 0;
b405fe91e50c60 drivers/md/bitmap.c    NeilBrown         2012-05-22  594  		set_bit(BITMAP_STALE, &bitmap->flags);
ef99bf480de9bd drivers/md/bitmap.c    NeilBrown         2012-05-22  595  		err = 0;
ef99bf480de9bd drivers/md/bitmap.c    NeilBrown         2012-05-22  596  		goto out_no_sb;
ef99bf480de9bd drivers/md/bitmap.c    NeilBrown         2012-05-22  597  	}
32a7627cf3a353 drivers/md/bitmap.c    NeilBrown         2005-06-21  598  	/* page 0 is the superblock, read it... */
27581e5ae01f77 drivers/md/bitmap.c    NeilBrown         2012-05-22  599  	sb_page = alloc_page(GFP_KERNEL);
27581e5ae01f77 drivers/md/bitmap.c    NeilBrown         2012-05-22  600  	if (!sb_page)
27581e5ae01f77 drivers/md/bitmap.c    NeilBrown         2012-05-22  601  		return -ENOMEM;
1ec885cdd01a9a drivers/md/bitmap.c    NeilBrown         2012-05-22  602  	bitmap->storage.sb_page = sb_page;
27581e5ae01f77 drivers/md/bitmap.c    NeilBrown         2012-05-22  603  
b97e92574c0bf3 drivers/md/bitmap.c    Goldwyn Rodrigues 2014-06-06  604  re_read:
f9209a323547f0 drivers/md/bitmap.c    Goldwyn Rodrigues 2014-06-06  605  	/* If cluster_slot is set, the cluster is setup */
f9209a323547f0 drivers/md/bitmap.c    Goldwyn Rodrigues 2014-06-06  606  	if (bitmap->cluster_slot >= 0) {
3b0e6aacbfe04f drivers/md/bitmap.c    Stephen Rothwell  2015-03-03  607  		sector_t bm_blocks = bitmap->mddev->resync_max_sectors;
f9209a323547f0 drivers/md/bitmap.c    Goldwyn Rodrigues 2014-06-06  608  
a913096decbf41 drivers/md/md-bitmap.c Zhao Heming       2020-10-06  609  		bm_blocks = DIV_ROUND_UP_SECTOR_T(bm_blocks,
a913096decbf41 drivers/md/md-bitmap.c Zhao Heming       2020-10-06  610  			   (bitmap->mddev->bitmap_info.chunksize >> 9));
124eb761edfdee drivers/md/bitmap.c    Goldwyn Rodrigues 2015-03-24  611  		/* bits to bytes */
124eb761edfdee drivers/md/bitmap.c    Goldwyn Rodrigues 2015-03-24  612  		bm_blocks = ((bm_blocks+7) >> 3) + sizeof(bitmap_super_t);
124eb761edfdee drivers/md/bitmap.c    Goldwyn Rodrigues 2015-03-24  613  		/* to 4k blocks */
935f3d4fc62c1f drivers/md/bitmap.c    NeilBrown         2015-03-02  614  		bm_blocks = DIV_ROUND_UP_SECTOR_T(bm_blocks, 4096);
33e38ac6887d97 drivers/md/bitmap.c    Goldwyn Rodrigues 2015-07-01  615  		offset = bitmap->mddev->bitmap_info.offset + (bitmap->cluster_slot * (bm_blocks << 3));
ec0cc226854a79 drivers/md/bitmap.c    NeilBrown         2016-11-02  616  		pr_debug("%s:%d bm slot: %d offset: %llu\n", __func__, __LINE__,
33e38ac6887d97 drivers/md/bitmap.c    Goldwyn Rodrigues 2015-07-01  617  			bitmap->cluster_slot, offset);
f9209a323547f0 drivers/md/bitmap.c    Goldwyn Rodrigues 2014-06-06  618  	}
f9209a323547f0 drivers/md/bitmap.c    Goldwyn Rodrigues 2014-06-06  619  
1ec885cdd01a9a drivers/md/bitmap.c    NeilBrown         2012-05-22  620  	if (bitmap->storage.file) {
1ec885cdd01a9a drivers/md/bitmap.c    NeilBrown         2012-05-22  621  		loff_t isize = i_size_read(bitmap->storage.file->f_mapping->host);
f49d5e62d9352d drivers/md/bitmap.c    NeilBrown         2007-01-26  622  		int bytes = isize > PAGE_SIZE ? PAGE_SIZE : isize;
f49d5e62d9352d drivers/md/bitmap.c    NeilBrown         2007-01-26  623  
1ec885cdd01a9a drivers/md/bitmap.c    NeilBrown         2012-05-22  624  		err = read_page(bitmap->storage.file, 0,
27581e5ae01f77 drivers/md/bitmap.c    NeilBrown         2012-05-22  625  				bitmap, bytes, sb_page);
f49d5e62d9352d drivers/md/bitmap.c    NeilBrown         2007-01-26  626  	} else {
27581e5ae01f77 drivers/md/bitmap.c    NeilBrown         2012-05-22  627  		err = read_sb_page(bitmap->mddev,
33e38ac6887d97 drivers/md/bitmap.c    Goldwyn Rodrigues 2015-07-01  628  				   offset,
27581e5ae01f77 drivers/md/bitmap.c    NeilBrown         2012-05-22  629  				   sb_page,
938b533d479e74 drivers/md/bitmap.c    Shaohua Li        2017-10-16  630  				   0, sizeof(bitmap_super_t));
a654b9d8f851f4 drivers/md/bitmap.c    NeilBrown         2005-06-21  631  	}
27581e5ae01f77 drivers/md/bitmap.c    NeilBrown         2012-05-22  632  	if (err)
32a7627cf3a353 drivers/md/bitmap.c    NeilBrown         2005-06-21  633  		return err;
32a7627cf3a353 drivers/md/bitmap.c    NeilBrown         2005-06-21  634  
b97e92574c0bf3 drivers/md/bitmap.c    Goldwyn Rodrigues 2014-06-06  635  	err = -EINVAL;
27581e5ae01f77 drivers/md/bitmap.c    NeilBrown         2012-05-22  636  	sb = kmap_atomic(sb_page);
32a7627cf3a353 drivers/md/bitmap.c    NeilBrown         2005-06-21  637  
32a7627cf3a353 drivers/md/bitmap.c    NeilBrown         2005-06-21  638  	/* verify that the bitmap-specific fields are valid */
32a7627cf3a353 drivers/md/bitmap.c    NeilBrown         2005-06-21  639  	if (sb->magic != cpu_to_le32(BITMAP_MAGIC))
32a7627cf3a353 drivers/md/bitmap.c    NeilBrown         2005-06-21  640  		reason = "bad magic";
bd926c63b7a684 drivers/md/bitmap.c    NeilBrown         2005-11-08  641  	else if (le32_to_cpu(sb->version) < BITMAP_MAJOR_LO ||
3c462c880b52aa drivers/md/bitmap.c    Goldwyn Rodrigues 2015-08-19  642  		 le32_to_cpu(sb->version) > BITMAP_MAJOR_CLUSTERED)
32a7627cf3a353 drivers/md/bitmap.c    NeilBrown         2005-06-21  643  		reason = "unrecognized superblock version";
1187cf0a3c8b64 drivers/md/bitmap.c    NeilBrown         2009-03-31 @644  	else if (chunksize < 512)

Checked before initialized

7dd5d34c6c2da0 drivers/md/bitmap.c    NeilBrown         2006-01-06  645  		reason = "bitmap chunksize too small";
d744540cd39e93 drivers/md/bitmap.c    Jonathan Brassow  2011-06-08  646  	else if (!is_power_of_2(chunksize))
32a7627cf3a353 drivers/md/bitmap.c    NeilBrown         2005-06-21  647  		reason = "bitmap chunksize not a power of 2";
1b04be96f6910e drivers/md/bitmap.c    NeilBrown         2009-12-14 @648  	else if (daemon_sleep < 1 || daemon_sleep > MAX_SCHEDULE_TIMEOUT)
7dd5d34c6c2da0 drivers/md/bitmap.c    NeilBrown         2006-01-06  649  		reason = "daemon sleep period out of range";
4b6d287f627b5f drivers/md/bitmap.c    NeilBrown         2005-09-09 @650  	else if (write_behind > COUNTER_MAX)
4b6d287f627b5f drivers/md/bitmap.c    NeilBrown         2005-09-09  651  		reason = "write-behind limit out of range (0 - 16383)";
32a7627cf3a353 drivers/md/bitmap.c    NeilBrown         2005-06-21  652  	if (reason) {
ec0cc226854a79 drivers/md/bitmap.c    NeilBrown         2016-11-02  653  		pr_warn("%s: invalid bitmap file superblock: %s\n",
32a7627cf3a353 drivers/md/bitmap.c    NeilBrown         2005-06-21  654  			bmname(bitmap), reason);
32a7627cf3a353 drivers/md/bitmap.c    NeilBrown         2005-06-21  655  		goto out;
32a7627cf3a353 drivers/md/bitmap.c    NeilBrown         2005-06-21  656  	}
32a7627cf3a353 drivers/md/bitmap.c    NeilBrown         2005-06-21  657  
f9fd5e55a60521 drivers/md/md-bitmap.c Heming Zhao       2022-03-25  658  	chunksize = le32_to_cpu(sb->chunksize);

Initialize here

f9fd5e55a60521 drivers/md/md-bitmap.c Heming Zhao       2022-03-25  659  	daemon_sleep = le32_to_cpu(sb->daemon_sleep) * HZ;
f9fd5e55a60521 drivers/md/md-bitmap.c Heming Zhao       2022-03-25  660  	write_behind = le32_to_cpu(sb->write_behind);
f9fd5e55a60521 drivers/md/md-bitmap.c Heming Zhao       2022-03-25  661  	sectors_reserved = le32_to_cpu(sb->sectors_reserved);
f9fd5e55a60521 drivers/md/md-bitmap.c Heming Zhao       2022-03-25  662  	/* Setup nodes/clustername only if bitmap version is
f9fd5e55a60521 drivers/md/md-bitmap.c Heming Zhao       2022-03-25  663  	 * cluster-compatible
f9fd5e55a60521 drivers/md/md-bitmap.c Heming Zhao       2022-03-25  664  	 */
f9fd5e55a60521 drivers/md/md-bitmap.c Heming Zhao       2022-03-25  665  	if (sb->version == cpu_to_le32(BITMAP_MAJOR_CLUSTERED)) {
f9fd5e55a60521 drivers/md/md-bitmap.c Heming Zhao       2022-03-25  666  		nodes = le32_to_cpu(sb->nodes);
f9fd5e55a60521 drivers/md/md-bitmap.c Heming Zhao       2022-03-25  667  		strlcpy(bitmap->mddev->bitmap_info.cluster_name,
f9fd5e55a60521 drivers/md/md-bitmap.c Heming Zhao       2022-03-25  668  				sb->cluster_name, 64);
f9fd5e55a60521 drivers/md/md-bitmap.c Heming Zhao       2022-03-25  669  	}
f9fd5e55a60521 drivers/md/md-bitmap.c Heming Zhao       2022-03-25  670  
32a7627cf3a353 drivers/md/bitmap.c    NeilBrown         2005-06-21  671  	/* keep the array size field of the bitmap superblock up to date */
32a7627cf3a353 drivers/md/bitmap.c    NeilBrown         2005-06-21  672  	sb->sync_size = cpu_to_le64(bitmap->mddev->resync_max_sectors);
32a7627cf3a353 drivers/md/bitmap.c    NeilBrown         2005-06-21  673  
278c1ca2f254d0 drivers/md/bitmap.c    NeilBrown         2012-03-19  674  	if (bitmap->mddev->persistent) {
32a7627cf3a353 drivers/md/bitmap.c    NeilBrown         2005-06-21  675  		/*
278c1ca2f254d0 drivers/md/bitmap.c    NeilBrown         2012-03-19  676  		 * We have a persistent array superblock, so compare the
32a7627cf3a353 drivers/md/bitmap.c    NeilBrown         2005-06-21  677  		 * bitmap's UUID and event counter to the mddev's
32a7627cf3a353 drivers/md/bitmap.c    NeilBrown         2005-06-21  678  		 */
32a7627cf3a353 drivers/md/bitmap.c    NeilBrown         2005-06-21  679  		if (memcmp(sb->uuid, bitmap->mddev->uuid, 16)) {
ec0cc226854a79 drivers/md/bitmap.c    NeilBrown         2016-11-02  680  			pr_warn("%s: bitmap superblock UUID mismatch\n",
32a7627cf3a353 drivers/md/bitmap.c    NeilBrown         2005-06-21  681  				bmname(bitmap));
32a7627cf3a353 drivers/md/bitmap.c    NeilBrown         2005-06-21  682  			goto out;
32a7627cf3a353 drivers/md/bitmap.c    NeilBrown         2005-06-21  683  		}
32a7627cf3a353 drivers/md/bitmap.c    NeilBrown         2005-06-21  684  		events = le64_to_cpu(sb->events);
b97e92574c0bf3 drivers/md/bitmap.c    Goldwyn Rodrigues 2014-06-06  685  		if (!nodes && (events < bitmap->mddev->events)) {
ec0cc226854a79 drivers/md/bitmap.c    NeilBrown         2016-11-02  686  			pr_warn("%s: bitmap file is out of date (%llu < %llu) -- forcing full recovery\n",
278c1ca2f254d0 drivers/md/bitmap.c    NeilBrown         2012-03-19  687  				bmname(bitmap), events,
32a7627cf3a353 drivers/md/bitmap.c    NeilBrown         2005-06-21  688  				(unsigned long long) bitmap->mddev->events);
b405fe91e50c60 drivers/md/bitmap.c    NeilBrown         2012-05-22  689  			set_bit(BITMAP_STALE, &bitmap->flags);
32a7627cf3a353 drivers/md/bitmap.c    NeilBrown         2005-06-21  690  		}
278c1ca2f254d0 drivers/md/bitmap.c    NeilBrown         2012-03-19  691  	}
278c1ca2f254d0 drivers/md/bitmap.c    NeilBrown         2012-03-19  692  
32a7627cf3a353 drivers/md/bitmap.c    NeilBrown         2005-06-21  693  	/* assign fields using values from superblock */
4f2e639af4bd5e drivers/md/bitmap.c    NeilBrown         2006-10-21  694  	bitmap->flags |= le32_to_cpu(sb->state);
bd926c63b7a684 drivers/md/bitmap.c    NeilBrown         2005-11-08  695  	if (le32_to_cpu(sb->version) == BITMAP_MAJOR_HOSTENDIAN)
b405fe91e50c60 drivers/md/bitmap.c    NeilBrown         2012-05-22  696  		set_bit(BITMAP_HOSTENDIAN, &bitmap->flags);
32a7627cf3a353 drivers/md/bitmap.c    NeilBrown         2005-06-21  697  	bitmap->events_cleared = le64_to_cpu(sb->events_cleared);
cf921cc19cf7c1 drivers/md/bitmap.c    Goldwyn Rodrigues 2014-03-30  698  	strlcpy(bitmap->mddev->bitmap_info.cluster_name, sb->cluster_name, 64);
32a7627cf3a353 drivers/md/bitmap.c    NeilBrown         2005-06-21  699  	err = 0;
b97e92574c0bf3 drivers/md/bitmap.c    Goldwyn Rodrigues 2014-06-06  700  
32a7627cf3a353 drivers/md/bitmap.c    NeilBrown         2005-06-21  701  out:
b2f46e68825648 drivers/md/bitmap.c    Cong Wang         2011-11-28  702  	kunmap_atomic(sb);
f9fd5e55a60521 drivers/md/md-bitmap.c Heming Zhao       2022-03-25  703  	if (err == 0 && nodes && (bitmap->cluster_slot < 0)) {
3560741e316b3e drivers/md/bitmap.c    Zhilong Liu       2017-03-15  704  		/* Assigning chunksize is required for "re_read" */
f9209a323547f0 drivers/md/bitmap.c    Goldwyn Rodrigues 2014-06-06  705  		bitmap->mddev->bitmap_info.chunksize = chunksize;
b97e92574c0bf3 drivers/md/bitmap.c    Goldwyn Rodrigues 2014-06-06  706  		err = md_setup_cluster(bitmap->mddev, nodes);
b97e92574c0bf3 drivers/md/bitmap.c    Goldwyn Rodrigues 2014-06-06  707  		if (err) {
ec0cc226854a79 drivers/md/bitmap.c    NeilBrown         2016-11-02  708  			pr_warn("%s: Could not setup cluster service (%d)\n",
b97e92574c0bf3 drivers/md/bitmap.c    Goldwyn Rodrigues 2014-06-06  709  				bmname(bitmap), err);
b97e92574c0bf3 drivers/md/bitmap.c    Goldwyn Rodrigues 2014-06-06  710  			goto out_no_sb;
b97e92574c0bf3 drivers/md/bitmap.c    Goldwyn Rodrigues 2014-06-06  711  		}
b97e92574c0bf3 drivers/md/bitmap.c    Goldwyn Rodrigues 2014-06-06  712  		bitmap->cluster_slot = md_cluster_ops->slot_number(bitmap->mddev);
b97e92574c0bf3 drivers/md/bitmap.c    Goldwyn Rodrigues 2014-06-06  713  		goto re_read;
b97e92574c0bf3 drivers/md/bitmap.c    Goldwyn Rodrigues 2014-06-06  714  	}
b97e92574c0bf3 drivers/md/bitmap.c    Goldwyn Rodrigues 2014-06-06  715  
b97e92574c0bf3 drivers/md/bitmap.c    Goldwyn Rodrigues 2014-06-06  716  
ef99bf480de9bd drivers/md/bitmap.c    NeilBrown         2012-05-22  717  out_no_sb:
b405fe91e50c60 drivers/md/bitmap.c    NeilBrown         2012-05-22  718  	if (test_bit(BITMAP_STALE, &bitmap->flags))
ef99bf480de9bd drivers/md/bitmap.c    NeilBrown         2012-05-22  719  		bitmap->events_cleared = bitmap->mddev->events;
f9fd5e55a60521 drivers/md/md-bitmap.c Heming Zhao       2022-03-25  720  	if (err == 0) {
ef99bf480de9bd drivers/md/bitmap.c    NeilBrown         2012-05-22  721  		bitmap->mddev->bitmap_info.chunksize = chunksize;
ef99bf480de9bd drivers/md/bitmap.c    NeilBrown         2012-05-22  722  		bitmap->mddev->bitmap_info.daemon_sleep = daemon_sleep;
ef99bf480de9bd drivers/md/bitmap.c    NeilBrown         2012-05-22  723  		bitmap->mddev->bitmap_info.max_write_behind = write_behind;
c4ce867fdad200 drivers/md/bitmap.c    Goldwyn Rodrigues 2014-03-29  724  		bitmap->mddev->bitmap_info.nodes = nodes;
f9fd5e55a60521 drivers/md/md-bitmap.c Heming Zhao       2022-03-25  725  	}
1dff2b87a34a1a drivers/md/bitmap.c    NeilBrown         2012-05-22  726  	if (bitmap->mddev->bitmap_info.space == 0 ||
1dff2b87a34a1a drivers/md/bitmap.c    NeilBrown         2012-05-22  727  	    bitmap->mddev->bitmap_info.space > sectors_reserved)
1dff2b87a34a1a drivers/md/bitmap.c    NeilBrown         2012-05-22  728  		bitmap->mddev->bitmap_info.space = sectors_reserved;
b97e92574c0bf3 drivers/md/bitmap.c    Goldwyn Rodrigues 2014-06-06  729  	if (err) {
e64e4018d57271 drivers/md/md-bitmap.c Andy Shevchenko   2018-08-01  730  		md_bitmap_print_sb(bitmap);
f9209a323547f0 drivers/md/bitmap.c    Goldwyn Rodrigues 2014-06-06  731  		if (bitmap->cluster_slot < 0)
b97e92574c0bf3 drivers/md/bitmap.c    Goldwyn Rodrigues 2014-06-06  732  			md_cluster_stop(bitmap->mddev);
b97e92574c0bf3 drivers/md/bitmap.c    Goldwyn Rodrigues 2014-06-06  733  	}
32a7627cf3a353 drivers/md/bitmap.c    NeilBrown         2005-06-21  734  	return err;
32a7627cf3a353 drivers/md/bitmap.c    NeilBrown         2005-06-21  735  }

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp 
_______________________________________________
kbuild mailing list -- kbuild@lists.01.org
To unsubscribe send an email to kbuild-leave@lists.01.org

