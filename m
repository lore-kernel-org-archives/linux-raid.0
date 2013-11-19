From: Martin Wilck <mwilck@arcor.de>
Subject: Re: MDADM 3.3 broken?
Date: Tue, 19 Nov 2013 21:38:34 +0100
Message-ID: <528BCC4A.5070201@arcor.de>
References: <CAGRSmLviYJtCfNiARKW0FvrJ0BUDrvhPnQy2drzbkf95-Gfpag@mail.gmail.com>	<528A7721.8080604@arcor.de>	<CAGRSmLvRVQtrkYPLS8NfRS+DvyS0xZ72cwVdLygb0w5KbVrARA@mail.gmail.com>	<20131119110110.396b2af3@notabene.brown> <CAGRSmLufpZV5qYa-jq17n_MTWY0oc9yX4USoc0PZsb1LJheGcQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRSmLufpZV5qYa-jq17n_MTWY0oc9yX4USoc0PZsb1LJheGcQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "David F." <df7729@gmail.com>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The question I have is why is there IMSM meta data on sdc2 at all?
IMSM metadata sit at the end of a block device. So I figure that sdc2 is
the last partition, and by some wird circumstance it's so large that it
includes the last sectors of the physical disk where the metadata
resides. That would be a bad idea, a dd if=/dev/zero of=/dev/sdc2 would
wipe not only the partition but also the RAID meta data.

Martin

