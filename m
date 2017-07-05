From: Roman Mamedov <rm@romanrm.net>
Subject: Re: Linear device of two arrays
Date: Wed, 5 Jul 2017 21:42:50 +0500
Message-ID: <20170705214250.0ea99538@natsu>
References: <CALee7hZYgLNO2siDJNtFge_BoocTXX-9BSgRHmMJH8MaH6V3LA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CALee7hZYgLNO2siDJNtFge_BoocTXX-9BSgRHmMJH8MaH6V3LA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Veljko <veljko3@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 5 Jul 2017 17:34:09 +0200
Veljko <veljko3@gmail.com> wrote:

> Hello,
> 
> I have a RAID10 device which I have formated using the mkfs.xfs
> defaults (Stan helped me with this few years back). I reached 88%
> capacity and it is time to expand it. I bought 4 more drives to create
> another RIAD10 array. I would like to create linear device out of
> those two and grow XFS across the 2nd device. How can this be done
> without loosing the existing device's data? I would also like to add a
> spare HDD. Do I have to have a separate spare HDD for each array or
> one can be used by both of them?

Why make another RAID10? With modern versions of mdadm and kernel you should
be able to simply reshape the current RAID10 to increase the number of
devices used from 4 to 8.


-- 
With respect,
Roman
