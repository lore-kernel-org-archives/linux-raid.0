From: Raul Dias <raul@dias.com.br>
Subject: Manually reconstruct a RAID10 from adaptec 3805
Date: Mon, 20 Jan 2014 18:01:11 -0200
Message-ID: <CAE6VuKFnEjPsq=aeQXU4Jfn_3kD1TE19gRGk3YGdUXGTdgN+xg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I have a failled RAID 10 in a remote server.  The controller show all
drives as "offline"
In order to recover it, I will try to reconstruct the fs from disk images.

Does anyone have a clue on how adaptec layouts its raid10 disks?

So far, all information I have is this:
http://www.unixwiz.net/techtips/recovering-failed-raid.html

However, it is from 2008 and a raid1 only.
Can anyone point me in the right direction?

thanks,

-rsd
