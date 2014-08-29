From: "Patrick J. LoPresti" <lopresti@gmail.com>
Subject: Units for mdadm --data-offset ?
Date: Fri, 29 Aug 2014 10:22:21 -0700
Message-ID: <CAKGkouuVrkjxSNOLqiNnd0OAByMw4iOLDgXVvQW0cMtRK5-sVw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

What are the units for the "--data-offset" flag to mdadm? I am
guessing kilobytes, but "--examine" displays the value in sectors, so
I am not sure.

Also, is the "data-offset" per-member, or for the RAID as an aggregate?

Forgive me if this is all documented somewhere, but I cannot find it.

Thanks!

 - Pat
