Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F27AC433EF
	for <linux-raid@archiver.kernel.org>; Wed,  1 Dec 2021 16:29:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237283AbhLAQdG (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 1 Dec 2021 11:33:06 -0500
Received: from de-smtp-delivery-102.mimecast.com ([194.104.111.102]:43144 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229783AbhLAQdF (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 1 Dec 2021 11:33:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1638376183;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bR1LElgMph1dgpda8tnon2tcIS7936nzbRl2UnPIpV4=;
        b=D8cxBnmHBAV/wrMs5x8VtVp0j7unaTq6jhcNaQwAtX9urasamEBFDz2E+9tK9tKlQnLVs5
        Ky0ThFJYCekQG2E6ZuhVPTulpAU33C/HIpWtQ8X3QvDc8QLGaFa0za/52/M7wly7R+L3Ok
        RXyJ+34PB/154GMPjrISElWdCoPBsdc=
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur04lp2054.outbound.protection.outlook.com [104.47.14.54]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-8-adN0Id8tOl-OKuK3nyUbdQ-1; Wed, 01 Dec 2021 17:29:41 +0100
X-MC-Unique: adN0Id8tOl-OKuK3nyUbdQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eHE39zCzpb1MX0UXwQgDcrhMYlcZvk/1xFdWHrUQn2Bfq5JalbqClED0962RPiEvniUoh2M7xr23Iuk+w5DFzJt6CZVkCy3eDmJ8AwYAvzKfrCGSQ2i5rCiz/Cy/eNkyOvZhM3YNPJFaS1czH2sVV+XfU+OTm3Ytt1Xrrpn6ZehwnIFvqXWwJchqA3aFlb0iAFC/KBiSoJiIMXx/WmncanwSCM6RQ3R9XpkxGEYAc3gY5yRbv8i5rIH9y7qQ+C/CEFBN4Ur8GhBVVPTHoR628qru7uB46iPXkpI0x6MyjQk8e2/p4o4jm9PV8dck+0CxAzi4enAMxtCVkKj0nJhLIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dimdRfrWuDnMyxxwIl7TIhEAYlmYw6Ez8RvrNUhCQ1o=;
 b=ewzJQ705vQClnBf1nXXfdC4iZxIotIg3P1Qjv50EmipJoL/Yk1Bx7+nZ82R/PVqPSwcaESYOxFzIn6sp/OHkrE45gnm9SFb6oEh5UM+GfJRaanUaPFqkCkoANoTvzUNTzz8I3E+g17nIjH0EbcKEv6IRLFEZ5HjHD5ne70QbEIrcuXX9kGBoFdvwuXcGAQ1EjjBtHBRFr8XAcOQk6UEFOimyUCCoNp3uI5DKviO9ZAeRXbAiuVG4EeKXKVlZlr+iNhCuLnSrgd50pzb3/tSnsnAJeFFHwFB6OwQy7Be6Cd1rgKS41ghmPfF9By5SNAG5LcZ6rEitdrxSQQ7Ei0Uz9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from AM0PR0402MB3811.eurprd04.prod.outlook.com (2603:10a6:208:d::27)
 by AM0PR04MB6948.eurprd04.prod.outlook.com (2603:10a6:208:187::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11; Wed, 1 Dec
 2021 16:28:40 +0000
Received: from AM0PR0402MB3811.eurprd04.prod.outlook.com
 ([fe80::cc6d:83f8:8f41:e72]) by AM0PR0402MB3811.eurprd04.prod.outlook.com
 ([fe80::cc6d:83f8:8f41:e72%5]) with mapi id 15.20.4734.024; Wed, 1 Dec 2021
 16:28:40 +0000
Message-ID: <73287b77-33aa-a9bd-7efa-5816e098f02f@suse.com>
Date:   Wed, 1 Dec 2021 17:28:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Content-Language: en-US
To:     Coly Li <colyli@suse.de>,
        mtkaczyk <mariusz.tkaczyk@linux.intel.com>
CC:     linux-raid@vger.kernel.org, Neil Brown <neilb@suse.de>,
        Jes Sorensen <jsorensen@fb.com>
References: <20211201062245.6636-1-colyli@suse.de>
 <20211201170843.00005f69@linux.intel.com>
 <9ee380c8-e43b-8f58-c7d5-5bddb6f2e688@suse.de>
From:   Benjamin Brunner <bbrunner@suse.com>
Subject: Re: [PATCH] mdadm/systemd: change KillMode from none to mixed in
 service files
In-Reply-To: <9ee380c8-e43b-8f58-c7d5-5bddb6f2e688@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: AS9PR07CA0021.eurprd07.prod.outlook.com
 (2603:10a6:20b:46c::26) To AM0PR0402MB3811.eurprd04.prod.outlook.com
 (2603:10a6:208:d::27)
MIME-Version: 1.0
Received: from [192.168.178.80] (87.164.29.157) by AS9PR07CA0021.eurprd07.prod.outlook.com (2603:10a6:20b:46c::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.9 via Frontend Transport; Wed, 1 Dec 2021 16:28:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e36f282a-4e25-42b7-2d4f-08d9b4e7a24d
X-MS-TrafficTypeDiagnostic: AM0PR04MB6948:
X-Microsoft-Antispam-PRVS: <AM0PR04MB6948580A9D3FF0A37FFF31CBB5689@AM0PR04MB6948.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:758;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dSjCu+qFNffH3/qnGI85wLJUVGjG295M2UaFfantcp/p3wb5G4VULh2IAx/BrhMM50LJyrevVi6odA2SwfryCAeLaTlrNe40suZmnfL4saDLn55nvEjuLpzSxV/02i+lOa0DTjFWGR89w7M+tDZK5fZgfabHzmg5OGcEUSezJQe1u5/vbuHN7dsMkO+RNt7MzCtVea75AfA2MdDBDA1gaboZWa15qgMjXBD2fFiUfO875zyqGfExwY54LMJJcHCvDZbH9WhVoTbMrecL/ELBR9n4NbwWPMPsVzE16hFa9Hk+oIu3fVOXK4QbX3xNxwnaaDToRofjhB6HjmAbr0JjueAB96y8X6Hm1uuBSLuWTHDnDI6PxjU89+yxwGFHrbJodrIBr4rNKkQGc+vB+VIstrG/ElmzBn+ecAMpmtlzbXtXnM+Ku0GbqyjIrzUYTklAtbUUbbVduhcNXZio7d9Z5BG/NDZ+G60XFgbA82Pq/svdvEii9v87swf1904qti236C1+fpZf9qKCUZotK7lBIjqglQ9B77PZpFHpjBOoYIOoQnKQuFylViuBkbOj2d6/Veb23hPN/1KctdL4b26Lp0Up7qOLOFEjmm+5vN5COZMb7vTK0f1FWor/N8MpJCAIV+NE6r7p+mak4VhJIw/jGYb4LpodotVgRKr903RPpyHQdvWp8T26gbR1kBBjeLY87dHO86INj2mtfgBbJn4e2d+Iet4OTrcmrVglg0GdSUw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR0402MB3811.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(16576012)(316002)(966005)(186003)(54906003)(5660300002)(110136005)(8676002)(38100700002)(8936002)(6486002)(508600001)(4326008)(31686004)(956004)(2616005)(36756003)(31696002)(66946007)(66476007)(53546011)(66556008)(26005)(86362001)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/NxTM1VYw7rNETNO86VrJrMHF1d76m0DaDj5KnHRWaGukBe+q3+fZGA8SDm9?=
 =?us-ascii?Q?HnO0gXVv/Lra5O7m+mZZIptkUriQgfTG+ufPhr2EgAdk6dVCyjJ1lW/pQDN8?=
 =?us-ascii?Q?dT/nlQjPT6urqh09NyYSnE9GHtgBJHAKSvF0MISyikPwr0ku0s0NQUsojxkB?=
 =?us-ascii?Q?+odth94DuyY9AKAFgV46qGjhunXVXAdbYCwAeGPd4COf6uT6e7X0Kawzacwa?=
 =?us-ascii?Q?AMvENLTqtYm4pA41oAnlZ4kS03OtGD99o0XiEx/GVeUWLWhbyhWu/4e8pDty?=
 =?us-ascii?Q?FRi0cZlrUb8CAfPRoSX+CsIwmAxuPUxSW0pGoOCJR6g+lrvq+u6fqyhXwvSX?=
 =?us-ascii?Q?9P2WBpdjUNwLYcLfjKXefX8w+pvoOAfEX21VcMSr+WWVVbew0jzzQc7idnX9?=
 =?us-ascii?Q?aT4Pl4w7P/z6ImErlFjQEXl4HNip5oO1pqZ1Chdv3dxWQQSsnM7NCTK3nGDM?=
 =?us-ascii?Q?3UvhDOT/joYoP/GAqWoKCGv29C7a2D1uDesWow6iCqBEdKiiRw2G+XsW6YV1?=
 =?us-ascii?Q?PKK57eGnJFYe47MwmD50B3uH6gnPlmc2qsGKhM7pVXQWSzWYFnNAWldB77Fa?=
 =?us-ascii?Q?RYeYjQxiZf0e8c7XqnNXwXixOVIJhNO13XTGGr1mPm5hIVh9ddKx+Relo1dr?=
 =?us-ascii?Q?2EdfD4K53uZp427FwSLKhTkOEwi5Ib6msZqoUmov8tQsk8LCeqC87wY3kq1p?=
 =?us-ascii?Q?FvPSyYuPkExnsvmdDgOKFeL3FstL5BPwc2qIiSVhz/qPG6FWQUDZ6TKoWEkA?=
 =?us-ascii?Q?TzTfcDJWKObBDj8DpLVrdFcRnRDvfP7oxT3TkMX3jMQr6oecC6WWBrlUKxJG?=
 =?us-ascii?Q?ZvcEhbHnAzNSGkIxGevaoOdUHQ4jQxd0R03Vz2Z6N5yngVYUk9F/cvRnAtIc?=
 =?us-ascii?Q?Cl/rWda40KsNxZHRK7kjD6w56ydjmpCe5lHVBzlgrs/hAc+MJetB85pVWzKk?=
 =?us-ascii?Q?qRH/qPbwH4tJq08I3eFPiIzs/y35iPgLNXKwtKtuZYb8PE2DgdtNOaNeBzDA?=
 =?us-ascii?Q?02dXFF/0B4fBQUWlWXYrIBWKQyoktKdet+SjaiscX+5gjZ4qT46sEsGHnRVF?=
 =?us-ascii?Q?x9CaMDI6qKy+paeE6Ls1LGSF0Fk6Q88m33cvZYOb5yeu+0QLxmbUfalADb8M?=
 =?us-ascii?Q?JcqtZD+hRGy8j7HYTX/DA3usAPJQNnNoWicy442/q39i8yiBwH8UBeEgtCx1?=
 =?us-ascii?Q?eHPZPeGFfe3gsOlmyAGsAUVrewSJktIDq3HH/zGUcUsW14GssrSwyDDORxnx?=
 =?us-ascii?Q?+BL+7QKW3SD0hDo1jat/j/Y0EtwlJErfKaTTdYriV/55szhn6UNgwO5cy7D+?=
 =?us-ascii?Q?cZYQN9WCk6SO7lO986DgKhTUuHYgLtgOl/k3hi9RNIJN7bpPWMiV+NxZ/vWo?=
 =?us-ascii?Q?y9JyOioloEq67YbzjDwX9uoZp0/0v7eS8CyriF0Xz5LfuvPl3FqdVJTZTf7S?=
 =?us-ascii?Q?0ogofgfyCpNGL5Cyj/XXfekvLtDnInczcZle5d2AzQQj8UTKH2s94w+VnTJH?=
 =?us-ascii?Q?B9KFh0nuxloH1Iz2HzW01jZHmroxVqRQXy7sYfgN4wfCgWDJryMeoAi+A4iG?=
 =?us-ascii?Q?M8xi3slhm1MYeCaWlU60lf0uZRKeJJAXOTzUgVDbkn+opBj9FGI9DtuYWpR0?=
 =?us-ascii?Q?pWbPA+InBSeIel9Jd2IoHu8=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e36f282a-4e25-42b7-2d4f-08d9b4e7a24d
X-MS-Exchange-CrossTenant-AuthSource: AM0PR0402MB3811.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2021 16:28:40.5116
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A97KFK7CIBo2m4Qy8txvLbcRHUHb6IIcsTfiuCu/CgJ/3I9al5hZbfGZhZVA0BVClRZLaai2TnmdrrqK1Vz4lw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6948
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi all,

On 01.12.21 17:23, Coly Li wrote:
> On 12/2/21 12:08 AM, mtkaczyk wrote:
>> Hi Coly,
>>
>>> This patch changes KillMode in above listed service files from "none"
>>> to "mixed", to follow systemd recommendation and avoid potential
>>> unnecessary issue.
>> What about mdmonitor.service? Should we add it there too? Now it is not
>> defined.
>=20
> It was overlooked when I did grep KillMode. Yes, I agree=20
> mdmonitor.service should have a KillMode key word as well.
>=20
> Let me post a v2 version.
>=20
JFYI, when KillMode is not set, it defaults to KillMode=3Dcontrol-group,=20
see https://www.freedesktop.org/software/systemd/man/systemd.kill.html.

Therefore, it shouldn't be necessary to explicitly add it (as long as=20
control-group is working in case of mdmonitor.service, of course).

Best
Benjamin

>>> Cc: Jes Sorensen <jsorensen@fb.com>
>> Not sure if it a problem but Jes uses: jes@trained-monkey.org for
>> communication with linux-raid.
>=20
> Copied. Thanks for the hint.
>=20
> Coly Li
>=20

--=20
Benjamin Brunner
Engineering Manager System Boot and Init
SUSE Software Solutions Germany GmbH
Maxfeldstr. 5
90409 N=C3=BCrnberg
Germany

HRB 36809, AG N=C3=BCrnberg
Gesch=C3=A4ftsf=C3=BChrer: Ivo Totev

