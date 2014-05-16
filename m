From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: High CPU usage / low speed when reading from degraded RAID6
Date: Fri, 16 May 2014 21:54:59 +0100
Message-ID: <CADNH=7H4bfRaZqTcFy9Kxtuvbpw9ijomUNs+R45HM1yVJ3NXkQ@mail.gmail.com>
References: <CAAOsTSnE+E0WT1Hkv65dMQXP1EDXC_V5iN3UoO6wsf45qDTGMg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAOsTSnE+E0WT1Hkv65dMQXP1EDXC_V5iN3UoO6wsf45qDTGMg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: patrik@dsl.sk
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 16 May 2014 21:33, Patrik Horn=C3=ADk <patrik@dsl.sk> wrote:
> Hello,
>
> I have one more issue with degraded RAID6 array with left-symmetric
> layout. When I am reading from RAID6 with 3 active drives from 4 the
> operation is CPU bound on decent CPU and I get max seq read cca 50
> MB/s. Drives are modern 150 MB/s HDDs.
>
> I did not look into how hard it is to compute data from P / Q yet. Is
> it that hard that it needs to consume so much CPU performance or is i=
t
> not optimal implementation in md?
>
> Thanks.
>
> Patrik
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


'top' or 'htop' or even 'atop'
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
