From: Roman Mamedov <rm@romanrm.net>
Subject: Re: Raid5 performance issue
Date: Sat, 24 Dec 2016 11:46:35 +0500
Message-ID: <20161224114635.46c340f1@natsu>
References: <H0000071000db2da.1482500583.sx.f1-outsourcing.eu*@MHS>
        <CAFx4rwQY3zF3cz-WV+L72mtmJodrYjO-kP1MUhC4YeX=zLJWmA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAFx4rwQY3zF3cz-WV+L72mtmJodrYjO-kP1MUhC4YeX=zLJWmA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Dumitru <doug@easyco.com>
Cc: Marc Roos <M.Roos@f1-outsourcing.eu>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, 23 Dec 2016 11:24:13 -0800
Doug Dumitru <doug@easyco.com> wrote:

> With hard drives, I suspect your single disk tests are taking
> advantage of the disks' on-controller cache and is doing read-ahead
> and thus streaming.  With the array in place, you are probably doing
> 512K reads (check the array chunk size) so the disks will see bursts
> of 512K reads with big gaps.  The gaps are large enough that the
> rotation has gone too far and the caching makes you wait a rotation.
> This is just a guess.

You can compensate for that via setting a higher read-ahead for the array
itself, such as 

  blockdev --setra 8192 /dev/mdX 

(or more)

-- 
With respect,
Roman
