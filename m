From: Jon Nelson <jnelson-linux-raid@jamponi.net>
Subject: mdadm 3.0.3 bug report
Date: Mon, 9 Nov 2009 09:43:29 -0600
Message-ID: <cccedfc60911090743m77b26b7bx98bf5d18b7e96311@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I tried to create a raid thusly:
mdadm --create /dev/md3 --level=10 --layout=f2 --metadata=ddf
--raid-devices=2 --assume-clean /dev/sdc1 missing
and while I got a non-zero exit code (1), I did not get an error
message or any other indication of failure.

The misfeature is that I expected some sort of message.

-- 
Jon
