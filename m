From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: checkarray not running or emailing
Date: Wed, 11 Mar 2020 20:50:54 +0800
Message-ID: <10e2db3d-13e6-573f-18bd-1443d6a27884@fnarfbargle.com>
References: <814aad65-fba3-334c-c4df-6b8f4bfc4193.ref@att.net>
 <814aad65-fba3-334c-c4df-6b8f4bfc4193@att.net>
 <0ef54c89-b486-eb0b-8d70-a043ef089c9f@att.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <0ef54c89-b486-eb0b-8d70-a043ef089c9f@att.net>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Leslie Rhorer <lesrhorer@att.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/3/20 09:11, Leslie Rhorer wrote:
>      Is there seriously no one here who knows how checkarray was launched in previous versions?
> 
> On 3/1/2020 3:03 PM, Leslie Rhorer wrote:
>>     I have upgraded 2 of my servers to Debian Buster, and now neither one seems to be running checkarray automatically.  In addition, when I run checkarray manually, it isn't sending update emails on the status of the job.  Actually, I have never been able to figure out how checkarray runs.  One my older servers, there doesn't seem to be anything in /etc/crontab, /etc/cron.monthly, /etc/init.d/, /etc/mdadm/mdadm.conf, or /lib/systemd/system/ that would run checkarray.
> 

On mine it's in /etc/cron.d/mdadm

brad@srv:/etc/cron.d$ cat mdadm
#
# cron.d/mdadm -- schedules periodic redundancy checks of MD devices
#
# Copyright © martin f. krafft <madduck@madduck.net>
# distributed under the terms of the Artistic Licence 2.0
#

# By default, run at 00:57 on every Sunday, but do nothing unless the day of
# the month is less than or equal to 7. Thus, only run on the first Sunday of
# each month. crontab(5) sucks, unfortunately, in this regard; therefore this
# hack (see #380425).
57 0 * * 0 root if [ -x /usr/share/mdadm/checkarray ] && [ $(date +\%d) -le 7 ]; then /usr/share/mdadm/checkarray --cron --all --idle --quiet; fi

dpkg -L mdadm gave me a list of files and I just checked the cron entries.

I don't run anything that recent, but Debian is Debian.

Brad
-- 
An expert is a person who has found out by his own painful
experience all the mistakes that one can make in a very
narrow field. - Niels Bohr
