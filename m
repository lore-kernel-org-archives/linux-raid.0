From: Steve Bergman <sbergman27@gmail.com>
Subject: Just want to verify that 3-drive RAID10 is stable
Date: Sun, 2 Jun 2013 11:13:08 -0500
Message-ID: <CAO9HMNF3692RSW5m7+usUQk7LYCovnSRVFtg9=K5qt7=6sqECw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I'm setting up a Dell T310 server which has 4 SATA drives attached to
the onboard SATA controllers. The 3-drive + 1 spare RAID10 option
(really RAID1e, I suppose) supported by md looks quite attractive. But
I'd like to verify that it is known to be production quality stable
before using it. This will be running Scientific Linux 6.4 (AKA RHEL
6.4).

Thanks,
Steve Bergman
