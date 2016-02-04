From: Stefan Lamby <webmaster@peter-speer.de>
Subject: Re: Raid 1 needs repair
Date: Thu, 4 Feb 2016 18:41:09 +0100 (CET)
Message-ID: <43098506.459602.1454607669214.JavaMail.open-xchange@app01.ox.hosteurope.de>
References: <285536573.454192.1454595669809.JavaMail.open-xchange@app01.ox.hosteurope.de> <56B36577.2030902@turmel.org> <1161942166.457494.1454601803851.JavaMail.open-xchange@app01.ox.hosteurope.de> <56B38012.5020404@turmel.org>
Reply-To: Stefan Lamby <webmaster@peter-speer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <56B38012.5020404@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


> You may also need "mdadm --zero-superblock /dev/sda1" before the add
> command.
>
> But if it's currently active in the array, why do you need to fail it?

So this is the right way?

mdadm --manage /dev/md0 --remove /dev/sda1 # remove failed disk from array
mdadm --zero-superblock /dev/sda1
mdadm --manage /dev/md0 --add /dev/sda1 # add new disk to array (assumed same or
greater space for partition)
