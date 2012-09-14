From: =?UTF-8?B?TmljY29sw7IgQmVsbGk=?= <darkbasic@linuxsystems.it>
Subject: Re: raid1 issue after disk failure: both disks of the array are still
 active
Date: Fri, 14 Sep 2012 09:54:38 +0200
Message-ID: <5052E2BE.2030307@linuxsystems.it>
References: <5051AF17.8010501@linuxsystems.it> <20120913103432.GA11764@cthulhu.home.robinhill.me.uk> <5051B992.7030200@linuxsystems.it> <CABYL=TpKD2B0vwTrHH=iFK3PcMWueEsi84ACRbBQkDXuiWG3kw@mail.gmail.com> <CABYL=TrQPH9aPVAGbqrGcFWuwbAs=7h2H3BjpjUZHRmnwzaC6Q@mail.gmail.com> <50520031.4010906@linuxsystems.it> <CABYL=TqfHqBz7uh165Oa9jhiTLe4fFjYuhMW+BYJNbiAstjY9w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CABYL=TqfHqBz7uh165Oa9jhiTLe4fFjYuhMW+BYJNbiAstjY9w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Il 13/09/2012 17:53, Roberto Spadim ha scritto:
> check the read error counters of you md in sys folder
> (max_read_errors,  device/errors)
> maybe it got a error and retried and readed without error

max_read_errors is 20 and md0/errors is 0. Unfortunately I did reboot in 
the meantime and I cannot manage to trigger the read error anymore while 
reading md0 :(
-- 
http://www.linuxsystems.it
