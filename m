From: Michael Busby <michael.a.busby@gmail.com>
Subject: Raid5 to another raid level??
Date: Thu, 1 Sep 2011 22:50:31 +0100
Message-ID: <CAFsPQ_-i_tdPYoT+AF76c7cKNnmt_Ah6KU8EqnYgx3BcyCYNGg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have found the following and see that you can convert from raid4 to
raid0 fairly easy


http://ubuntuforums.org/showpost.php?p=10412231&postcount=20

i have a 2 disk raid5 and want to be able to convert this to raid0, i
was thinking of adding a extra 2 disk and setting them up as raid0,
moving the data over then adding the original raid5 disks to the raid0
setup, but i see that you are unable to add disk to a raid0 setup,
would it be possible to setup a raid4 with 2 disks and 1 missing, move
the data from the raid5 to raid4 then add both of the original disks
to the raid4 the downgrade this to raid0???
