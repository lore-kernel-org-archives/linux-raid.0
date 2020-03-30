From: Reindl Harald <h.reindl@thelounge.net>
Subject: Re: mdcheck: slow system issues
Date: Mon, 30 Mar 2020 15:27:13 +0200
Message-ID: <5693a405-2722-03e9-2f63-c5916022dc60@thelounge.net>
References: <2933dddc-8728-51ac-1c60-8a47874966e4@molgen.mpg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2933dddc-8728-51ac-1c60-8a47874966e4@molgen.mpg.de>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Paul Menzel <pmenzel@molgen.mpg.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Am 30.03.20 um 14:18 schrieb Paul Menzel:
> How do you run `mdcheck` in production without noticeably affecting the
> system?

you can' for years

either lower "dev.raid.speed_limit_max" and wait ages for the raid check
or cripple system performance

i remember "dev.raid.speed_limit_max" did 10 years ago what it is
supposed to do: use that when the system is idle but slow down the
raid-check in case of heavy user-io

but the current drama exists for many years
