From: "David C. Rankin" <drankinatty@suddenlinkmail.com>
Subject: Re: Help with degraded array
Date: Sat, 14 Dec 2013 04:38:22 -0600
Message-ID: <52AC351E.5050709@suddenlinkmail.com>
References: <CAB1R3shBH5sAq6qDL4aQcxERA3mMo5UBJGTvVS20JjyW0ZyZLA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAB1R3shBH5sAq6qDL4aQcxERA3mMo5UBJGTvVS20JjyW0ZyZLA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 12/13/2013 04:11 PM, Alex wrote:
> I'd really appreciate any guidance you could provide.
> 
> Thanks,
> Alex

It simply looks like the drive designation changed /dev/sda -> /dev/sdc and
mdadm kicked sda out of the array because it wasn't there. Are you not using
UUID designation to assemble the arrays? What does your /etc/mdadm.conf look like?

It looks like you could add /dev/sdc3 back into the array, let it rebuild if
necessary, then use:

 mdadm --detail --scan >> /etc/mdadm.conf

To create a new UUID based mdadm.conf that would prevent this from happening again.

-- 
David C. Rankin, J.D.,P.E.
