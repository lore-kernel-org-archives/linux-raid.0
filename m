From: =?ISO-8859-1?Q?Patrik_Horn=EDk?= <patrik@dsl.sk>
Subject: High CPU usage / low speed when reading from degraded RAID6
Date: Fri, 16 May 2014 22:33:24 +0200
Message-ID: <CAAOsTSnE+E0WT1Hkv65dMQXP1EDXC_V5iN3UoO6wsf45qDTGMg@mail.gmail.com>
Reply-To: patrik@dsl.sk
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I have one more issue with degraded RAID6 array with left-symmetric
layout. When I am reading from RAID6 with 3 active drives from 4 the
operation is CPU bound on decent CPU and I get max seq read cca 50
MB/s. Drives are modern 150 MB/s HDDs.

I did not look into how hard it is to compute data from P / Q yet. Is
it that hard that it needs to consume so much CPU performance or is it
not optimal implementation in md?

Thanks.

Patrik
