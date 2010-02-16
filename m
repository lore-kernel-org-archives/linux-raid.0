From: =?ISO-8859-1?Q?Kristleifur_Da=F0ason?= <kristleifur@gmail.com>
Subject: Re: Auto Checking Raid 6 crashes my system
Date: Tue, 16 Feb 2010 13:37:51 +0000
Message-ID: <73e903671002160537m571a48e1v6e652410554e8a49@mail.gmail.com>
References: <adf93d751002152104w52b329fdx9eb54719f1c8587a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <adf93d751002152104w52b329fdx9eb54719f1c8587a@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dawning Sky <the.dawning.sky@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Feb 16, 2010 at 5:04 AM, Dawning Sky <the.dawning.sky@gmail.com=
> wrote:
> Hi,
>
> I just build a brand new md raid-6 with 5 disks. =A0And on Fedora 12,
> the auto checking of md devices via a weekly cron job is enabled by
> default. =A0It performs the checking by echo "check" into
> /sys/block/mdX/md/sync_action. =A0But after a while, the kernel just
> crashes, without finishing checking the raid device or leaving
> anything in the messages file.
>
> For now, I've disable the raid-check cron job. =A0The kernel version =
I'm
> running is 2.6.31.12-174.2.3.fc12.x86_64.
>
> Thanks,
>
> DS


Hi,

I encountered similar issues because of a faulty mvsas driver that
flaked out under the load. What hardware do you have?

-- Kristleifur
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
