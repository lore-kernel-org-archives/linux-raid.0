From: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Subject: Re: Last scrub date and result
Date: Sun, 12 Jan 2020 14:57:31 +0100
Message-ID: <CAJH6TXi9Wdg4TN4XwUxvnonReCPoaPije9+EE2s0sW7cdg3=Vg@mail.gmail.com>
References: <CAJH6TXjryixcArdcu_oVzmkEyktpMSb62YaUJvUv_Nd7k3mbDg@mail.gmail.com>
 <CAJH6TXgvvgg3w096PJ+wKT==ixxH8VTzzoRjTTcMhTJ_SDf2xQ@mail.gmail.com>
 <20200110173114.GA3701@lazy.lzy> <CAJH6TXgByNnaWkFo25SrkbR15XgN47b5VhzgWLX=LvMhH-A1VQ@mail.gmail.com>
 <20200110181703.GA7028@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200110181703.GA7028@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Il giorno ven 10 gen 2020 alle ore 19:17 Piergiorgio Sartor
<piergiorgio.sartor@nexgo.de> ha scritto:
> well, the time is available at script
> level and this can be logged.
> About the result, I guess it is possible
> to log as well.
> One option to investigate would be the
> "--wait" of mdadm.

What is logged when a scrub finished with errors ?
When everything succeed, "data-chec done" is wrote, but what in case of errors ?

Anyway, i'm still thinking that adding an explicit line on --detail
output would be very useful
