From: Leslie Rhorer <lesrhorer@att.net>
Subject: checkarray not running or emailing
Date: Sun, 1 Mar 2020 15:03:37 -0600
Message-ID: <814aad65-fba3-334c-c4df-6b8f4bfc4193@att.net>
References: <814aad65-fba3-334c-c4df-6b8f4bfc4193.ref@att.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

     I have upgraded 2 of my servers to Debian Buster, and now neither 
one seems to be running checkarray automatically.  In addition, when I 
run checkarray manually, it isn't sending update emails on the status of 
the job.  Actually, I have never been able to figure out how checkarray 
runs.  One my older servers, there doesn't seem to be anything in 
/etc/crontab, /etc/cron.monthly, /etc/init.d/, /etc/mdadm/mdadm.conf, or 
/lib/systemd/system/ that would run checkarray.
