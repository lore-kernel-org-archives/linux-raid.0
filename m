From: Curtis <serverascode@gmail.com>
Subject: Determining if a stripe/RAID0 has failed
Date: Tue, 9 Jul 2013 15:33:29 -0600
Message-ID: <CAJ_JamCpdFHRyYOzEg=yH4k_rv0KnZD8UJ_GwvSrSmHHOSzFAA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi All,

I'm wondering what the best way to determine when a RAID0 has failed?

We have some stateless servers that use a stripe/RAID0, but we'll need
to know if it failed so we can pull it out of the "cluster" and
rebuild it. It would be better to find out sooner than later that the
stripe has failed.

I know from reading the man page that I can't use mdadm to monitor the
stripe. Is it basically just that the device becomes unusable in some
fashion?

Thanks for any pointers,
Curtis.
